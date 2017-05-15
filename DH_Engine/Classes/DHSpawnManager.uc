//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DHSpawnManager extends SVehicleFactory;

const   SPAWN_POINTS_MAX = 48;
const   VEHICLE_POOLS_MAX = 32;
const   SPAWN_VEHICLES_MAX = 8;
const   SPAWN_PROTECTION_TIME = 2; // The full protection time given to players/vehicles (they cannot be damaged/killed within this time)

struct VehiclePoolSlot
{
    var ROVehicle   Vehicle;
    var int         RespawnTime;
};

struct VehiclePool
{
    var() name              Tag;
    var() class<ROVehicle>  VehicleClass;
    var() bool              bIsInitiallyActive;
    var() bool              bIsSpawnVehicle;
    var() float             RespawnTime;             // respawn interval in seconds
    var() byte              MaxSpawns;               // how many vehicles can be spawned from this pool
    var() byte              MaxActive;               // how many vehicles from this pool can be active at once
    var() bool              bIgnoreMaxTeamVehicles;  // if true, this vehicle will not add to the team's active vehicle count when spawned

    var() name              OnActivatedEvent;        // event to trigger when pool is activated (also gets triggered when initially activated)
    var() name              OnDeactivatedEvent;      // event to trigger when pool is deactivated (does NOT get triggered when initially deactivated)
    var() name              OnDepletedEvent;         // event to trigger when pool has been depleted (SpawnCount meets or exceeds MaxSpawns)
    var() name              OnDepleteActivatePool;   // vehicle pool to activate when this pool has been depleted (uses pool tag)
    var() name              OnVehicleDestroyedEvent; // event to trigger when vehicle from this pool is destroyed
    var() name              OnVehicleSpawnedEvent;   // event to trigger when vehicle from this pool is spawned

    var array<VehiclePoolSlot> Slots;
};

var()   array<VehiclePool>  VehiclePools;
var()   byte                MaxTeamVehicles[2];

var     private     array<ROVehicle>        Vehicles;
var     private     array<DHSpawnPoint>     SpawnPoints;
var     private     DHGameReplicationInfo   GRI;

function PostBeginPlay()
{
    local DHSpawnPoint SP;
    local int          i;

    GRI = DHGameReplicationInfo(Level.Game.GameReplicationInfo);

    if (GRI == none)
    {
        Warn("DHGameReplicationInfo is none");

        return;
    }

    // Build SpawnPoints array
    foreach AllActors(class'DHSpawnPoint', SP)
    {
        if (SpawnPoints.Length >= SPAWN_POINTS_MAX)
        {
            Warn("DHSpawnPoint count exceeds" @ SPAWN_POINTS_MAX);

            break;
        }

        SpawnPoints[SpawnPoints.Length] = SP;
    }

    // Check VehiclePools array
    for (i = VehiclePools.Length - 1; i >= 0; --i)
    {
        // VP doesn't have a specified vehicle class, so is invalid
        if (VehiclePools[i].VehicleClass == none)
        {
            // Remove VP if it is invalid (no specified class or it's a duplicate)
            Warn("VehiclePools[" $ i $ "] is invalid & has been removed! (VehicleClass =" @ VehiclePools[i].VehicleClass $ ")");
            VehiclePools.Remove(i, 1);
        }
    }

    for (i = 0; i < VehiclePools.Length; ++i)
    {
        // VP is valid so copy to GRI, set length of its Slots array, & pre-cache the vehicle class
        GRI.VehiclePoolVehicleClasses[i] = VehiclePools[i].VehicleClass;
        GRI.VehiclePoolIsSpawnVehicles[i] = byte(VehiclePools[i].bIsSpawnVehicle);

        if (VehiclePools[i].bIgnoreMaxTeamVehicles)
        {
            GRI.VehiclePoolIgnoreMaxTeamVehiclesFlags = GRI.VehiclePoolIgnoreMaxTeamVehiclesFlags | (1 << i);
        }

        if (VehiclePools[i].MaxActive != 255)
        {
            VehiclePools[i].Slots.Length = VehiclePools[i].MaxActive;
        }

        if (Level.NetMode != NM_DedicatedServer)
        {
            VehiclePools[i].VehicleClass.static.StaticPrecache(Level);
        }
    }

    // Copy the set maximum number of vehicles for each team to the GRI
    for (i = 0; i < arraycount(GRI.MaxTeamVehicles); ++i)
    {
        GRI.MaxTeamVehicles[i] = MaxTeamVehicles[i];
    }
}

function Reset()
{
    local int i, j;

    for (i = 0; i < SpawnPoints.Length; ++i)
    {
        SetSpawnPointIsActive(i, SpawnPoints[i].bIsInitiallyActive);
        SpawnPoints[i].bIsLocked = SpawnPoints[i].bIsInitiallyLocked;
    }

    for (i = 0; i < VehiclePools.Length; ++i)
    {
        SetVehiclePoolIsActive(i, VehiclePools[i].bIsInitiallyActive);

        GRI.VehiclePoolMaxActives[i] = VehiclePools[i].MaxActive;
        GRI.VehiclePoolMaxSpawns[i] = VehiclePools[i].MaxSpawns;
        GRI.VehiclePoolNextAvailableTimes[i] = 0.0;
        GRI.VehiclePoolSpawnCounts[i] = 0;
        GRI.VehiclePoolReservationCount[i] = 0;

        for (j = 0; j < VehiclePools[i].Slots.Length; ++j)
        {
            VehiclePools[i].Slots[j].Vehicle = none;
            VehiclePools[i].Slots[j].RespawnTime = 0;
        }
    }

    super.Reset();
}

function bool SpawnPlayer(DHPlayer PC)
{
    local DHSpawnPointBase SP;
    local bool bResult;
    local DHPawn P;

    if (PC != none)
    {
        SP = GRI.GetSpawnPoint(PC.SpawnPointIndex);

        if (SP != none)
        {
            bResult = SP.PerformSpawn(PC);

            if (bResult)
            {
                P = DHPawn(PC.Pawn);

                if (P != none)
                {
                    P.SpawnPoint = SP;
                    P.bCombatSpawned = SP.bCombatSpawn;
                }
            }

            return bResult;
        }
    }

    return false;
}

function ROVehicle SpawnVehicle(DHPlayer PC, vector SpawnLocation, rotator SpawnRotation)
{
    local ROVehicle V;
    local int       i;
    local DHPlayerReplicationInfo PRI;
    local DHSpawnPointBase SP;
    local DHVehicle DHV;

    if (PC == none || PC.Pawn != none)
    {
        return none;
    }

    SP = GRI.SpawnPoints[PC.SpawnPointIndex];

    if (SP == none || !SP.CanSpawnWithParameters(GRI, PC.GetTeamNum(), PC.GetRoleIndex(), PC.GetSquadIndex(), PC.VehiclePoolIndex))
    {
        return none;
    }

    PRI = DHPlayerReplicationInfo(PC.PlayerReplicationInfo);

    // Make sure player isn't excluded from a tank crew role
    if (VehiclePools[PC.VehiclePoolIndex].VehicleClass.default.bMustBeTankCommander &&
        (PRI == none || PRI.RoleInfo == none || !PRI.RoleInfo.bCanBeTankCrew))
    {
        return none;
    }

    if (!GRI.CanSpawnVehicle(PC.VehiclePoolIndex))
    {
        return none;
    }

    // This calls old RestartPlayer (spawns player in black room) & avoids reinforcement subtraction (because we will subtract later)
    if (DarkestHourGame(Level.Game) != none)
    {
        DarkestHourGame(Level.Game).DeployRestartPlayer(PC, false, true);
    }

    if (PC.Pawn == none)
    {
        return none;
    }

    // Now spawn the vehicle (& make sure it was successful)
    V = Spawn(VehiclePools[PC.VehiclePoolIndex].VehicleClass, self,, SpawnLocation, SpawnRotation);

    if (V == none)
    {
        return none;
    }

    // If we successfully enter the vehicle
    if (V.TryToDrive(PC.Pawn))
    {
        // Set vehicle properties & add to our Vehicles array
        V.SetTeamNum(V.default.VehicleTeam);
        V.ParentFactory = self;
        Vehicles[Vehicles.Length] = V;

        DHV = DHVehicle(V);

        // Start engine
        if (DHV != none && DHV.bEngineOff)
        {
            DHV.ServerStartEngine();
        }

        // If this vehicle is a spawn vehicle, create the spawn point attachment
        if (VehiclePools[PC.VehiclePoolIndex].bIsSpawnVehicle)
        {
            if (DHV != none)
            {
                DHV.SpawnPointAttachment = DHSpawnPoint_Vehicle(DHV.SpawnAttachment(class'DHSpawnPoint_Vehicle'));

                if (DHV.SpawnPointAttachment != none)
                {
                    DHV.SpawnPointAttachment.Vehicle = DHV;
                    DHV.SpawnPointAttachment.TeamIndex = V.default.VehicleTeam;
                    DHV.SpawnPointAttachment.SetIsActive(true);
                }
            }
        }

        // Increment vehicle counts
        ++GRI.TeamVehicleCounts[V.default.VehicleTeam];

        if (!VehiclePools[PC.VehiclePoolIndex].bIgnoreMaxTeamVehicles)
        {
            --GRI.MaxTeamVehicles[V.default.VehicleTeam];
        }

        ++GRI.VehiclePoolActiveCounts[PC.VehiclePoolIndex];
        ++GRI.VehiclePoolSpawnCounts[PC.VehiclePoolIndex];

        // Assign newly spawned vehicle to a VehiclePools slot so we can track its respawn time, & set controller's NextVehicleSpawnTime
        for (i = 0; i < VehiclePools[PC.VehiclePoolIndex].Slots.Length; ++i)
        {
            if (VehiclePools[PC.VehiclePoolIndex].Slots[i].Vehicle == none)
            {
                VehiclePools[PC.VehiclePoolIndex].Slots[i].Vehicle = V;
                break;
            }
        }

        // TODO: remove magic number
        PC.NextVehicleSpawnTime = GRI.ElapsedTime + 60;

        // Trigger any OnVehicleSpawnedEvent
        if (VehiclePools[PC.VehiclePoolIndex].OnVehicleSpawnedEvent != '')
        {
            TriggerEvent(VehiclePools[PC.VehiclePoolIndex].OnVehicleSpawnedEvent, self, none);
        }

        // Set spawn protection variables for the vehicle
        if (DHVehicle(V) != none)
        {
            DHVehicle(V).SpawnProtEnds = Level.TimeSeconds + Min(SPAWN_PROTECTION_TIME, SP.SpawnProtectionTime);
            DHVehicle(V).SpawnKillTimeEnds = Level.TimeSeconds + SP.SpawnProtectionTime;
            DHVehicle(V).SpawnPoint = SP;
        }

        // Set spawn protection variables for the player that spawned the vehicle
        if (DHPawn(V.Driver) != none)
        {
            DHPawn(V.Driver).SpawnProtEnds = Level.TimeSeconds + Min(SPAWN_PROTECTION_TIME, SP.SpawnProtectionTime);
            DHPawn(V.Driver).SpawnKillTimeEnds = Level.TimeSeconds + SP.SpawnProtectionTime;
            DHPawn(V.Driver).SpawnPoint = SP;
        }

        // Decrement reservation count
        GRI.UnreserveVehicle(PC);

        PC.bSpawnPointInvalidated = true;
    }
    // We were unable to enter the vehicle, so destroy it & kill the player, so they aren't stuck in the black room
    else
    {
        V.Destroy();
        PC.Pawn.Suicide();

        return none;
    }

    return V;
}

event VehicleDestroyed(Vehicle V)
{
    local ROVehicle ROV;
    local int       NextAvailableTime, i, j;
    local bool      bWasSpawnKilled;
    local DHVehicle DHV;

    const SPAWN_KILL_RESPAWN_TIME = 2;

    super.VehicleDestroyed(V);

    DHV = DHVehicle(V);

    if (DHV != none)
    {
        // Find out if the vehicle was spawned killed
        if (DHV.IsSpawnKillProtected())
        {
            if (DHV.SpawnPoint != none)
            {
                DHV.SpawnPoint.OnSpawnKill(V, none);
            }

            bWasSpawnKilled = true;
        }

        // Destroy spawn point attachment
        if (DHV.SpawnPointAttachment != none)
        {
            DHV.SpawnPointAttachment.Destroy();
        }
    }

    // Removes the destroyed vehicle from the managed Vehicles array
    for (i = Vehicles.Length - 1; i >= 0; --i)
    {
        if (V == Vehicles[i])
        {
            --GRI.TeamVehicleCounts[Vehicles[i].VehicleTeam];

            Vehicles.Remove(i, 1);

            break;
        }
    }

    // Updates the destroyed vehicle in the VehiclePools array
    for (i = 0; i < VehiclePools.Length; ++i)
    {
        // Find the matching VehicleClass but also check the bIsSpawnVehicle setting also matches
        // Vital as same VehicleClass may well be in the vehicles list twice, with one being a spawn vehicle & the other the ordinary version, e.g. a half-track & a spawn vehicle HT
        if (V.class == VehiclePools[i].VehicleClass && !(DHVehicle(V) != none && DHVehicle(V).IsSpawnVehicle() != VehiclePools[i].bIsSpawnVehicle))
        {
            // Updates due to vehicle being destroyed
            GRI.VehiclePoolActiveCounts[i] -= 1;

            if (bWasSpawnKilled)
            {
                --GRI.VehiclePoolSpawnCounts[i];
            }

            if (!VehiclePools[i].bIgnoreMaxTeamVehicles)
            {
                ++GRI.MaxTeamVehicles[VehiclePools[i].VehicleClass.default.VehicleTeam];
            }

            if (VehiclePools[i].OnVehicleDestroyedEvent != '')
            {
                TriggerEvent(VehiclePools[i].OnVehicleDestroyedEvent, self, none);
            }

            // If we've used up all of these vehicles
            if (GRI.GetVehiclePoolSpawnsRemaining(i) <= 0)
            {
                if (VehiclePools[i].OnDepletedEvent != '')
                {
                    TriggerEvent(VehiclePools[i].OnDepletedEvent, self, none);
                }

                if (VehiclePools[i].OnDepleteActivatePool != '')
                {
                    SetVehiclePoolIsActiveByTag(VehiclePools[i].OnDepleteActivatePool, true);
                }

                BroadcastTeamLocalizedMessage(VehiclePools[i].VehicleClass.default.VehicleTeam, Level.Game.default.GameMessageClass, 200 + i,,, self); // vehicle reinforcements have been depleted
            }

            // Find this vehicle's slot & set its re-spawn time
            for (j = 0; j < VehiclePools[i].Slots.Length; ++j)
            {
                if (VehiclePools[i].Slots[j].Vehicle == V)
                {
                    VehiclePools[i].Slots[j].Vehicle = none;

                    ROV = ROVehicle(V);

                    // If empty, abandoned vehicle has just been destroyed by CheckReset() event, make it available immediately (same as a factory would be made to respawn immediately)
                    // If vehicle's ResetTime was in last 0.5 secs it must have just been been destroyed by CheckReset()
                    if (ROV != none && ROV.ResetTime <= Level.TimeSeconds && (Level.TimeSeconds - ROV.ResetTime) < 0.5)
                    {
                        VehiclePools[i].Slots[j].RespawnTime = GRI.ElapsedTime;
                    }
                    else if (bWasSpawnKilled)
                    {
                        VehiclePools[i].Slots[j].RespawnTime = GRI.ElapsedTime + SPAWN_KILL_RESPAWN_TIME;
                    }
                    else
                    {
                        VehiclePools[i].Slots[j].RespawnTime = GRI.ElapsedTime + VehiclePools[i].RespawnTime;
                    }

                    break;
                }
            }

            // Set the next available time to the lowest re-spawn time value in the vehicle pool slots
            if (VehiclePools[i].Slots.Length > 0)
            {
                NextAvailableTime = 2147483647;

                for (j = 0; j < VehiclePools[i].Slots.Length; ++j)
                {
                    if (VehiclePools[i].Slots[j].Vehicle == none)
                    {
                        NextAvailableTime = Min(NextAvailableTime, VehiclePools[i].Slots[j].RespawnTime);
                    }
                }

                GRI.VehiclePoolNextAvailableTimes[i] = NextAvailableTime;
            }

            break;
        }
    }
}

//==============================================================================
// Spawn Point Functions
//==============================================================================

private function GetSpawnPointIndicesByTag(name SpawnPointTag, out array<byte> SpawnPointIndices)
{
    local int i;

    for (i = 0; i < SpawnPoints.Length; ++i)
    {
        if (SpawnPoints[i] != none && SpawnPoints[i].Tag == SpawnPointTag)
        {
            SpawnPointIndices[SpawnPointIndices.Length] = i;
        }
    }
}

private function SetSpawnPointIsActive(int SpawnPointIndex, bool bIsActive)
{
    local DHSpawnPoint SP;

    SP = DHSpawnPoint(GRI.GetSpawnPoint(SpawnPointIndex));

    if (SP == none || SP.bIsLocked)
    {
        return;
    }

    SP.SetIsActive(bIsActive);
}

function SetSpawnPointIsActiveByTag(name SpawnPointTag, bool bIsActive)
{
    local array<byte> SpawnPointIndices;
    local int         i;

    GetSpawnPointIndicesByTag(SpawnPointTag, SpawnPointIndices);

    for (i = 0; i < SpawnPointIndices.Length; ++i)
    {
        SetSpawnPointIsActive(SpawnPointIndices[i], bIsActive);
    }
}

function SetSpawnPointIsLockedByTag(name SpawnPointTag, bool bIsLocked)
{
    local array<byte> SpawnPointIndices;
    local int         i;

    GetSpawnPointIndicesByTag(SpawnPointTag, SpawnPointIndices);

    for (i = 0; i < SpawnPointIndices.Length; ++i)
    {
        SpawnPoints[SpawnPointIndices[i]].bIsLocked = bIsLocked;
    }
}

function ToggleSpawnPointIsActiveByTag(name SpawnPointTag)
{
    local array<byte> SpawnPointIndices;
    local int         i;
    local DHSpawnPoint SP;

    if (GRI == none)
    {
        return;
    }

    GetSpawnPointIndicesByTag(SpawnPointTag, SpawnPointIndices);

    for (i = 0; i < SpawnPointIndices.Length; ++i)
    {
        SP = DHSpawnPoint(GRI.GetSpawnPoint(i));

        if (SP != none)
        {
            SetSpawnPointIsActive(SpawnPointIndices[i], !SP.IsActive());
        }
    }
}

//==============================================================================
// Pool Functions
//==============================================================================
private function GetVehiclePoolIndicesByTag(name PoolTag, out array<byte> VehiclePoolIndices)
{
    local int i;

    for (i = 0; i < VehiclePools.Length; ++i)
    {
        if (VehiclePools[i].Tag == PoolTag)
        {
            VehiclePoolIndices[VehiclePoolIndices.Length] = i;
        }
    }
}

private function AddVehiclePoolMaxSpawns(byte VehiclePoolIndex, int Value)
{
    if (GRI != none && !GRI.IsVehiclePoolInfinite(VehiclePoolIndex))
    {
        if (Value > 0)
        {
            // Send "vehicle reinforcements have arrived" message
            BroadcastTeamLocalizedMessage(VehiclePools[VehiclePoolIndex].VehicleClass.default.VehicleTeam, Level.Game.default.GameMessageClass, 300 + VehiclePoolIndex,,, self);
        }

        GRI.VehiclePoolMaxSpawns[VehiclePoolIndex] = Clamp(int(GRI.VehiclePoolMaxSpawns[VehiclePoolIndex]) + Value, 0, 254);

        if (Value < 0 && GRI.VehiclePoolMaxSpawns[VehiclePoolIndex] == 0)
        {
            // Send "vehicle reinforcements have been cut off" message
            BroadcastTeamLocalizedMessage(VehiclePools[VehiclePoolIndex].VehicleClass.default.VehicleTeam, Level.Game.default.GameMessageClass, 400 + VehiclePoolIndex,,, self);
        }
    }
}

private function SetVehiclePoolIsActive(int VehiclePoolIndex, bool bIsActive)
{
    if (GRI == none ||GRI.IsVehiclePoolActive(VehiclePoolIndex) == bIsActive)
    {
        return; // no change
    }

    GRI.SetVehiclePoolIsActive(VehiclePoolIndex, bIsActive);

    // Trigger any activated/deactivated events
    if (bIsActive)
    {
        if (VehiclePools[VehiclePoolIndex].OnActivatedEvent != '')
        {
            TriggerEvent(VehiclePools[VehiclePoolIndex].OnActivatedEvent, self, none);
        }
    }
    else
    {
        if (VehiclePools[VehiclePoolIndex].OnDeactivatedEvent != '')
        {
            TriggerEvent(VehiclePools[VehiclePoolIndex].OnDeactivatedEvent, self, none);
        }
    }
}

function AddVehiclePoolMaxSpawnsByTag(name VehiclePoolTag, int Value)
{
    local array<byte> VehiclePoolIndices;
    local int         i;

    GetVehiclePoolIndicesByTag(VehiclePoolTag, VehiclePoolIndices);

    for (i = 0; i < VehiclePoolIndices.Length; ++i)
    {
        AddVehiclePoolMaxSpawns(VehiclePoolIndices[i], Value);
    }
}

function SetVehiclePoolMaxSpawnsByTag(name VehiclePoolTag, byte MaxSpawns)
{
    local array<byte> VehiclePoolIndices;
    local int         i;

    if (GRI != none)
    {
        GetVehiclePoolIndicesByTag(VehiclePoolTag, VehiclePoolIndices);

        for (i = 0; i < VehiclePoolIndices.Length; ++i)
        {
            GRI.VehiclePoolMaxSpawns[VehiclePoolIndices[i]] = MaxSpawns;
        }
    }
}

function AddVehiclePoolMaxActiveByTag(name VehiclePoolTag, int Value)
{
    local array<byte> VehiclePoolIndices;
    local int         i;

    if (GRI != none)
    {
        GetVehiclePoolIndicesByTag(VehiclePoolTag, VehiclePoolIndices);

        for (i = 0; i < VehiclePoolIndices.Length; ++i)
        {
            if (Value > 0)
            {
                BroadcastTeamLocalizedMessage(VehiclePools[VehiclePoolIndices[i]].VehicleClass.default.VehicleTeam, Level.Game.default.GameMessageClass, 300 + VehiclePoolIndices[i],,, self);
            }

            GRI.VehiclePoolMaxActives[VehiclePoolIndices[i]] = Clamp(int(GRI.VehiclePoolMaxActives[VehiclePoolIndices[i]]) + Value, 0, 254);

            if (Value < 0 && GRI.VehiclePoolMaxActives[VehiclePoolIndices[i]] == 0)
            {
                BroadcastTeamLocalizedMessage(VehiclePools[VehiclePoolIndices[i]].VehicleClass.default.VehicleTeam, Level.Game.default.GameMessageClass, 400 + VehiclePoolIndices[i],,, self);
            }
        }
    }
}

function SetVehiclePoolMaxActiveByTag(name VehiclePoolTag, byte Value)
{
    local array<byte> VehiclePoolIndices;
    local int        i;

    if (GRI != none)
    {
        GetVehiclePoolIndicesByTag(VehiclePoolTag, VehiclePoolIndices);

        for (i = 0; i < VehiclePoolIndices.Length; ++i)
        {
            GRI.VehiclePoolMaxActives[VehiclePoolIndices[i]] = Value;
        }
    }
}

function SetVehiclePoolIsActiveByTag(name VehiclePoolTag, bool bIsActive)
{
    local array<byte> VehiclePoolIndices;
    local int         i;

    GetVehiclePoolIndicesByTag(VehiclePoolTag, VehiclePoolIndices);

    for (i = 0; i < VehiclePoolIndices.Length; ++i)
    {
        SetVehiclePoolIsActive(VehiclePoolIndices[i], bIsActive);
    }
}

function ToggleVehiclePoolIsActiveByTag(name VehiclePoolTag)
{
    local array<byte> VehiclePoolIndices;
    local int         i;

    GetVehiclePoolIndicesByTag(VehiclePoolTag, VehiclePoolIndices);

    for (i = 0; i < VehiclePoolIndices.Length; ++i)
    {
        SetVehiclePoolIsActive(VehiclePoolIndices[i], !GRI.IsVehiclePoolActive(VehiclePoolIndices[i]));
    }
}

function BroadcastTeamLocalizedMessage(byte Team, class<LocalMessage> MessageClass, int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    local PlayerController PC;
    local Controller       C;

    for (C = Level.ControllerList; C != none; C = C.NextController)
    {
        if (C.GetTeamNum() == Team)
        {
            PC = PlayerController(C);

            if (PC != none)
            {
                PC.ReceiveLocalizedMessage(MessageClass, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
            }
        }
    }
}

defaultproperties
{
    MaxTeamVehicles(0)=32
    MaxTeamVehicles(1)=32
    bDirectional=false
    DrawScale=3.0
}


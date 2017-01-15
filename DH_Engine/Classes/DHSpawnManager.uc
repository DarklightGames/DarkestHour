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

var     private     byte                    TeamVehicleCounts[2];
var     private     array<ROVehicle>        Vehicles;
var     private     array<DHSpawnPoint>     SpawnPoints;
var     private     DHGameReplicationInfo   GRI;

var     const byte  SVT_None;
var     const byte  SVT_EngineOff;
var     const byte  SVT_Always;

var     const byte  SpawnPointType_Infantry;
var     const byte  SpawnPointType_Vehicles;

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

    // Set repeating 1 second timer that checks whether spawn vehicles are blocked from players deploying to them
    SetTimer(1.0, true);
}

function Reset()
{
    local int i, j;

    for (i = 0; i < SpawnPoints.Length; ++i)
    {
        SetSpawnPointIsActive(i, SpawnPoints[i].bIsInitiallyActive);
        SpawnPoints[i].bIsLocked = SpawnPoints[i].bIsInitiallyLocked;
    }

    for (i = 0; i < arraycount(GRI.SpawnVehicles); ++i)
    {
        GRI.SpawnVehicles[i].VehiclePoolIndex = -1;
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

function bool DrySpawnVehicle(DHPlayer PC, out vector SpawnLocation, out rotator SpawnRotation)
{
    local DHSpawnPointComponent SP;
    local int RoleIndex;
    local DHPlayerReplicationInfo PRI;
    local byte Team;

    if (PC == none || GRI == none || PC.bSpawnPointInvalidated)
    {
        return false;
    }

    RoleIndex = GRI.GetRoleIndexAndTeam(PC.GetRoleInfo(), Team);

    PRI = DHPlayerReplicationInfo(PC.PlayerReplicationInfo);

    if (PRI == none)
    {
        return false;
    }

    // Check spawn settings
    if (!GRI.AreSpawnSettingsValid(PC.SpawnPointIndex, PC.GetTeamNum(), RoleIndex, PRI.SquadIndex, PC.VehiclePoolIndex))
    {
        return false;
    }

    if (!CanSpawnVehicle(PC.SpawnPointIndex, PC.VehiclePoolIndex))
    {
        return false;
    }

    SP.GetSpawnPosition(SpawnLocation, SpawnRotation, PC.VehiclePoolIndex, VehiclePools[PC.VehiclePoolIndex].VehicleClass.default.CollisionRadius);

    return true;
}

function bool SpawnPlayer(DHPlayer PC)
{
    local DHSpawnPointComponent SP;

    if (PC != none)
    {
        SP = GRI.GetSpawnPoint(PC.SpawnPointIndex);

        if (SP != none)
        {
            // TODO: figure out where to put this madness
            return SP.PerformSpawn(PC);
        }
    }

    return false;
}

function bool SpawnVehicle(DHPlayer C)
{
    local ROVehicle V;
    local vector    SpawnLocation;
    local rotator   SpawnRotation;
    local int       i;
    local DHPlayerReplicationInfo PRI;

    if (C == none || C.Pawn != none)
    {
        return false;
    }

    PRI = ROPlayerReplicationInfo(C.PlayerReplicationInfo);

    // Make sure player isn't excluded from a tank crew role
    if (VehiclePools[C.VehiclePoolIndex].VehicleClass.default.bMustBeTankCommander &&
        (PRI == none || PRI.RoleInfo == none || !PRI.RoleInfo.bCanBeTankCrew))
    {
        return false;
    }

    // Some checks that we have valid settings to spawn a vehicle
    if (!DrySpawnVehicle(C, SpawnLocation, SpawnRotation))
    {
        return false;
    }

    // This calls old RestartPlayer (spawns player in black room) & avoids reinforcement subtraction (because we will subtract later)
    if (DarkestHourGame(Level.Game) != none)
    {
        DarkestHourGame(Level.Game).DeployRestartPlayer(C, false, true);
    }

    if (C.Pawn == none)
    {
        return false;
    }

    // Now spawn the vehicle (& make sure it was successful)
    V = Spawn(VehiclePools[C.VehiclePoolIndex].VehicleClass, self,, SpawnLocation, SpawnRotation);

    if (V == none)
    {
        return false;
    }

    // If we successfully enter the vehicle
    if (V.TryToDrive(C.Pawn))
    {
        // Set vehicle properties & add to our Vehicles array
        V.SetTeamNum(V.default.VehicleTeam);
        V.ParentFactory = self;
        Vehicles[Vehicles.Length] = V;

        // Start engine
        if (V.IsA('DHVehicle') && DHVehicle(V).bEngineOff)
        {
            DHVehicle(V).bIsSpawnVehicle = VehiclePools[C.VehiclePoolIndex].bIsSpawnVehicle;
            DHVehicle(V).ServerStartEngine();
        }

        // If it's a spawn vehicle that doesn't require the engine to be off, add to GRI's SpawnVehicles array
        if (VehiclePools[C.VehiclePoolIndex].bIsSpawnVehicle)
        {
            GRI.AddSpawnVehicle(C.VehiclePoolIndex, V);
        }

        // Increment vehicle counts
        ++TeamVehicleCounts[V.default.VehicleTeam];

        if (!VehiclePools[C.VehiclePoolIndex].bIgnoreMaxTeamVehicles)
        {
            --GRI.MaxTeamVehicles[V.default.VehicleTeam];
        }

        ++GRI.VehiclePoolActiveCounts[C.VehiclePoolIndex];
        ++GRI.VehiclePoolSpawnCounts[C.VehiclePoolIndex];

        // Assign newly spawned vehicle to a VehiclePools slot so we can track its respawn time, & set controller's NextVehicleSpawnTime
        for (i = 0; i < VehiclePools[C.VehiclePoolIndex].Slots.Length; ++i)
        {
            if (VehiclePools[C.VehiclePoolIndex].Slots[i].Vehicle == none)
            {
                VehiclePools[C.VehiclePoolIndex].Slots[i].Vehicle = V;
                break;
            }
        }

        C.NextVehicleSpawnTime = GRI.ElapsedTime + 60;

        // Trigger any OnVehicleSpawnedEvent
        if (VehiclePools[C.VehiclePoolIndex].OnVehicleSpawnedEvent != '')
        {
            TriggerEvent(VehiclePools[C.VehiclePoolIndex].OnVehicleSpawnedEvent, self, none);
        }

        // Set spawn protection variables for the vehicle
        if (DHVehicle(V) != none)
        {
            DHVehicle(V).SpawnProtEnds = Level.TimeSeconds + Min(SPAWN_PROTECTION_TIME, GRI.SpawnPoints[C.SpawnPointIndex].SpawnProtectionTime);
            DHVehicle(V).SpawnKillTimeEnds = Level.TimeSeconds + GRI.SpawnPoints[C.SpawnPointIndex].SpawnProtectionTime;
        }

        // Set spawn protection variables for the player that spawned the vehicle
        if (DHPawn(V.Driver) != none)
        {
            DHPawn(V.Driver).SpawnProtEnds = Level.TimeSeconds + Min(SPAWN_PROTECTION_TIME, GRI.SpawnPoints[C.SpawnPointIndex].SpawnProtectionTime);
            DHPawn(V.Driver).SpawnKillTimeEnds = Level.TimeSeconds + GRI.SpawnPoints[C.SpawnPointIndex].SpawnProtectionTime;
        }

        // Decrement reservation count
        GRI.UnreserveVehicle(C);

        C.bSpawnPointInvalidated = true;
    }
    // We were unable to enter the vehicle, so destroy it & kill the player, so they aren't stuck in the black room
    else
    {
        V.Destroy();
        C.Pawn.Suicide();

        return false;
    }

    return true;
}

function Pawn SpawnPawn(Controller C, vector SpawnLocation, rotator SpawnRotation)
{
    local DarkestHourGame G;

    G = DarkestHourGame(Level.Game);

    if (G == none || C == none)
    {
        return none;
    }

    if (C.PreviousPawnClass != none && C.PawnClass != C.PreviousPawnClass)
    {
        G.BaseMutator.PlayerChangedClass(C);
    }

    // Spawn player pawn
    if (C.PawnClass != none)
    {
        C.Pawn = Spawn(C.PawnClass,,, SpawnLocation, SpawnRotation);
    }

    // If spawn failed, try again using default player class
    if (C.Pawn == none)
    {
        C.Pawn = Spawn(G.GetDefaultPlayerClass(C),,, SpawnLocation, SpawnRotation);
    }

    // Hard spawning the player at the spawn location failed, most likely because spawn function was blocked
    // Try again with black room spawn & teleport them to spawn location
    if (C.Pawn == none)
    {
        G.DeployRestartPlayer(C, false, true);

        if (C.Pawn != none)
        {
            if (TeleportPlayer(C, SpawnLocation, SpawnRotation))
            {
                return C.Pawn; // exit as we used old spawn system & don't need to do anything else in this function
            }
            else
            {
                C.Pawn.Suicide(); // teleport failed & pawn is still in the black room, so kill it
            }
        }
    }

    // Still haven't managed to spawn a player pawn, so go to state 'Dead' & exit
    if (C.Pawn == none)
    {
        C.GotoState('Dead');

        if (PlayerController(C) != none)
        {
            PlayerController(C).ClientGotoState('Dead', 'Begin');
        }

        return none;
    }

    // We have a new player pawn, so handle the necessary set up & possession
    if (PlayerController(C) != none)
    {
        PlayerController(C).TimeMargin = -0.1;
    }

    C.Pawn.LastStartTime = Level.TimeSeconds;
    C.PreviousPawnClass = C.Pawn.Class;
    C.Possess(C.Pawn);
    C.PawnClass = C.Pawn.Class;
    C.Pawn.PlayTeleportEffect(true, true);
    C.ClientSetRotation(C.Pawn.Rotation);

    G.AddDefaultInventory(C.Pawn);

    return C.Pawn;
}

static function bool TeleportPlayer(Controller C, vector SpawnLocation, rotator SpawnRotation)
{
    if (C != none && C.Pawn != none && C.Pawn.SetLocation(SpawnLocation))
    {
        C.Pawn.SetRotation(SpawnRotation);
        C.Pawn.SetViewRotation(SpawnRotation);
        C.Pawn.ClientSetRotation(SpawnRotation);

        return true;
    }

    return false;
}

function bool CanSpawnVehicle(int SpawnPointIndex, int VehiclePoolIndex)
{
    local class<ROVehicle> VC;
    local DHSpawnPointComponent SP;

    if (GRI == none)
    {
        return false;
    }

    if (VehiclePoolIndex < 0 || VehiclePoolIndex >= VEHICLE_POOLS_MAX)
    {
        return false;
    }

    VC = VehiclePools[VehiclePoolIndex].VehicleClass;

    if (VC == none)
    {
        return false;
    }

    SP = GRI.GetSpawnPoint(SpawnPointIndex);

    if (SP == none || !SP.CanSpawnVehicle(VC))
    {
        return false;
    }

    if (!GRI.IgnoresMaxTeamVehiclesFlags(VehiclePoolIndex) &&
        TeamVehicleCounts[VC.default.VehicleTeam] >= MaxTeamVehicles[VC.default.VehicleTeam])
    {
        return false;
    }

    if (!GRI.IsVehiclePoolActive(VehiclePoolIndex))
    {
        return false;
    }

    if (Level.TimeSeconds < GRI.VehiclePoolNextAvailableTimes[VehiclePoolIndex])
    {
        return false;
    }

    if (GRI.VehiclePoolSpawnCounts[VehiclePoolIndex] >= GRI.VehiclePoolMaxSpawns[VehiclePoolIndex])
    {
        return false;
    }

    if (GRI.VehiclePoolActiveCounts[VehiclePoolIndex] >= GRI.VehiclePoolMaxActives[VehiclePoolIndex])
    {
        return false;
    }

    return true;
}

function bool DrySpawnInfantry(DHPlayer PC, out vector SpawnLocation, out rotator SpawnRotation)
{
    local DHSpawnPointComponent SP;
    local int RoleIndex;
    local DHPlayerReplicationInfo PRI;
    local byte Team;

    if (PC == none || GRI == none || PC.bSpawnPointInvalidated)
    {
        return false;
    }

    RoleIndex = GRI.GetRoleIndexAndTeam(PC.GetRoleInfo(), Team);

    PRI = DHPlayerReplicationInfo(PC.PlayerReplicationInfo);

    if (PRI == none)
    {
        return false;
    }

    // Check spawn settings
    if (!GRI.AreSpawnSettingsValid(PC.GetTeamNum(), RoleIndex, PC.SpawnPointIndex, PRI.SquadIndex, -1))
    {
        return false;
    }

    // Check spawn point
    SP = GRI.SpawnPoints[PC.SpawnPointIndex];

    if (SP == none)
    {
        return false;
    }

    SP.GetSpawnPosition(SpawnLocation, SpawnRotation, -1, class'DHPawn'.default.CollisionRadius);

    return true;
}

function bool SpawnInfantry(DHPlayer C)
{
    local DHPawn  P;
    local vector  SpawnLocation;
    local rotator SpawnRotation;

    if (C == none || C.Pawn != none)
    {
        return false;
    }

    if (!DrySpawnInfantry(C, SpawnLocation, SpawnRotation))
    {
        return false;
    }

    P = DHPawn(SpawnPawn(C, SpawnLocation, SpawnRotation));

    if (P == none)
    {
        return false;
    }

    P.SpawnProtEnds = Level.TimeSeconds + Min(SPAWN_PROTECTION_TIME, GRI.SpawnPoints[C.SpawnPointIndex].SpawnProtectionTime);
    P.SpawnKillTimeEnds = Level.TimeSeconds + GRI.SpawnPoints[C.SpawnPointIndex].SpawnProtectionTime;

    return true;
}

event VehicleDestroyed(Vehicle V)
{
    local ROVehicle ROV;
    local int       NextAvailableTime, i, j;
    local bool      bWasSpawnKilled;
    const SPAWN_KILL_RESPAWN_TIME = 2;

    super.VehicleDestroyed(V);

    // Find out if the vehicle was spawned killed
    if (V.IsA('DHVehicle') && DHVehicle(V).IsSpawnKillProtected())
    {
        bWasSpawnKilled = true;
    }

    // Removes the destroyed vehicle from the managed Vehicles array
    for (i = Vehicles.Length - 1; i >= 0; --i)
    {
        if (V == Vehicles[i])
        {
            --TeamVehicleCounts[Vehicles[i].VehicleTeam];

            Vehicles.Remove(i, 1);

            break;
        }
    }

    // Updates the destroyed vehicle in the VehiclePools array
    for (i = 0; i < VehiclePools.Length; ++i)
    {
        // Find the matching VehicleClass but also check the bIsSpawnVehicle setting also matches
        // Vital as same VehicleClass may well be in the vehicles list twice, with one being a spawn vehicle & the other the ordinary version, e.g. a half-track & a spawn vehicle HT
        if (V.class == VehiclePools[i].VehicleClass && !(DHVehicle(V) != none && DHVehicle(V).bIsSpawnVehicle != VehiclePools[i].bIsSpawnVehicle))
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

    // Check whether we need to remove a spawn vehicle from the spawn vehicles array
    GRI.RemoveSpawnVehicle(V);
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
    local DHSpawnPoint     SP;
    local DHVehicleFactory Factory;
    local int              i;

    SP = DHSpawnPoint(GRI.GetSpawnPoint(SpawnPointIndex));

    if (SP == none || SP.bIsLocked)
    {
        return;
    }

    SP.SetIsActive(bIsActive);

    // Activate/deactivate any linked mine volume protecting the spawn point
    if (SP.MineVolumeProtectionRef != none)
    {
        if (bIsActive)
        {
            SP.MineVolumeProtectionRef.Activate();
        }
        else
        {
            SP.MineVolumeProtectionRef.Deactivate();
        }
    }

    // Activate/deactivate any linked vehicle factories
    for (i = 0; i < SP.LinkedVehicleFactories.Length; ++i)
    {
        Factory = SP.LinkedVehicleFactories[i];

        if (Factory != none)
        {
            if (bIsActive)
            {
                Factory.ActivatedBySpawn(Factory.TeamNum);
            }
            else
            {
                Factory.Deactivate();
            }
        }
    }
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
            SP.SetIsActive(SP.IsActive());
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
    if (!GRI.IsVehiclePoolInfinite(VehiclePoolIndex))
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

    GetVehiclePoolIndicesByTag(VehiclePoolTag, VehiclePoolIndices);

    for (i = 0; i < VehiclePoolIndices.Length; ++i)
    {
        GRI.VehiclePoolMaxSpawns[VehiclePoolIndices[i]] = MaxSpawns;
    }
}

function AddVehiclePoolMaxActiveByTag(name VehiclePoolTag, int Value)
{
    local array<byte> VehiclePoolIndices;
    local int         i;

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

function SetVehiclePoolMaxActiveByTag(name VehiclePoolTag, byte Value)
{
    local array<byte> VehiclePoolIndices;
    local int        i;

    GetVehiclePoolIndicesByTag(VehiclePoolTag, VehiclePoolIndices);

    for (i = 0; i < VehiclePoolIndices.Length; ++i)
    {
        GRI.VehiclePoolMaxActives[VehiclePoolIndices[i]] = Value;
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

//==============================================================================
// Spawn Vehicle Functions
//==============================================================================

function int GetSpawnVehicleCount()
{
    local int SpawnVehicleCount, i;

    for (i = 0; i < arraycount(GRI.SpawnVehicles); ++i)
    {
        if (GRI.SpawnVehicles[i].Vehicle != none)
        {
            ++SpawnVehicleCount;
        }
    }

    return SpawnVehicleCount;
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
    SpawnPointType_Infantry=0
    SpawnPointType_Vehicles=1
    SVT_None=0
    SVT_EngineOff=1
    SVT_Always=2
    bDirectional=false
    DrawScale=3.0
}


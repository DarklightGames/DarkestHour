//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHSpawnManager extends SVehicleFactory;

enum ESpawnPointType
{
    ESPT_Infantry,
    ESPT_Vehicles,
    ESPT_Mortars,
    ESPT_All
};

//Spawn Vehicle Type
var const byte SVT_None;
var const byte SVT_EngineOff;
var const byte SVT_Always;

enum ESpawnVehicleType
{
    ESVT_None,
    ESVT_EngineOff,
    ESVT_Always
};

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
    var() ESpawnVehicleType SpawnVehicleType;
    var() float             RespawnTime;                //respawn interval in seconds
    var() byte              MaxSpawns;                  //how many vehicles can be spawned from this pool
    var() byte              MaxActive;                  //how many vehicles from this pool can be active at once

    var() name              OnActivatedEvent;           //event to trigger when pool is activated (also gets triggered when initially activated)
    var() name              OnDeactivatedEvent;         //event to trigger when pool is deactivated (does NOT get triggered when initially deactivated)
    var() name              OnDepletedEvent;            //event to trigger when pool has been depleted (SpawnCount meets or exceeds MaxSpawns)
    var() name              OnDepleteActivatePool;      //vehicle pool to activate when this pool has been depleted (uses pool tag)
    var() name              OnVehicleDestroyedEvent;    //event to trigger when vehicle from this pool is destroyed
    var() name              OnVehicleSpawnedEvent;      //event to trigger when vehicle from this pool is spawned

    var array<VehiclePoolSlot> Slots;
};

//TODO: these were basically used for debug, reduce this down to a simple binary
//for whether a fatal error occurred or not (the user never needs to know the
//specifics)
var const byte SpawnError_None;
var const byte SpawnError_Fatal;
var const byte SpawnError_MaxVehicles;
var const byte SpawnError_Cooldown;
var const byte SpawnError_SpawnLimit;
var const byte SpawnError_ActiveLimit;
var const byte SpawnError_PoolInactive;
var const byte SpawnError_SpawnInactive;
var const byte SpawnError_Blocked;
var const byte SpawnError_Failed;
var const byte SpawnError_BadTeamPool;
var const byte SpawnError_BadTeamSpawnPoint;
var const byte SpawnError_TryToDriveFailed;
var const byte SpawnError_BadSpawnType;
var const byte SpawnError_PawnSpawnFailed;
var const byte SpawnError_IncorrectRole;
var const byte SpawnError_SpawnPointsDontMatch;

var const byte SpawnPointType_Infantry;
var const byte SpawnPointType_Vehicles;

const SPAWN_POINTS_MAX = 48;
const VEHICLE_POOLS_MAX = 32;
const SPAWN_VEHICLES_MAX = 8;

var() array<VehiclePool>                VehiclePools;
var() byte                              MaxTeamVehicles[2];

var private byte                        TeamVehicleCounts[2];
var private array<ROVehicle>            Vehicles;
var private array<DHSpawnPoint>         SpawnPoints;
var private DHGameReplicationInfo       GRI;

function PostBeginPlay()
{
    local int i, j;
    local DHSpawnPoint SP;
    local bool bIsVehiclePoolValid;

    super.PostBeginPlay();

    GRI = DHGameReplicationInfo(Level.Game.GameReplicationInfo);

    if (GRI == none)
    {
        Warn("DHGameReplicationInfo is none");

        return;
    }

    foreach AllActors(class'DHSpawnPoint', SP)
    {
        if (SpawnPoints.Length >= SPAWN_POINTS_MAX)
        {
            Warn("DHSpawnPoint count exceeds" @ SPAWN_POINTS_MAX);

            break;
        }

        SpawnPoints[SpawnPoints.Length] = SP;
    }

    for (i = 0; i < VehiclePools.Length; ++i)
    {
        if (VehiclePools[i].VehicleClass == none)
        {
            VehiclePools.Remove(i--, 1);

            continue;
        }

        bIsVehiclePoolValid = true;

        // Vehicle pools must have a unique VehicleClass
        for (j = i - 1; j >= 0; --j)
        {
            if (VehiclePools[i].VehicleClass == VehiclePools[j].VehicleClass)
            {
                // Vehicle class already exists, mark as non-unique
                bIsVehiclePoolValid = false;
            }
        }

        if (!bIsVehiclePoolValid)
        {
            Warn("VehiclePools[" $ i $ "].VehicleClass (" $ VehiclePools[i].VehicleClass $ ") is not unique and will be removed!");

            // Remove VehiclePool from the list
            VehiclePools.Remove(i--, 1);

            continue;
        }

        GRI.VehiclePoolVehicleClasses[i] = VehiclePools[i].VehicleClass;

        if (VehiclePools[i].MaxActive != 255)
        {
            VehiclePools[i].Slots.Length = VehiclePools[i].MaxActive;
        }
    }

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
    }

    for (i = 0; i < VehiclePools.Length; ++i)
    {
        SetVehiclePoolIsActive(i, VehiclePools[i].bIsInitiallyActive);

        GRI.VehiclePoolMaxActives[i] = VehiclePools[i].MaxActive;
        GRI.VehiclePoolMaxSpawns[i] = VehiclePools[i].MaxSpawns;
        GRI.VehiclePoolNextAvailableTimes[i] = 0.0;
        GRI.VehiclePoolSpawnCounts[i] = 0;

        for (j = 0; j < VehiclePools[i].Slots.Length; ++j)
        {
            VehiclePools[i].Slots[j].Vehicle = none;
            VehiclePools[i].Slots[j].RespawnTime = 0;
        }
    }

    super.Reset();
}

function DrySpawnVehicle(DHPlayer C, out vector SpawnLocation, out rotator SpawnRotation, out byte SpawnError)
{
    local DHSpawnPoint SP;

    SpawnError = SpawnError_Fatal;

    if (C == none)
    {
        return;
    }

    //Check spawn settings
    if (!GRI.AreSpawnSettingsValid(C.GetTeamNum(), DHRoleInfo(C.GetRoleInfo()), C.SpawnPointIndex, C.VehiclePoolIndex, C.SpawnVehicleIndex))
    {
        SpawnError = SpawnError_Fatal;

        return;
    }

    SP = SpawnPoints[C.SpawnPointIndex];

    if (SP == none)
    {
        SpawnError = SpawnError_Fatal;

        return;
    }

    //Check vehicle pool
    SpawnError = GetVehiclePoolError(C, SP);

    if (SpawnError != SpawnError_None)
    {
        return;
    }

    GetSpawnLocation(SP, SP.VehicleLocationHints, VehiclePools[C.VehiclePoolIndex].VehicleClass.default.CollisionRadius, SpawnLocation, SpawnRotation);
}

function GetSpawnLocation(DHSpawnPoint SP, array<DHLocationHint> LocationHints, float CollisionRadius, out vector SpawnLocation, out rotator SpawnRotation)
{
    local Pawn P;
    local Controller C;
    local array<int> LocationHintIndices;
    local int LocationHintIndex;
    local int i, j, k;
    local bool bIsBlocked;
    local array<vector> EnemyLocations;

    //Fetch all enemy locations
    for (C = Level.ControllerList; C != none; C = C.NextController)
    {
        if (C.Pawn != none && C.GetTeamNum() != SP.TeamIndex)
        {
             EnemyLocations[EnemyLocations.Length] = C.Pawn.Location;
        }
    }

    //Scramble location hint indices so we don't use the same ones repeatedly
    LocationHintIndices = class'DHLib'.static.CreateIndicesArray(LocationHints.Length);
    class'DHLib'.static.FisherYatesShuffle(LocationHintIndices);

    //Put location hints with enemies nearby at the end of the array to be
    //evaluated last
    if (LocationHintIndices.Length > 1)
    {
        for (i = LocationHintIndices.Length - 1; i >= 0; --i)
        {
            for (j = 0; j < EnemyLocations.Length; ++j)
            {
                if (VSize(EnemyLocations[j] - LocationHints[LocationHintIndices[i]].Location) <= SP.LocationHintDeferDistance)
                {
                    k = LocationHintIndices[i];
                    LocationHintIndices.Remove(i, 1);
                    LocationHintIndices[LocationHintIndices.Length] = k;
                }
            }
        }
    }

    //Initialize with invalid index
    LocationHintIndex = -1;

    for (i = 0; i < LocationHintIndices.Length; ++i)
    {
        bIsBlocked = false;

        foreach RadiusActors(class'Pawn', P, CollisionRadius, LocationHints[LocationHintIndices[i]].Location)
        {
            //Found a blocking actor
            bIsBlocked = true;

            break;
        }

        if (!bIsBlocked)
        {
            //Location hint not blocked
            LocationHintIndex = LocationHintIndices[i];

            break;
        }
    }

    if (LocationHintIndex == -1)
    {
        //No usable location hint found, so use spawn point itself
        SpawnLocation = SP.Location;
        SpawnRotation = SP.Rotation;
    }
    else
    {
        SpawnLocation = LocationHints[LocationHintIndex].Location;
        SpawnRotation = LocationHints[LocationHintIndex].Rotation;
    }
}

function SpawnPlayer(DHPlayer C, out byte SpawnError)
{
    if (C == none)
    {
        return;
    }

    if (C.VehiclePoolIndex != 255) // Vehicle Pool
    {
        SpawnVehicle(C, SpawnError);
    }
    else if (C.SpawnVehicleIndex != 255) // Spawn Vehicle
    {
        SpawnPlayerAtSpawnVehicle(C, SpawnError);
    }
    else if (SpawnPoints[C.SpawnPointIndex] != none) // Spawn point
    {
        SpawnInfantry(C, SpawnError);
    }

    // We have a pawn so let's fade from black
    if (DHPawn(C.Pawn) != none)
    {
        if (C.VehiclePoolIndex != 255) // Vehicle spawn
        {
            C.NextVehicleSpawnTime = GRI.ElapsedTime + 60;

            C.ClientFadeFromBlack(0.0, true); // Black out, the fade will start when the pawn is put back into the vehicle
            C.SetTimer(1.0, false); // Tell the player to check after 1 second to re enter the vehicle and fade from black
        }
        else
        {
            C.ClientFadeFromBlack(2.0);
        }
    }
}

function ROVehicle SpawnVehicle(DHPlayer C, out byte SpawnError)
{
    local int i;
    local ROVehicle V;
    local vector SpawnLocation;
    local rotator SpawnRotation;
    local DarkestHourGame G;

    G = DarkestHourGame(Level.Game);

    SpawnError = SpawnError_IncorrectRole;

    if (!ROPlayerReplicationInfo(C.PlayerReplicationInfo).RoleInfo.bCanBeTankCrew && VehiclePools[C.VehiclePoolIndex].VehicleClass.default.bMustBeTankCommander)
    {
        return none;
    }

    SpawnError = SpawnError_Fatal;

    if (C == none || C.Pawn != none)
    {
        return none;
    }

    DrySpawnVehicle(C, SpawnLocation, SpawnRotation, SpawnError);

    if (SpawnError != SpawnError_None)
    {
        return none;
    }

    // This calls old restartplayer (spawn in black room) and avoids reinforcment subtraction (because we will subtract later)
    G.DeployRestartPlayer(C, false, true);

    // Make sure player has a pawn
    if (C.Pawn == none)
    {
        return none;
    }

    V = Spawn(VehiclePools[C.VehiclePoolIndex].VehicleClass,,, SpawnLocation, SpawnRotation);

    if (V == none)
    {
        SpawnError = SpawnError_Failed;

        return none;
    }

    if (V.IsA('DHWheeledVehicle'))
    {
        DHWheeledVehicle(V).SpawnVehicleType = VehiclePools[C.VehiclePoolIndex].SpawnVehicleType;
        DHWheeledVehicle(V).ServerStartEngine();
    }
    else if (V.IsA('DHArmoredVehicle'))
    {
        DHArmoredVehicle(V).SpawnVehicleType = VehiclePools[C.VehiclePoolIndex].SpawnVehicleType;
        DHArmoredVehicle(V).ServerStartEngine();
    }

    if (VehiclePools[C.VehiclePoolIndex].SpawnVehicleType == ESVT_Always)
    {
        GRI.AddSpawnVehicle(V);
    }

    if(!V.TryToDrive(C.Pawn))
    {
        // Try to drive function failed, lets destroy the vehicle
        V.Destroy();

        // Lets slay the player, so they aren't stuck in the black room
        C.Pawn.Suicide();

        SpawnError = SpawnError_TryToDriveFailed;

        return none;
    }
    else
    {
        V.KDriverLeave(true); // Force leave the vehicle to update the position
        C.SpawnVehicle = V; // Set controller SpawnVehicle to be used for delayed re-entry

        //ParentFactory must be set after any calls to Destroy are made so that
        //VehicleDestroyed is not called in the event that TryToDrive fails
        V.ParentFactory = self;

        //Add vehicle to vehicles array
        Vehicles[Vehicles.Length] = V;

        //Set vehicle's team
        V.SetTeamNum(V.default.VehicleTeam);

        //Increment team vehicle count
        ++TeamVehicleCounts[V.default.VehicleTeam];

        --GRI.MaxTeamVehicles[V.default.VehicleTeam];

        //Update pool properties
        GRI.VehiclePoolActiveCounts[C.VehiclePoolIndex] += 1;
        GRI.VehiclePoolSpawnCounts[C.VehiclePoolIndex] += 1;

        //Assign this newly spawned vehicle to a slot so we can track it's
        //respawn time.
        for (i = 0; i < VehiclePools[C.VehiclePoolIndex].Slots.Length; ++i)
        {
            if (VehiclePools[C.VehiclePoolIndex].Slots[i].Vehicle == none)
            {
                VehiclePools[C.VehiclePoolIndex].Slots[i].Vehicle = V;
                break;
            }
        }

        if (VehiclePools[C.VehiclePoolIndex].OnVehicleSpawnedEvent != '')
        {
            //Trigger OnVehicleSpawned event
            TriggerEvent(VehiclePools[C.VehiclePoolIndex].OnVehicleSpawnedEvent, self, none);
        }
    }

    return V;
}

function Pawn SpawnPlayerAtSpawnVehicle(DHPlayer C, out byte SpawnError)
{
    local DarkestHourGame G;
    local Vehicle V;
    local int i;
    local array<int> ExitPositionIndices;
    local vector Offset;

    G = DarkestHourGame(Level.Game);

    if (G == none)
    {
        return none;
    }

    V = GRI.SpawnVehicles[C.SpawnVehicleIndex].Vehicle;

    if (V == none)
    {
        return none;
    }

    // Spawn pawn in black room
    if (C.Pawn == none)
    {
        G.DeployRestartPlayer(C, false, true);
    }

    if (C.Pawn == none)
    {
        return none;
    }

    Offset = C.Pawn.default.CollisionHeight * vect(0.0, 0.0, 0.5);

    // Check if we can spawn at the vehicle
    if (GRI.CanSpawnAtVehicle(C.GetTeamNum(), C.SpawnVehicleIndex))
    {
        ExitPositionIndices = class'DHLib'.static.CreateIndicesArray(V.ExitPositions.Length);
        class'DHLib'.static.FisherYatesShuffle(ExitPositionIndices);

        // Attempt to spawn at exit positions
        for (i = 0; i < ExitPositionIndices.Length; ++i)
        {
            if (TeleportPlayer(C, V.Location + (V.ExitPositions[ExitPositionIndices[i]] >> V.Rotation) + Offset, V.Rotation))
            {
                return C.Pawn;
            }
        }

        // All exit positions were blocked, attempt to just get in the vehicle
        if (!V.TryToDrive(C.Pawn))
        {
            // Attempting to get into the vehicle failed, kill the pawn we spawned earlier
            C.Pawn.Suicide();

            return none;
        }
    }
    else
    {
        // Cannot spawn at vehicle
        C.Pawn.Suicide();

        return none;
    }
}

function Pawn SpawnPawn(Controller C, vector SpawnLocation, rotator SpawnRotation)
{
    local DarkestHourGame G;
    local class<Pawn> DefaultPlayerClass;

    G = DarkestHourGame(Level.Game);

    if (G == none)
    {
        return none;
    }

    if (C.PreviousPawnClass != none && C.PawnClass != C.PreviousPawnClass)
    {
        G.BaseMutator.PlayerChangedClass(C);
    }

    if (C.PawnClass != none)
    {
        C.Pawn = Spawn(C.PawnClass,,, SpawnLocation, SpawnRotation);
    }

    if (C.Pawn == none)
    {
        DefaultPlayerClass = G.GetDefaultPlayerClass(C);

        C.Pawn = Spawn(DefaultPlayerClass,,, SpawnLocation, SpawnRotation);
    }

    if (C.Pawn == none)
    {
        // Hard spawning the player at the spawn location failed, most likely
        // because spawn function was blocked. Try again with black room spawn
        // and teleport them to spawn location
        G.DeployRestartPlayer(C, false, true);

        if (C.Pawn != none)
        {
            if (TeleportPlayer(C, SpawnLocation, SpawnRotation))
            {
                 // Return out as we used old spawn system and don't need to do
                 // anything else in this function
                return C.Pawn;
            }
            else
            {
                // Teleport failed, Pawn is still in the black room, slay it
                C.Pawn.Suicide();
            }
        }
    }

    if (C.Pawn == none)
    {
        C.GotoState('Dead');

        if (PlayerController(C) != none)
        {
            PlayerController(C).ClientGotoState('Dead', 'Begin');
        }

        return none;
    }

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

function bool TeleportPlayer(Controller C, vector SpawnLocation, rotator SpawnRotation)
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

function byte GetVehiclePoolError(DHPlayer C, DHSpawnPoint SP)
{
    if (C == none)
    {
        return SpawnError_Fatal;
    }

    if (C.VehiclePoolIndex >= VEHICLE_POOLS_MAX || VehiclePools[C.VehiclePoolIndex].VehicleClass == none)
    {
        return SpawnError_Fatal;
    }

    if (SP == none || (SP.Type != ESPT_All && SP.Type != ESPT_Vehicles))
    {
        return SpawnError_Fatal;
    }

    if (TeamVehicleCounts[VehiclePools[C.VehiclePoolIndex].VehicleClass.default.VehicleTeam] >= MaxTeamVehicles[VehiclePools[C.VehiclePoolIndex].VehicleClass.default.VehicleTeam])
    {
        return SpawnError_MaxVehicles;
    }

    if (!GRI.IsVehiclePoolActive(C.VehiclePoolIndex))
    {
        return SpawnError_PoolInactive;
    }

    if (Level.TimeSeconds < GRI.VehiclePoolNextAvailableTimes[C.VehiclePoolIndex])
    {
        return SpawnError_Cooldown;
    }

    if (GRI.VehiclePoolSpawnCounts[C.VehiclePoolIndex] >= GRI.VehiclePoolMaxSpawns[C.VehiclePoolIndex])
    {
        return SpawnError_SpawnLimit;
    }

    if (GRI.VehiclePoolActiveCounts[C.VehiclePoolIndex] >= GRI.VehiclePoolMaxActives[C.VehiclePoolIndex])
    {
        return SpawnError_ActiveLimit;
    }

    return SpawnError_None;
}

function DrySpawnInfantry(DHPlayer C, out vector SpawnLocation, out rotator SpawnRotation, out byte SpawnError)
{
    local DHSpawnPoint SP;

    SpawnError = SpawnError_Fatal;

    if (C == none)
    {
        return;
    }

    //Check spawn settings
    if (!GRI.AreSpawnSettingsValid(C.GetTeamNum(), DHRoleInfo(C.GetRoleInfo()), C.SpawnPointIndex, C.VehiclePoolIndex, C.SpawnVehicleIndex))
    {
        SpawnError = SpawnError_Fatal;

        return;
    }

    SP = SpawnPoints[C.SpawnPointIndex];

    if (SP == none)
    {
        SpawnError = SpawnError_Fatal;

        return;
    }

    GetSpawnLocation(SP, Sp.InfantryLocationHints, class'DHPawn'.default.CollisionRadius, SpawnLocation, SpawnRotation);

    SpawnError = SpawnError_None;
}

function SpawnInfantry(DHPlayer C, out byte SpawnError)
{
    local DHPawn P;
    local vector SpawnLocation;
    local rotator SpawnRotation;

    SpawnError = SpawnError_Fatal;

    if (C == none || C.Pawn != none)
    {
        return;
    }

    DrySpawnInfantry(C, SpawnLocation, SpawnRotation, SpawnError);

    if (SpawnError != SpawnError_None)
    {
        return;
    }

    P = DHPawn(SpawnPawn(C, SpawnLocation, SpawnRotation));

    if (P == none)
    {
        SpawnError = SpawnError_PawnSpawnFailed;

        return;
    }

    P.TeleSpawnProtEnds = Level.TimeSeconds + SpawnPoints[C.SpawnPointIndex].SpawnProtectionTime;

    SpawnError = SpawnError_None;
}

event VehicleDestroyed(Vehicle V)
{
    local int i, j, NextAvailableTime;

    super.VehicleDestroyed(V);

    //Removes the destroyed vehicle from the managed vehicles
    for (i = Vehicles.Length - 1; i >= 0; --i)
    {
        if (V == Vehicles[i])
        {
            //Decrement team vehicle count
            --TeamVehicleCounts[Vehicles[i].VehicleTeam];

            ++GRI.MaxTeamVehicles[Vehicles[i].VehicleTeam];

            //Remove vehicle from vehicles array
            Vehicles.Remove(i, 1);

            break;
        }
    }

    //Removes 1 from the count of vehicles in the pool
    for (i = 0; i < VehiclePools.Length; ++i)
    {
        if (V.class == VehiclePools[i].VehicleClass)
        {
            GRI.VehiclePoolActiveCounts[i] -= 1;

            if (!GRI.IsVehiclePoolInfinite(i))
            {
                //Send "Vehicle has been destroyed." message
                BroadcastTeamLocalizedMessage(VehiclePools[i].VehicleClass.default.VehicleTeam, Level.Game.default.GameMessageClass, 100 + i,,, self);
            }

            if (VehiclePools[i].OnVehicleDestroyedEvent != '')
            {
                TriggerEvent(VehiclePools[i].OnVehicleDestroyedEvent, self, none);
            }

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

                //Send "Vehicle reinforcements have been depleted." message
                BroadcastTeamLocalizedMessage(VehiclePools[i].VehicleClass.default.VehicleTeam, Level.Game.default.GameMessageClass, 200 + i,,, self);
            }

            // Find this vehicle's slot and set the slot's respawn time!
            for (j = 0; j < VehiclePools[i].Slots.Length; ++j)
            {
                if (VehiclePools[i].Slots[j].Vehicle == V)
                {
                    VehiclePools[i].Slots[j].Vehicle = none;
                    VehiclePools[i].Slots[j].RespawnTime = GRI.ElapsedTime + VehiclePools[i].RespawnTime;

                    break;
                }
            }

            if (VehiclePools[i].Slots.Length > 0)
            {
                //Set the next available time to the lowest value in the vehicle
                //pool slots' respawn times list.
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

    // Attempt to remove vehicle from spawn vehicles
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
        if (SpawnPoints[i].Tag == SpawnPointTag)
        {
            SpawnPointIndices[SpawnPointIndices.Length] = i;
        }
    }
}

private function SetSpawnPointIsActive(byte SpawnPointIndex, bool bIsActive)
{
    GRI.SetSpawnPointIsActive(SpawnPointIndex, bIsActive);
}

function SetSpawnPointIsActiveByTag(name SpawnPointTag, bool bIsActive)
{
    local int i;
    local array<byte> SpawnPointIndices;

    GetSpawnPointIndicesByTag(SpawnPointTag, SpawnPointIndices);

    for (i = 0; i < SpawnPointIndices.Length; ++i)
    {
        SetSpawnPointIsActive(SpawnPointIndices[i], bIsActive);
    }
}

function ToggleSpawnPointIsActiveByTag(name SpawnPointTag)
{
    local int i;
    local array<byte> SpawnPointIndices;

    GetSpawnPointIndicesByTag(SpawnPointTag, SpawnPointIndices);

    for (i = 0; i < SpawnPointIndices.Length; ++i)
    {
        SetSpawnPointIsActive(SpawnPointIndices[i], !GRI.IsSpawnPointIndexActive(i));
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

private function AddVehiclePoolMaxSpawns(byte VehiclePoolIndex, byte Value)
{
    if (!GRI.IsVehiclePoolInfinite(VehiclePoolIndex))
    {
        GRI.VehiclePoolMaxSpawns[VehiclePoolIndex] = Min(int(GRI.VehiclePoolMaxSpawns[VehiclePoolIndex]) + int(Value), 254);

        if (Value > 0)
        {
            //Send "Vehicle reinforcements have arrived" message
            BroadcastTeamLocalizedMessage(VehiclePools[VehiclePoolIndex].VehicleClass.default.Team, Level.Game.default.GameMessageClass, 300 + VehiclePoolIndex,,, self);
        }
    }
}

private function SetVehiclePoolIsActive(int VehiclePoolIndex, bool bIsActive)
{
    if (GRI.IsVehiclePoolActive(VehiclePoolIndex) == bIsActive)
    {
        //no change
        return;
    }

    GRI.SetVehiclePoolIsActive(VehiclePoolIndex, bIsActive);

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
    local int i;
    local array<byte> VehiclePoolIndices;

    GetVehiclePoolIndicesByTag(VehiclePoolTag, VehiclePoolIndices);

    for (i = 0; i < VehiclePoolIndices.Length; ++i)
    {
        AddVehiclePoolMaxSpawns(VehiclePoolIndices[i], Value);
    }
}

function SetVehiclePoolMaxSpawnsByTag(name VehiclePoolTag, byte MaxSpawns)
{
    local int i;
    local array<byte> VehiclePoolIndices;

    GetVehiclePoolIndicesByTag(VehiclePoolTag, VehiclePoolIndices);

    for (i = 0; i < VehiclePoolIndices.Length; ++i)
    {
        GRI.VehiclePoolMaxSpawns[VehiclePoolIndices[i]] = MaxSpawns;
    }
}

function AddVehiclePoolMaxActiveByTag(name VehiclePoolTag, byte Value)
{
    local int i;
    local array<byte> VehiclePoolIndices;

    GetVehiclePoolIndicesByTag(VehiclePoolTag, VehiclePoolIndices);

    for (i = 0; i < VehiclePoolIndices.Length; ++i)
    {
        GRI.VehiclePoolMaxActives[VehiclePoolIndices[i]] += Value;
    }
}

function SetVehiclePoolMaxActiveByTag(name VehiclePoolTag, byte Value)
{
    local int i;
    local array<byte> VehiclePoolIndices;

    GetVehiclePoolIndicesByTag(VehiclePoolTag, VehiclePoolIndices);

    for (i = 0; i < VehiclePoolIndices.Length; ++i)
    {
        GRI.VehiclePoolMaxActives[VehiclePoolIndices[i]] = Value;
    }
}

function SetVehiclePoolIsActiveByTag(name VehiclePoolTag, bool bIsActive)
{
    local int i;
    local array<byte> VehiclePoolIndices;

    GetVehiclePoolIndicesByTag(VehiclePoolTag, VehiclePoolIndices);

    for (i = 0; i < VehiclePoolIndices.Length; ++i)
    {
        SetVehiclePoolIsActive(VehiclePoolIndices[i], bIsActive);
    }
}

function ToggleVehiclePoolIsActiveByTag(name VehiclePoolTag)
{
    local int i;
    local array<byte> VehiclePoolIndices;

    GetVehiclePoolIndicesByTag(VehiclePoolTag, VehiclePoolIndices);

    for (i = 0; i < VehiclePoolIndices.Length; ++i)
    {
        SetVehiclePoolIsActive(VehiclePoolIndices[i], !GRI.IsVehiclePoolActive(VehiclePoolIndices[i]));
    }
}

function int GetVehiclePoolCount()
{
    return VehiclePools.Length;
}

function int GetSpawnPointCount()
{
    return SpawnPoints.Length;
}

//==============================================================================
// Spawn Vehicle Functions
//==============================================================================

function int GetSpawnVehicleCount()
{
    local int i;
    local int SpawnVehicleCount;

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
    local Controller C;
    local PlayerController PC;

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
    bDirectional=false
    DrawScale=3.0
    SpawnError_None=0
    SpawnError_Fatal=1
    SpawnError_MaxVehicles=2
    SpawnError_Cooldown=3
    SpawnError_SpawnLimit=4
    SpawnError_ActiveLimit=5
    SpawnError_PoolInactive=6
    SpawnError_SpawnInactive=7
    SpawnError_Blocked=8
    SpawnError_Failed=9
    SpawnError_BadTeamPool=10
    SpawnError_BadTeamSpawnPoint=11
    SpawnError_TryToDriveFailed=12
    SpawnError_BadSpawnType=13
    SpawnError_IncorrectRole=14
    SpawnError_SpawnPointsDontMatch=15
    MaxTeamVehicles(0)=32
    MaxTeamVehicles(1)=32
    SpawnPointType_Infantry=0
    SpawnPointType_Vehicles=1
    SVT_None=0
    SVT_EngineOff=1
    SVT_Always=2
}

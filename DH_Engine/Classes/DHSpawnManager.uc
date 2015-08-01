//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHSpawnManager extends SVehicleFactory;

const   SPAWN_POINTS_MAX = 48;
const   VEHICLE_POOLS_MAX = 32;
const   SPAWN_VEHICLES_MAX = 8;
const   SPAWN_VEHICLES_BLOCK_RADIUS = 2048.0;

enum ESpawnPointType
{
    ESPT_Infantry,
    ESPT_Vehicles,
    ESPT_Mortars,
    ESPT_All
};

enum ESpawnVehicleType
{
    ESVT_None,
    ESVT_EngineOff, // vehicle's engine must be off for players to be able to deploy into it
    ESVT_Always     // player's can always spawn into or next to vehicle (more like a mobile deploy vehicle from DH v5.0/5.1)
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
    var() float             RespawnTime;             // respawn interval in seconds
    var() byte              MaxSpawns;               // how many vehicles can be spawned from this pool
    var() byte              MaxActive;               // how many vehicles from this pool can be active at once

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

// TODO: these were basically used for debug, reduce this down to a simple binary
// for whether a fatal error occurred or not (the user never needs to know the specifics)
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

function PostBeginPlay()
{
    local DHSpawnPoint SP;
    local bool         bIsVehiclePoolValid;
    local int          i, j;

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
    for (i = 0; i < VehiclePools.Length; ++i)
    {
        // Remove VP if it has no specified vehicle class
        if (VehiclePools[i].VehicleClass == none)
        {
            VehiclePools.Remove(i--, 1);
            continue;
        }

        bIsVehiclePoolValid = true;

        // Remove VP if its vehicle class is not unique
        for (j = i - 1; j >= 0; --j)
        {
            if (VehiclePools[i].VehicleClass == VehiclePools[j].VehicleClass) // vehicle class already exists, mark as non-unique
            {
                bIsVehiclePoolValid = false;
                break;
            }
        }

        if (!bIsVehiclePoolValid)
        {
            Warn("VehiclePools[" $ i $ "].VehicleClass (" $ VehiclePools[i].VehicleClass $ ") is not unique and will be removed!");
            VehiclePools.Remove(i--, 1);
            continue;
        }

        // VP is valid
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

    // Set repeating 1 second timer that checks whether spawn vehicles are blocked from players deploying to them
    SetTimer(1.0, true);
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

    if (C == none || GRI == none)
    {
        return;
    }

    // Check spawn settings
    if (!GRI.AreSpawnSettingsValid(C.GetTeamNum(), DHRoleInfo(C.GetRoleInfo()), C.SpawnPointIndex, C.VehiclePoolIndex, C.SpawnVehicleIndex))
    {
        return;
    }

    // Check spawn point
    SP = SpawnPoints[C.SpawnPointIndex];

    if (SP == none)
    {
        return;
    }

    // Check vehicle pool
    SpawnError = GetVehiclePoolError(C, SP);

    if (SpawnError != SpawnError_None)
    {
        return;
    }

    GetSpawnLocation(SP, SP.VehicleLocationHints, VehiclePools[C.VehiclePoolIndex].VehicleClass.default.CollisionRadius, SpawnLocation, SpawnRotation);
}

function GetSpawnLocation(DHSpawnPoint SP, array<DHLocationHint> LocationHints, float CollisionRadius, out vector SpawnLocation, out rotator SpawnRotation)
{
    local Controller    C;
    local Pawn          P;
    local array<vector> EnemyLocations;
    local array<int>    LocationHintIndices;
    local int           LocationHintIndex, i, j, k;
    local bool          bIsBlocked;

    // Scramble location hint indices so we don't use the same ones repeatedly
    LocationHintIndices = class'DHLib'.static.CreateIndicesArray(LocationHints.Length);
    class'DHLib'.static.FisherYatesShuffle(LocationHintIndices);

    // Put location hints with enemies nearby at the end of the array to be evaluated last
    if (LocationHintIndices.Length > 1)
    {
        // Get all enemy locations
        for (C = Level.ControllerList; C != none; C = C.NextController)
        {
            if (C.Pawn != none && C.GetTeamNum() != SP.TeamIndex)
            {
                EnemyLocations[EnemyLocations.Length] = C.Pawn.Location;
            }
        }

        for (i = LocationHintIndices.Length - 1; i >= 0; --i)
        {
            for (j = 0; j < EnemyLocations.Length; ++j)
            {
                // Location hint has enemies nearby, so move to end of the array
                if (VSize(EnemyLocations[j] - LocationHints[LocationHintIndices[i]].Location) <= SP.LocationHintDeferDistance)
                {
                    k = LocationHintIndices[i];
                    LocationHintIndices.Remove(i, 1);
                    LocationHintIndices[LocationHintIndices.Length] = k;
                }
            }
        }
    }

    LocationHintIndex = -1; // initialize with invalid index, so later we can tell is we found a valid one

    // Loop through location hints & try to find one that isn't blocked by a nearby pawn
    for (i = 0; i < LocationHintIndices.Length; ++i)
    {
        if (LocationHints[LocationHintIndices[i]] == none)
        {
            continue;
        }

        bIsBlocked = false;

        foreach RadiusActors(class'Pawn', P, CollisionRadius, LocationHints[LocationHintIndices[i]].Location)
        {
            // Found a blocking pawn, so ignore this location hint & exit the foreach iteration
            bIsBlocked = true;
            break;
        }

        // Location hint isn't blocked, so we'll use it & exit the for loop
        if (!bIsBlocked)
        {
            LocationHintIndex = LocationHintIndices[i];
            break;
        }
    }

    // Found a usable location hint
    if (LocationHintIndex != -1)
    {
        SpawnLocation = LocationHints[LocationHintIndex].Location;
        SpawnRotation = LocationHints[LocationHintIndex].Rotation;
    }
    // Otherwise use spawn point itself
    else
    {
        SpawnLocation = SP.Location;
        SpawnRotation = SP.Rotation;
    }
}

function SpawnPlayer(DHPlayer C, out byte SpawnError)
{
    if (C != none)
    {
        if (C.VehiclePoolIndex != 255) // deploy into vehicle
        {
            SpawnVehicle(C, SpawnError);
        }
        else if (C.SpawnVehicleIndex != 255) // deploy to spawn vehicle
        {
            SpawnPlayerAtSpawnVehicle(C, SpawnError);
        }
        else if (SpawnPoints[C.SpawnPointIndex] != none) // deploy to spawn point
        {
            SpawnInfantry(C, SpawnError);
        }

        // Fade out from blackout to normal view
        if (C.Pawn != none)
        {
            C.ClientFadeFromBlack(3.0);
        }
    }
}

function SpawnVehicle(DHPlayer C, out byte SpawnError)
{
    local ROVehicle V;
    local vector    SpawnLocation;
    local rotator   SpawnRotation;
    local int       i;

    if (C == none || C.Pawn != none)
    {
        SpawnError = SpawnError_Fatal;

        return;
    }

    // Make sure player isn't excluded from a tank crew role
    if (VehiclePools[C.VehiclePoolIndex].VehicleClass.default.bMustBeTankCommander && (ROPlayerReplicationInfo(C.PlayerReplicationInfo) == none
        || ROPlayerReplicationInfo(C.PlayerReplicationInfo).RoleInfo == none || !ROPlayerReplicationInfo(C.PlayerReplicationInfo).RoleInfo.bCanBeTankCrew))
    {
        SpawnError = SpawnError_IncorrectRole;

        return;
    }

    // Some checks that we have valid settings to spawn a vehicle
    DrySpawnVehicle(C, SpawnLocation, SpawnRotation, SpawnError);

    if (SpawnError != SpawnError_None)
    {
        return;
    }

    // This calls old RestartPlayer (spawns player in black room) & avoids reinforcement subtraction (because we will subtract later)
    if (DarkestHourGame(Level.Game) != none)
    {
        DarkestHourGame(Level.Game).DeployRestartPlayer(C, false, true);
    }

    if (C.Pawn == none)
    {
        SpawnError = SpawnError_PawnSpawnFailed;

        return;
    }

    // Now spawn the vehicle (& make sure it was successful)
    V = Spawn(VehiclePools[C.VehiclePoolIndex].VehicleClass, self,, SpawnLocation, SpawnRotation);

    if (V == none)
    {
        SpawnError = SpawnError_Failed;

        return;
    }

    // If we successfully enter the vehicle
    if(V.TryToDrive(C.Pawn))
    {
        // Set vehicle properties & add to our Vehicles array
        V.SetTeamNum(V.default.VehicleTeam);
        V.ParentFactory = self;
        Vehicles[Vehicles.Length] = V;

        // Start engine
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

        // If it's a spawn vehicle that doesn't require the engine to be off, add to GRI's SpawnVehicles array
        if (VehiclePools[C.VehiclePoolIndex].SpawnVehicleType == ESVT_Always)
        {
            GRI.AddSpawnVehicle(V);
        }

        // Increment vehicle counts
        ++TeamVehicleCounts[V.default.VehicleTeam];
        --GRI.MaxTeamVehicles[V.default.VehicleTeam];
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
    }
    // We were unable to enter the vehicle, so destroy it & kill the player, so they aren't stuck in the black room
    else
    {
        V.Destroy();
        C.Pawn.Suicide();
        SpawnError = SpawnError_TryToDriveFailed;
    }
}

function SpawnPlayerAtSpawnVehicle(DHPlayer C, out byte SpawnError)
{
    local Vehicle    V, EntryVehicle;
    local vector     Offset;
    local array<int> ExitPositionIndices;
    local int        VehiclePoolIndex, i;

    if (C == none || GRI == none || DarkestHourGame(Level.Game) == none)
    {
        SpawnError = SpawnError_Fatal;

        return;
    }

    // Spawn vehicle & make sure it was successful
    V = GRI.SpawnVehicles[C.SpawnVehicleIndex].Vehicle;

    if (V == none)
    {
        SpawnError = SpawnError_Failed;

        return;
    }

    // Spawn player pawn in black room & make sure it was successful
    if (C.Pawn == none)
    {
        DarkestHourGame(Level.Game).DeployRestartPlayer(C, false, true);
    }

    if (C.Pawn == none)
    {
        SpawnError = SpawnError_PawnSpawnFailed;

        return;
    }

    SpawnError = SpawnError_None;
    Offset = C.Pawn.default.CollisionHeight * vect(0.0, 0.0, 0.5);

    // Check if we can deploy into or near the vehicle
    while (true)
    {
        if (GRI.CanSpawnAtVehicle(C.GetTeamNum(), C.SpawnVehicleIndex))
        {
            // Randomise exit locations
            ExitPositionIndices = class'DHLib'.static.CreateIndicesArray(V.ExitPositions.Length);
            class'DHLib'.static.FisherYatesShuffle(ExitPositionIndices);

            VehiclePoolIndex = GRI.GetVehiclePoolIndex(GRI.SpawnVehicles[C.SpawnVehicleIndex].VehicleClass);

            // Spawn vehicle is the type that requires its engine to be off to allow players to deploy to it, so it will be stationary
            if (VehiclePools[VehiclePoolIndex].SpawnVehicleType == SVT_EngineOff)
            {
                // 1st choice - attempt to deploy at an exit position
                for (i = 0; i < ExitPositionIndices.Length; ++i)
                {
                    if (TeleportPlayer(C, V.Location + (V.ExitPositions[ExitPositionIndices[i]] >> V.Rotation) + Offset, V.Rotation))
                    {
                        return; // success
                    }
                }

                // 2nd choice - if all exit positions were blocked, attempt to deploy into the vehicle
                EntryVehicle = FindEntryVehicle(C.Pawn, ROVehicle(V));

                if (EntryVehicle != none && EntryVehicle.TryToDrive(C.Pawn))
                {
                    return; // success
                }

                break; // failure
            }
            // Spawn vehicle is the type that always allows players to deploy to it & doesn't need its engine to be off, so it may well be moving
            else if (VehiclePools[VehiclePoolIndex].SpawnVehicleType == SVT_Always)
            {
                // 1st choice - attempt to deploy into the vehicle
                EntryVehicle = FindEntryVehicle(C.Pawn, ROVehicle(V));

                if (EntryVehicle != none && EntryVehicle.TryToDrive(C.Pawn))
                {
                    return; // success
                }

                // 2nd choice - if unable to enter vehicle, attempt to deploy at an exit position
                // Matt TODO: think we need to add a vehicle speed check, to avoid deploying player at exit position of speeding vehicle they can't enter, probably because it's full
                // Or maybe just remove this 2nd option, so players can only deploy to an 'always' spawn vehicle if they can deploy inside it
                for (i = 0; i < ExitPositionIndices.Length; ++i)
                {
                    if (TeleportPlayer(C, V.Location + (V.ExitPositions[ExitPositionIndices[i]] >> V.Rotation) + Offset, V.Rotation))
                    {
                        return; // success
                    }
                }

                break; // failure
            }
        }
        else
        {
            break; // failure
        }
    }

    // Attempting to deploy into or near the vehicle failed, so kill the player pawn we spawned earlier
    SpawnError = SpawnError_TryToDriveFailed;
    C.Pawn.Suicide();
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

// Similar to FindEntryVehicle() function in a Vehicle class, it checks for a suitable vehicle position to enter, before we call TryToDrive() on the vehicle
// We need to do this, otherwise if we TryToDrive() a vehicle that already has a driver, we fail to enter that vehicle, so here we try to find an empty, valid weapon pawn to enter
// Deliberately ignores driver position, to discourage players from deploying into a spawn vehicle, which may be carefully positioned by the team, & immediately driving off in it
// Prioritises passenger positions over real weapon positions (MGs or cannons), so players deploying into spawn vehicle are less likely to be exposed & have a moment to orient themselves
function Vehicle FindEntryVehicle(Pawn P, ROVehicle V)
{
    local VehicleWeaponPawn        WP;
    local array<VehicleWeaponPawn> RealWeaponPawns;
    local bool bPlayerIsTankCrew;
    local int  i;

    if (P == none || V == none)
    {
        return none;
    }

    // Record whether player is allowed to use tanks
    bPlayerIsTankCrew = P != none && P.Controller != none && ROPlayerReplicationInfo(P.Controller.PlayerReplicationInfo) != none &&
        ROPlayerReplicationInfo(P.Controller.PlayerReplicationInfo).RoleInfo != none && ROPlayerReplicationInfo(P.Controller.PlayerReplicationInfo).RoleInfo.bCanBeTankCrew;

    // Loop through the weapon pawns to check if we can enter one (but skip real weapon positions, like MGs & cannons, on this 1st pass, so we prioritise passenger slots)
    for (i = 0; i < V.WeaponPawns.Length; ++i)
    {
        WP = V.WeaponPawns[i];

        if (WP != none)
        {
            // If weapon pawn is not a passenger slot (i.e. it's an MG or cannon), skip it on this 1st pass, but record it to check later if we don't find a valid passenger slot
            if (!WP.IsA('ROPassengerPawn'))
            {
                RealWeaponPawns[RealWeaponPawns.Length] = WP;
                continue;
            }

            // Enter weapon pawn position if it's empty & player isn't barred by tank crew restriction
            if (WP.Driver == none && (bPlayerIsTankCrew || !WP.IsA('ROVehicleWeaponPawn') || !ROVehicleWeaponPawn(WP).bMustBeTankCrew))
            {
                return WP;
            }
        }
    }

    // We didn't find a valid passenger slot, so now try any real weapon positions that we skipped on the 1st pass
    for (i = 0; i < RealWeaponPawns.Length; ++i)
    {
        WP = RealWeaponPawns[i];

        // Enter weapon pawn position if it's empty & player isn't barred by tank crew restriction
        if (WP.Driver == none && (bPlayerIsTankCrew || !WP.IsA('ROVehicleWeaponPawn') || !ROVehicleWeaponPawn(WP).bMustBeTankCrew))
        {
            return WP;
        }
    }

    return none; // there are no empty, usable vehicle positions
}

function byte GetVehiclePoolError(DHPlayer C, DHSpawnPoint SP)
{
    if (C == none || GRI == none)
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

    if (C == none || GRI == none)
    {
        return;
    }

    // Check spawn settings
    if (!GRI.AreSpawnSettingsValid(C.GetTeamNum(), DHRoleInfo(C.GetRoleInfo()), C.SpawnPointIndex, C.VehiclePoolIndex, C.SpawnVehicleIndex))
    {
        return;
    }

    // Check spawn point
    SP = SpawnPoints[C.SpawnPointIndex];

    if (SP == none)
    {
        return;
    }

    GetSpawnLocation(SP, SP.InfantryLocationHints, class'DHPawn'.default.CollisionRadius, SpawnLocation, SpawnRotation);

    SpawnError = SpawnError_None;
}

function SpawnInfantry(DHPlayer C, out byte SpawnError)
{
    local DHPawn  P;
    local vector  SpawnLocation;
    local rotator SpawnRotation;

    if (C == none || C.Pawn != none)
    {
        SpawnError = SpawnError_Fatal;

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
}

event VehicleDestroyed(Vehicle V)
{
    local int NextAvailableTime, i, j;

    super.VehicleDestroyed(V);

    // Removes the destroyed vehicle from the managed Vehicles array
    for (i = Vehicles.Length - 1; i >= 0; --i)
    {
        if (V == Vehicles[i])
        {
            --TeamVehicleCounts[Vehicles[i].VehicleTeam];
            ++GRI.MaxTeamVehicles[Vehicles[i].VehicleTeam];
            Vehicles.Remove(i, 1);

            break;
        }
    }

    // Updates the destroyed vehicle in the VehiclePools array
    for (i = 0; i < VehiclePools.Length; ++i)
    {
        if (V.class == VehiclePools[i].VehicleClass)
        {
            // Updates due to vehicle being destroyed
            GRI.VehiclePoolActiveCounts[i] -= 1;

            if (!GRI.IsVehiclePoolInfinite(i))
            {
                BroadcastTeamLocalizedMessage(VehiclePools[i].VehicleClass.default.VehicleTeam, Level.Game.default.GameMessageClass, 100 + i,,, self); // "vehicle has been destroyed"
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
                    VehiclePools[i].Slots[j].RespawnTime = GRI.ElapsedTime + VehiclePools[i].RespawnTime;

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

private function SetSpawnPointIsActive(byte SpawnPointIndex, bool bIsActive)
{
    if (GRI != none)
    {
        GRI.SetSpawnPointIsActive(SpawnPointIndex, bIsActive);
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

function ToggleSpawnPointIsActiveByTag(name SpawnPointTag)
{
    local array<byte> SpawnPointIndices;
    local int         i;

    GetSpawnPointIndicesByTag(SpawnPointTag, SpawnPointIndices);

    for (i = 0; i < SpawnPointIndices.Length; ++i)
    {
        SetSpawnPointIsActive(SpawnPointIndices[i], !(GRI != none && GRI.IsSpawnPointIndexActive(i)));
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
    if (GRI != none && !GRI.IsVehiclePoolInfinite(VehiclePoolIndex))
    {
        GRI.VehiclePoolMaxSpawns[VehiclePoolIndex] = Min(int(GRI.VehiclePoolMaxSpawns[VehiclePoolIndex]) + int(Value), 254);

        // Send "vehicle reinforcements have arrived" message
        if (Value > 0)
        {
            BroadcastTeamLocalizedMessage(VehiclePools[VehiclePoolIndex].VehicleClass.default.Team, Level.Game.default.GameMessageClass, 300 + VehiclePoolIndex,,, self);
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

function AddVehiclePoolMaxActiveByTag(name VehiclePoolTag, byte Value)
{
    local array<byte> VehiclePoolIndices;
    local int         i;

    if (GRI != none)
    {
        GetVehiclePoolIndicesByTag(VehiclePoolTag, VehiclePoolIndices);

        for (i = 0; i < VehiclePoolIndices.Length; ++i)
        {
            GRI.VehiclePoolMaxActives[VehiclePoolIndices[i]] += Value;
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
    local int SpawnVehicleCount, i;

    if (GRI != none)
    {
        for (i = 0; i < arraycount(GRI.SpawnVehicles); ++i)
        {
            if (GRI.SpawnVehicles[i].Vehicle != none)
            {
                ++SpawnVehicleCount;
            }
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

// A repeating timer to checks whether spawn vehicles are blocked from players deploying to them
function Timer()
{
    local Vehicle     V;
    local Pawn        P;
    local DHObjective O;
    local bool        bIsBlocked;
    local int         i, j;

    if (GRI == none)
    {
        return;
    }

    // Loop through all recorded spawn vehicles
    for (i = 0; i < arraycount(GRI.SpawnVehicles); ++i)
    {
        bIsBlocked = false;

        V = GRI.SpawnVehicles[i].Vehicle;

        if (V == none)
        {
            continue;
        }

        // Check whether there is an enemy pawn within blocking distance of this spawn vehicle
        foreach V.RadiusActors(class'Pawn', P, SPAWN_VEHICLES_BLOCK_RADIUS)
        {
            if (P != none && P.Controller != none)
            {
                if (V.GetTeamNum() != P.GetTeamNum())
                {
                    bIsBlocked = true;
                    break;
                }
            }
        }

        if (!bIsBlocked)
        {
            // Check whether this spawn vehicle is inside an active objective
            for (j = 0; j < arraycount(GRI.DHObjectives); ++j)
            {
                O = GRI.DHObjectives[j];

                if (O != none && O.bActive && O.WithinArea(V))
                {
                    bIsBlocked = true;
                    break;
                }
            }
        }

        // Update this spawn vehicle's bIsBlocked setting in the GRI
        GRI.SpawnVehicles[i].bIsBlocked = bIsBlocked;
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
}

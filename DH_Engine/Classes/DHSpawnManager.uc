//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DHSpawnManager extends SVehicleFactory;

const   SPAWN_POINTS_MAX = 48;
const   VEHICLE_POOLS_MAX = 32;
const   SPAWN_VEHICLES_MAX = 8;
const   SPAWN_VEHICLES_BLOCK_RADIUS = 2048.0;

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

var     const byte  BlockFlags_None;
var     const byte  BlockFlags_EnemiesNearby;
var     const byte  BlockFlags_InObjective;
var     const byte  BlockFlags_Full;

function PostBeginPlay()
{
    local DHSpawnPoint SP;
    local bool         bVehiclePoolIsInvalid;
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
            bVehiclePoolIsInvalid = true;
        }

        // Remove VP if it is invalid (no specified class or it's a duplicate)
        if (bVehiclePoolIsInvalid)
        {
            Warn("VehiclePools[" $ i $ "] is invalid & has been removed! (VehicleClass =" @ VehiclePools[i].VehicleClass $ ")");
            VehiclePools.Remove(i, 1);
            bVehiclePoolIsInvalid = false; // reset for next VP to be checked
            continue;
        }

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

function bool DrySpawnVehicle(DHPlayer C, out vector SpawnLocation, out rotator SpawnRotation)
{
    local DHSpawnPoint SP;

    if (C == none || GRI == none || C.bSpawnPointInvalidated)
    {
        return false;
    }

    // Check spawn settings
    if (!GRI.AreSpawnSettingsValid(C.GetTeamNum(), DHRoleInfo(C.GetRoleInfo()), C.SpawnPointIndex, C.VehiclePoolIndex, C.SpawnVehicleIndex))
    {
        return false;
    }

    // Check spawn point
    SP = SpawnPoints[C.SpawnPointIndex];

    if (SP == none)
    {
        return false;
    }

    // Check vehicle pool
    if (!GetVehiclePoolError(C, SP))
    {
        return false;
    }

    GetSpawnLocation(SP, SP.VehicleLocationHints, VehiclePools[C.VehiclePoolIndex].VehicleClass.default.CollisionRadius, SpawnLocation, SpawnRotation);

    return true;
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
    LocationHintIndices = class'UArray'.static.Range(0, LocationHints.Length - 1);
    class'UArray'.static.IShuffle(LocationHintIndices);

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

    LocationHintIndex = -1; // initialize with invalid index, so later we can tell if we found a valid one

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

function bool SpawnPlayer(DHPlayer C)
{
    if (C != none)
    {
        if (C.VehiclePoolIndex != 255) // deploy into vehicle
        {
            return SpawnVehicle(C);
        }
        else if (C.SpawnVehicleIndex != 255) // deploy to spawn vehicle
        {
            return SpawnPlayerAtSpawnVehicle(C);
        }
        else if (SpawnPoints[C.SpawnPointIndex] != none) // deploy to spawn point
        {
            return SpawnInfantry(C);
        }
    }
}

function bool SpawnVehicle(DHPlayer C)
{
    local ROVehicle V;
    local vector    SpawnLocation;
    local rotator   SpawnRotation;
    local int       i;

    if (C == none || C.Pawn != none)
    {
        return false;
    }

    // Make sure player isn't excluded from a tank crew role
    if (VehiclePools[C.VehiclePoolIndex].VehicleClass.default.bMustBeTankCommander &&
        (ROPlayerReplicationInfo(C.PlayerReplicationInfo) == none
            || ROPlayerReplicationInfo(C.PlayerReplicationInfo).RoleInfo == none
            || !ROPlayerReplicationInfo(C.PlayerReplicationInfo).RoleInfo.bCanBeTankCrew))
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

function bool SpawnPlayerAtSpawnVehicle(DHPlayer C)
{
    local Pawn       P;
    local Vehicle    V, EntryVehicle;
    local vector     Offset;
    local array<int> ExitPositionIndices;
    local int        i;

    if (C == none || GRI == none || DarkestHourGame(Level.Game) == none)
    {
        return false;
    }

    // Spawn vehicle & make sure it was successful
    V = GRI.SpawnVehicles[C.SpawnVehicleIndex].Vehicle;

    if (V == none)
    {
        return false;
    }

    // Spawn player pawn in black room & make sure it was successful
    if (C.Pawn == none)
    {
        DarkestHourGame(Level.Game).DeployRestartPlayer(C, false, true);
    }

    if (C.Pawn == none)
    {
        return false;
    }

    Offset = C.PawnClass.default.CollisionHeight * vect(0.0, 0.0, 0.5);

    // Check if we can deploy into or near the vehicle
    if (GRI.CanSpawnAtVehicle(C.GetTeamNum(), C.SpawnVehicleIndex))
    {
        // Randomise exit locations
        ExitPositionIndices = class'UArray'.static.Range(0, V.ExitPositions.Length - 1);
        class'UArray'.static.IShuffle(ExitPositionIndices);

        // Spawn vehicle is the type that requires its engine to be off to allow players to deploy to it, so it will be stationary
        if (V.IsA('DHVehicle') && DHVehicle(V).bEngineOff)
        {
            // Attempt to deploy at an exit position
            for (i = 0; i < ExitPositionIndices.Length; ++i)
            {
                if (TeleportPlayer(C, V.Location + (V.ExitPositions[ExitPositionIndices[i]] >> V.Rotation) + Offset, V.Rotation))
                {
                    return true;
                }
            }
        }
        else
        {
            // Attempt to deploy into the vehicle
            EntryVehicle = FindEntryVehicle(C.GetRoleInfo().bCanBeTankCrew, ROVehicle(V));

            if (EntryVehicle != none && EntryVehicle.TryToDrive(C.Pawn))
            {
                return true;
            }
        }
    }

    // Invalidate spawn point, reset spawn vehicle index, and zero out next
    // spawn time. Since next spawn time is set when player is reset above,
    // without this, the player would be forced to wait to spawn timer again.
    C.bSpawnPointInvalidated = true;
    C.SpawnVehicleIndex = 255;
    C.NextSpawnTime = 0;

    // Attempting to deploy into or near the vehicle failed, so kill the player pawn we spawned earlier
    P = C.Pawn;
    C.UnPossess();
    P.Suicide();

    // This makes sure the player doesn't watch and hear himself die. A
    // dirty hack, but the alternative is much worse.
    C.ServerNextViewPoint();

    return false;
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
function Vehicle FindEntryVehicle(bool bCanBeTankCrew, ROVehicle V)
{
    local VehicleWeaponPawn        WP;
    local array<VehicleWeaponPawn> RealWeaponPawns;
    local int  i;

    if (V == none)
    {
        return none;
    }

    // Loop through the weapon pawns to check if we can enter one (but skip real weapon positions, like MGs & cannons, on this 1st pass, so we prioritise passenger slots)
    for (i = 0; i < V.WeaponPawns.Length; ++i)
    {
        WP = V.WeaponPawns[i];

        if (WP != none)
        {
            // If weapon pawn is not a passenger slot (i.e. it's an MG or cannon), skip it on this 1st pass, but record it to check later if we don't find a valid passenger slot
            if (!WP.IsA('DHPassengerPawn'))
            {
                RealWeaponPawns[RealWeaponPawns.Length] = WP;
                continue;
            }

            // Enter weapon pawn position if it's empty & player isn't barred by tank crew restriction
            if (WP.Driver == none && (bCanBeTankCrew || !WP.IsA('ROVehicleWeaponPawn') || !ROVehicleWeaponPawn(WP).bMustBeTankCrew))
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
        if (WP.Driver == none && (bCanBeTankCrew || !WP.IsA('ROVehicleWeaponPawn') || !ROVehicleWeaponPawn(WP).bMustBeTankCrew))
        {
            return WP;
        }
    }

    return none; // there are no empty, usable vehicle positions
}

function bool GetVehiclePoolError(DHPlayer C, DHSpawnPoint SP)
{
    if (SP == none || C == none || GRI == none)
    {
        return false;
    }

    if (C.VehiclePoolIndex >= VEHICLE_POOLS_MAX || VehiclePools[C.VehiclePoolIndex].VehicleClass == none)
    {
        return false;
    }

    if (!SP.CanSpawnVehicles() && !(SP.CanSpawnInfantryVehicles() && !VehiclePools[C.VehiclePoolIndex].VehicleClass.default.bMustBeTankCommander))
    {
        return false;
    }

    if (!GRI.IgnoresMaxTeamVehiclesFlags(C.VehiclePoolIndex) &&
        TeamVehicleCounts[VehiclePools[C.VehiclePoolIndex].VehicleClass.default.VehicleTeam] >= MaxTeamVehicles[VehiclePools[C.VehiclePoolIndex].VehicleClass.default.VehicleTeam])
    {
        return false;
    }

    if (!GRI.IsVehiclePoolActive(C.VehiclePoolIndex))
    {
        return false;
    }

    if (Level.TimeSeconds < GRI.VehiclePoolNextAvailableTimes[C.VehiclePoolIndex])
    {
        return false;
    }

    if (GRI.VehiclePoolSpawnCounts[C.VehiclePoolIndex] >= GRI.VehiclePoolMaxSpawns[C.VehiclePoolIndex])
    {
        return false;
    }

    if (GRI.VehiclePoolActiveCounts[C.VehiclePoolIndex] >= GRI.VehiclePoolMaxActives[C.VehiclePoolIndex])
    {
        return false;
    }

    return true;
}

function bool DrySpawnInfantry(DHPlayer C, out vector SpawnLocation, out rotator SpawnRotation)
{
    local DHSpawnPoint SP;

    if (C == none || GRI == none || C.bSpawnPointInvalidated)
    {
        return false;
    }

    // Check spawn settings
    if (!GRI.AreSpawnSettingsValid(C.GetTeamNum(), DHRoleInfo(C.GetRoleInfo()), C.SpawnPointIndex, C.VehiclePoolIndex, C.SpawnVehicleIndex))
    {
        return false;
    }

    // Check spawn point
    SP = SpawnPoints[C.SpawnPointIndex];

    if (SP == none)
    {
        return false;
    }

    GetSpawnLocation(SP, SP.InfantryLocationHints, class'DHPawn'.default.CollisionRadius, SpawnLocation, SpawnRotation);

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

    P.TeleSpawnProtEnds = Level.TimeSeconds + SpawnPoints[C.SpawnPointIndex].SpawnProtectionTime;

    return true;
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
    if (SpawnPoints[SpawnPointIndex].bIsLocked)
    {
        return;
    }

    if (GRI != none)
    {
        GRI.SetSpawnPointIsActive(SpawnPointIndex, bIsActive);

        if (SpawnPoints[SpawnPointIndex].MineVolumeProtectionRef != none)
        {
            if (bIsActive)
            {
                SpawnPoints[SpawnPointIndex].MineVolumeProtectionRef.Activate();
            }
            else
            {
                SpawnPoints[SpawnPointIndex].MineVolumeProtectionRef.Deactivate();
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
    local byte        BlockFlags;
    local int         i, j;

    if (GRI == none)
    {
        return;
    }

    // Loop through all recorded spawn vehicles
    for (i = 0; i < arraycount(GRI.SpawnVehicles); ++i)
    {
        BlockFlags = 0;

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
                    BlockFlags = BlockFlags | BlockFlags_EnemiesNearby;

                    break;
                }
            }
        }

        // Check whether this spawn vehicle is inside an active objective
        for (j = 0; j < arraycount(GRI.DHObjectives); ++j)
        {
            O = GRI.DHObjectives[j];

            if (O != none && O.bActive && O.WithinArea(V))
            {
                BlockFlags = BlockFlags | BlockFlags_InObjective;

                break;
            }
        }

        // Check if a suitable entry vehicle is available for non-crew
        if (FindEntryVehicle(false, ROVehicle(V)) == none)
        {
            BlockFlags = BlockFlags | BlockFlags_Full;
        }

        // Update this spawn vehicle's bIsBlocked setting in the GRI
        GRI.SpawnVehicles[i].BlockFlags = BlockFlags;
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
    BlockFlags_None=0
    BlockFlags_EnemiesNearby=1
    BlockFlags_InObjective=2
    BlockFlags_Full=4
}


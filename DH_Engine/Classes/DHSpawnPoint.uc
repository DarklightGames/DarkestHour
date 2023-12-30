//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHSpawnPoint extends DHSpawnPointBase
    hidecategories(Lighting,LightColor,Karma,Force,Sound)
    abstract;

enum ESpawnPointType
{
    ESPT_Infantry,
    ESPT_Vehicles,
    ESPT_Mortars,
    ESPT_All,
    ESPT_VehicleCrewOnly
};

var()   ESpawnPointType Type;
var()   bool            bNoSpawnVehicles;              // option to prevent SP from spawning spawn vehicles
var()   bool            bIsInitiallyActive;            // whether or not the SP is active at the start of the round (or waits to be activated later)
var()   bool            bIsInitiallyLocked;            // whether or not the SP is locked at the start of the round
var(DHSpawnPointBase)   bool            bBoatSpawn;    // players can only spawn boat vehicles from here

var     bool            bIsLocked;                     // locked spawn points will not be affected by enable or disable commands
var     bool            bCanOnlySpawnInfantryVehicles; // players can spawn into infantry vehicles (as well as on foot) but can't spawn armoured fighting vehicles

// Location hints - placed actors used for locations for spawning players
var     int             InfantryLocationHintIndexOffset;
var     int             VehicleLocationHintIndexOffset;
var()   name            InfantryLocationHintTag;       // the Tag for associated LocationHint actors used to spawn players on foot
var()   name            VehicleLocationHintTag;        // the Tag for associated LocationHint actors used to spawn players in vehicles
var     array<DHLocationHint>   InfantryLocationHints; // saved references to linked location hint actors
var     array<DHLocationHint>   VehicleLocationHints;
var()   float           LocationHintDeferDistance;     // the spawn manager will try to avoid spawning players at location hints where there are enemies within this distance
                                                       // (it will defer evaluation of any location hints that have enemies nearby)
var()   bool            bUseLocationAsFallback;        // If true, then use the location of this actor as a fallback location in the event that all location hints are blocked

// Options to link various types of actors to this SP, so they are only active when the SP is active
var()   name                    MineVolumeProtectionTag;
var()   name                    NoArtyVolumeProtectionTag;
var()   name                    LinkedAmmoResupplyTag;
var()   name                    LinkedVehicleFactoriesTag;
var     ROMineVolume            MineVolumeProtectionRef;
var     DHAmmoResupplyVolume    LinkedAmmoResupplyRef;
var     array<DHVehicleFactory> LinkedVehicleFactories;

// Spawn-limiting options.
var()   int             MaxSpawns;
var()   name            SpawnsExhaustedEvent;
var     int             SpawnsRemaining;

replication
{
    reliable if (bNetDirty && Role == ROLE_Authority)
        SpawnsRemaining;
}

// Modified to find associated location hint actors, used as positions to spawn players or vehicles, & build arrays of actor references
// Also to find any actors that are linked to this spawn point, so they are only active when the SP is active, & save actor references
// And to check whether an infantry spawn point should also allow players to spawn into infantry vehicles, as well as on foot
// That means cars, trucks or APCs, but not tanks or any vehicle that requires the player to be tank crew
// For that to be allowed, the leveller must have included some VehicleLocationHints linked to the infantry spawn point
simulated function PostBeginPlay()
{
    local DHLocationHint   LH;
    local RONoArtyVolume   NAV;
    local DHVehicleFactory VF;

    // On net client we only need to do 1 check in this function & only if spawn point is for infantry who are allowed to spawn in infantry vehicles
    // Client doesn't build or use arrays of location hints, so we just need to verify there is at least 1 valid vehicle location hint
    if (Role < ROLE_Authority)
    {
        if (Type == ESPT_Infantry && VehicleLocationHintTag != '')
        {
            foreach AllActors(class'DHLocationHint', LH, VehicleLocationHintTag)
            {
                bCanOnlySpawnInfantryVehicles = true;
                break; // no need to check for more, we only need to verify there is at least 1
            }
        }

        return; // net client doesn't need to do anything else - this function would otherwise be non-simulated & execute on server only
    }

    // Create location hint arrays
    BuildLocationHintsArrays();

    // Check whether an infantry spawn point should also allow players to spawn into infantry vehicles, as well as on foot (this is where server flags it)
    if (Type == ESPT_Infantry && VehicleLocationHints.Length > 0)
    {
        bCanOnlySpawnInfantryVehicles = true;
    }

    // Find any linked mine volume (that will only protect this spawn point only if the spawn is active)
    if (MineVolumeProtectionTag != '')
    {
        foreach AllActors(class'ROMineVolume', MineVolumeProtectionRef, MineVolumeProtectionTag)
        {
            break;
        }
    }

    // Find any linked ammo resupply volume (that will only be activated if this spawn point is active)
    // And tell it that it will be controlled by a spawn point, so it does not activate itself
    if (LinkedAmmoResupplyTag != '')
    {
        foreach DynamicActors(class'DHAmmoResupplyVolume', LinkedAmmoResupplyRef, LinkedAmmoResupplyTag)
        {
            LinkedAmmoResupplyRef.bControlledBySpawnPoint = true;
            break;
        }
    }

    // Find any linked no arty volume (that will only protect this spawn point if the spawn is active)
    // Note that we don't need to record a reference to the no arty volume actor, we only need to set its AssociatedActor reference to be this spawn point
    if (NoArtyVolumeProtectionTag != '')
    {
        foreach AllActors(class'RONoArtyVolume', NAV, NoArtyVolumeProtectionTag)
        {
            NAV.AssociatedActor = self;
            break;
        }
    }

    // Find any linked vehicle factories (that will only be activated if this spawn point is active)
    // And tell them they will be controlled by a spawn point, so they do not activate themselves
    if (LinkedVehicleFactoriesTag != '')
    {
        foreach DynamicActors(class'DHVehicleFactory', VF, LinkedVehicleFactoriesTag)
        {
            LinkedVehicleFactories[LinkedVehicleFactories.Length] = VF;
            VF.bControlledBySpawnPoint = true;
        }
    }

    super.PostBeginPlay();
}

function Reset()
{
    super.Reset();

    bIsLocked = bIsInitiallyLocked;

    SpawnsRemaining = MaxSpawns;
}

function BuildLocationHintsArrays()
{
    local DHLocationHint LH;

    // Find associated location hint actors & build arrays of actor references.
    foreach AllActors(class'DHLocationHint', LH)
    {
        if (LH.Tag != '')
        {
            if (LH.Tag == InfantryLocationHintTag)
            {
                InfantryLocationHints[InfantryLocationHints.Length] = LH;
            }
            else if (LH.Tag == VehicleLocationHintTag)
            {
                VehicleLocationHints[VehicleLocationHints.Length] = LH;
            }
        }
    }
}

// Modified to activate/deactivate any linked mine volume, resupply volume or vehicle factories, that get activated/deactivated with this spawn point
function SetIsActive(bool bIsActive)
{
    local DarkestHourGame  DHG;
    local DHVehicleFactory Factory;
    local int              i;

    super.SetIsActive(bIsActive);

    if (MineVolumeProtectionRef != none)
    {
        if (bIsActive)
        {
            MineVolumeProtectionRef.Activate();
        }
        else
        {
            MineVolumeProtectionRef.Deactivate();
        }
    }

    if (LinkedAmmoResupplyRef != none)
    {
        LinkedAmmoResupplyRef.bActive = bIsActive;

        DHG = DarkestHourGame(Level.Game);

        if (DHG != none)
        {
            for (i = 0; i < arraycount(DHG.DHResupplyAreas); ++i)
            {
                if (DHG.DHResupplyAreas[i] == LinkedAmmoResupplyRef)
                {
                    GRI.ResupplyAreas[i].bActive = bIsActive; // also match bActive in GRI's replicated ResupplyAreas array, used by HUD to display resupplies on the map
                    break;
                }
            }
        }
    }

    for (i = 0; i < LinkedVehicleFactories.Length; ++i)
    {
        Factory = LinkedVehicleFactories[i];

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

// New helper functions to check whether spawn point can spawn infantry, vehicles, or mortar crew
simulated function bool CanSpawnInfantry()
{
    return Type == ESPT_Infantry || Type == ESPT_All;
}

simulated function bool CanSpawnVehicles()
{
    return Type == ESPT_Vehicles || Type == ESPT_All;
}

simulated function bool CanSpawnMortars()
{
    return Type == ESPT_Mortars || Type == ESPT_All;
}

// Modified to check whether spawn point allows player to use it, depending on role & type of vehicle (if any)
simulated function bool CanSpawnWithParameters(DHGameReplicationInfo GRI, int TeamIndex, int RoleIndex, int SquadIndex, int VehiclePoolIndex, optional bool bSkipTimeCheck)
{
    local class<ROVehicle> VehicleClass;
    local DHRoleInfo       RI;

    if (!super.CanSpawnWithParameters(GRI, TeamIndex, RoleIndex, SquadIndex, VehiclePoolIndex, bSkipTimeCheck))
    {
        return false;
    }

    RI = GRI.GetRole(TeamIndex, RoleIndex);

    if (RI == none)
    {
        return false;
    }

    if (RI.default.bCanUseMortars && CanSpawnMortars())
    {
        return true;
    }

    VehicleClass = class<ROVehicle>(GRI.GetVehiclePoolVehicleClass(VehiclePoolIndex));

    if (VehicleClass == none)
    {
        if (Type == ESPT_VehicleCrewOnly)
        {
            return RI.default.bCanBeTankCrew;
        }
        else
        {
            return CanSpawnInfantry() || (RI.default.bCanBeTankCrew && CanSpawnVehicles());
        }
    }
    else
    {
        return CanSpawnVehicle(GRI, VehiclePoolIndex, bSkipTimeCheck);
    }
}

// Implemented to check whether spawn point can be used to spawn into a vehicle of a certain type
simulated function bool CanSpawnVehicle(DHGameReplicationInfo GRI, int VehiclePoolIndex, optional bool bSkipTimeCheck)
{
    local class<ROVehicle> VehicleClass;

    VehicleClass = class<ROVehicle>(GRI.GetVehiclePoolVehicleClass(VehiclePoolIndex));

    if (VehicleClass == none)
    {
        return false;
    }

    // If this is not a boat, and the spawn point only allows boats, then don't allow spawning into it
    if (bBoatSpawn != VehicleClass.default.bCanSwim)
    {
        return false;
    }

    return GetTeamIndex() == VehicleClass.default.VehicleTeam &&                                                    // check vehicle belongs to player's team
           (CanSpawnVehicles() || (bCanOnlySpawnInfantryVehicles && !VehicleClass.default.bMustBeTankCommander)) && // check SP can spawn vehicles
           !(bNoSpawnVehicles && GRI.VehiclePoolIsSpawnVehicles[VehiclePoolIndex] != 0) &&                          // if it's a spawn vehicle, make sure SP doesn't prohibit those
           GRI.CanSpawnVehicle(VehiclePoolIndex, bSkipTimeCheck);                                                   // check one of these vehicles is available at the current time
}

// Implemented to check whether spawn point can be used to spawn into a vehicle of a certain type
function bool PerformSpawn(DHPlayer PC)
{
    local DarkestHourGame G;
    local vector          SpawnLocation;
    local rotator         SpawnRotation;
    local Pawn            P;

    G = DarkestHourGame(Level.Game);

    if (CanSpawnWithParameters(GRI, PC.GetTeamNum(), Pc.GetRoleIndex(), PC.GetSquadIndex(), PC.VehiclePoolIndex) &&
        GetSpawnPosition(SpawnLocation, SpawnRotation, PC.VehiclePoolIndex) && G != none)
    {
        if (PC.VehiclePoolIndex >= 0)
        {
            P = G.SpawnManager.SpawnVehicle(PC, SpawnLocation, SpawnRotation);
        }
        else
        {
            P = G.SpawnPawn(PC, SpawnLocation, SpawnRotation, self);
        }

        if (P != none)
        {
            OnPawnSpawned(P);
        }

        return P != none;
    }

    return false;
}

// Modified to try to use one of the spawn point's linked LocationHint actors for the spawn location & rotation
// A random selection, ignoring any locations that have enemy nearby, or that are blocked by another pawn
function bool GetSpawnPosition(out vector SpawnLocation, out rotator SpawnRotation, int VehiclePoolIndex)
{
    local array<DHLocationHint> LocationHints;
    local DHLocationHint        LocationHint;
    local array<vector>         EnemyLocations;
    local int                   LocationHintIndexOffset, i, j, k;
    local class<ROVehicle>      VehicleClass;
    local Controller            C;
    local Pawn                  P;
    local bool                  bIsBlocked;
    local float                 TestCollisionRadius;
    local DHSpawnManager        SM;

    SM = DarkestHourGame(Level.Game).SpawnManager;

    if (VehiclePoolIndex >= 0)
    {
        LocationHints = VehicleLocationHints;
        LocationHintIndexOffset = VehicleLocationHintIndexOffset;
        VehicleClass = class<ROVehicle>(GRI.GetVehiclePoolVehicleClass(VehiclePoolIndex));
        TestCollisionRadius = VehicleClass.default.CollisionRadius;

/*
        LocationHintTag = SM.GetVehiclePoolLocationHintTag(VehiclePoolIndex);
        
        if (LocationHintTag != '')
        {
            // The vehicle pool has a location hint tag.
            // Try to preferentially use location hints with this tag.

            // First, determine if any of the location hints have this tag.
            for (i = 0; i < LocationHints.Length; ++i)
            {
                if (LocationHints[i].LocationHintTag == LocationHintTag)
                {
                    bHasMatchingLocationHintTag = true;
                    break;
                }
            }

            if (bHasMatchingLocationHintTag)
            {
                // We have location hints with the tag corresponding to the vehicle pool.
                // Remove all location hints that don't have this tag.
                for (i = LocationHints.Length; i >= 0; --i)
                {
                    if (VehicleLocationHints[i].LocationHintTag != LocationHintTag)
                    {
                        VehicleLocationHints.Remove(i, 1);
                        --i;
                    }
                }
            }
        }
        */
    }
    else
    {
        LocationHints = InfantryLocationHints;
        LocationHintIndexOffset = InfantryLocationHintIndexOffset;
        TestCollisionRadius = class'DHPawn'.default.CollisionRadius;
    }

    // TODO: make this functionality generic so it applied to all spawn point types?

    // Put location hints with enemies nearby at the end of the array to be evaluated last
    if (LocationHints.Length > 1)
    {
        // Get all enemy locations
        for (C = Level.ControllerList; C != none; C = C.NextController)
        {
            if (C.Pawn != none && C.GetTeamNum() != GetTeamIndex() && C.Pawn.Health > 0)
            {
                EnemyLocations[EnemyLocations.Length] = C.Pawn.Location;
            }
        }
    }

    LocationHint = none;

    // Loop through location hints & try to find one that isn't blocked by a nearby pawn
    for (i = 0; i < LocationHints.Length; ++i)
    {
        // Apply the location hint offset.
        j = (i + LocationHintIndexOffset) % LocationHints.Length;

        if (LocationHints[j] == none)
        {
            continue;
        }

        bIsBlocked = false;

        foreach RadiusActors(class'Pawn', P, TestCollisionRadius, LocationHints[j].Location)
        {
            // Found a blocking pawn, so ignore this location hint & exit the foreach iteration
            bIsBlocked = true;
            break;
        }
        
        for (k = 0; k < EnemyLocations.Length; ++k)
        {
            // Location hint has enemies nearby, so mark it as blocked.
            if (VSize(EnemyLocations[k] - LocationHints[j].Location) <= LocationHintDeferDistance)
            {
                bIsBlocked = true;
                break;
            }
        }

        if (!bIsBlocked)
        {
            // Location hint isn't blocked, so we'll use it & exit the for loop
            LocationHint = LocationHints[j];
            break;
        }
    }

    if (LocationHint == none)
    {
        if (LocationHints.Length == 0 || bUseLocationAsFallback)
        {
            // There are no location hints or we are using the location as a fallback.
            return super.GetSpawnPosition(SpawnLocation, SpawnRotation, VehiclePoolIndex);
        }
        else
        {
            // Last ditch effort, just pick a random location hint to try to spawn at.
            LocationHint = LocationHints[Rand(LocationHints.Length)];
        }
    }

    // TODO: Add in the ability to spawn infantry in a radius around the location hints.
    SpawnLocation = LocationHint.Location;
    SpawnRotation = LocationHint.Rotation;

    return true;
}

// Modified to increment the location hint index offsets after each successful spawn.
// Also, if the spawn point has limited spawns, it will be deactivated when it has no spawns remaining.
function OnPawnSpawned(Pawn P)
{
    super.OnPawnSpawned(P);
    
    // Increment the location hint index offset.
    if (P.IsA('Vehicle'))
    {
        ++VehicleLocationHintIndexOffset;
    }
    else
    {
        ++InfantryLocationHintIndexOffset;
    }
    
    if (HasLimitedSpawns())
    {
        --SpawnsRemaining;

        if (SpawnsRemaining <= 0)
        {
            // Deactivate the spawn point if it has no spawns remaining.
            SetIsActive(false);

            // Send an event with the exhausted event tag.
            TriggerEvent(SpawnsExhaustedEvent, self, None);
        }
    }
}

simulated function bool HasLimitedSpawns()
{
    return MaxSpawns > 0;
}

simulated function string GetMapText()
{
    if (HasLimitedSpawns())
    {
        return string(SpawnsRemaining);
    }

    return "";
}

defaultproperties
{
    bDirectional=true
    bStatic=true
    DrawScale=1.5
    bCollideWhenPlacing=true
    CollisionRadius=+00040.0
    CollisionHeight=+00043.0
    LocationHintDeferDistance=2048.0
}

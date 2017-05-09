//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
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
    ESPT_InfantryVehicles,
};

var()   ESpawnPointType Type;
var()   bool            bIsInitiallyActive;          // whether or not the SP is active at the start of the round (or waits to be activated later)
var()   name            InfantryLocationHintTag;     // the Tag for associated LocationHint actors used to spawn players on foot
var()   name            VehicleLocationHintTag;      // the Tag for associated LocationHint actors used to spawn players in vehicles
var()   name            MineVolumeProtectionTag;     // optional Tag for associated mine volume that protects this SP only when the SP is active
var()   name            NoArtyVolumeProtectionTag;   // optional Tag for associated no arty volume that protects this SP only when the SP is active
var()   name            LinkedVehicleFactoriesTag;   // optional Tag for vehicle factories that are only active when this SP is active

// Colin: The spawn manager will defer evaluation of any location hints that
// have enemies within this distance. In layman's terms, the spawn manager will
// prefer to spawn players at location hints where there are not enemies nearby.
var()   float                   LocationHintDeferDistance;

// Colin: Locked spawn points will not be affected by enable or disable commands.
var()   bool                    bIsInitiallyLocked;
var     bool                    bIsLocked;

var     array<DHLocationHint>   InfantryLocationHints;
var     array<DHLocationHint>   VehicleLocationHints;
var     ROMineVolume            MineVolumeProtectionRef;
var     array<DHVehicleFactory> LinkedVehicleFactories;

function PostBeginPlay()
{
    local DHLocationHint   LH;
    local RONoArtyVolume   NAV;
    local DHVehicleFactory VF;

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

    // Find any associated mine volume (that will only protect this spawn point only if the spawn is active)
    if (MineVolumeProtectionTag != '')
    {
        foreach AllActors(class'ROMineVolume', MineVolumeProtectionRef, MineVolumeProtectionTag)
        {
            break;
        }
    }

    // Find any associated no arty volume (that will only protect this spawn point if the spawn is active)
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

simulated function bool CanSpawnInfantry()
{
    return Type == ESPT_Infantry || Type == ESPT_InfantryVehicles || Type == ESPT_All;
}

// TODO: this actually means TANKS
simulated function bool CanSpawnVehicles()
{
    return Type == ESPT_Vehicles || Type == ESPT_All;
}

// Special check that allows the option for an infantry spawn point to be set up allow players to spawn into infantry vehicles, as well as on foot
// That means cars, trucks or APCs, but not tanks or any vehicle that requires the player to be tank crew (prevented by checks elsewhere, when this function is called)
// For this to be allowed, the leveller must have included some VehicleLocationHints linked to the infantry spawn
simulated function bool CanSpawnInfantryVehicles()
{
    return Type == ESPT_InfantryVehicles || Type == ESPT_Vehicles || Type == ESPT_All;
}

simulated function bool CanSpawnMortars()
{
    return Type == ESPT_Mortars || Type == ESPT_All;
}

function Reset()
{
    super.Reset();

    bIsLocked = bIsInitiallyLocked;
}

simulated function bool CanSpawnWithParameters(DHGameReplicationInfo GRI, int TeamIndex, int RoleIndex, int SquadIndex, int VehiclePoolIndex)
{
    local class<ROVehicle>  VehicleClass;
    local DHRoleInfo        RI;

    if (!super.CanSpawnWithParameters(GRI, TeamIndex, RoleIndex, SquadIndex, VehiclePoolIndex))
    {
        return false;
    }

    RI = GRI.GetRole(TeamIndex, RoleIndex);
    VehicleClass = class<ROVehicle>(GRI.GetVehiclePoolVehicleClass(VehiclePoolIndex));

    if (RI == none)
    {
        return false;
    }

    if (RI.default.bCanUseMortars && CanSpawnMortars())
    {
        return true;
    }

    if (VehicleClass == none)
    {
        return CanSpawnInfantry() || (RI.default.bCanBeTankCrew && CanSpawnVehicles());
    }
    else
    {
        return CanSpawnInfantryVehicles() || (RI.default.bCanBeTankCrew && CanSpawnVehicle(GRI, VehiclePoolIndex));
    }
}

simulated function bool CanSpawnVehicle(DHGameReplicationInfo GRI, int VehiclePoolIndex)
{
    local class<ROVehicle> VehicleClass;

    VehicleClass = class<ROVehicle>(GRI.GetVehiclePoolVehicleClass(VehiclePoolIndex));

    return VehicleClass != none &&
           TeamIndex == VehicleClass.default.VehicleTeam &&
           (CanSpawnVehicles() || (!VehicleClass.default.bMustBeTankCommander && CanSpawnInfantryVehicles())) &&
           GRI.CanSpawnVehicle(VehiclePoolIndex);
}

function bool PerformSpawn(DHPlayer PC)
{
    local vector SpawnLocation;
    local rotator SpawnRotation;
    local DarkestHourGame G;

    G = DarkestHourGame(Level.Game);

    if (CanSpawnWithParameters(GRI, PC.GetTeamNum(), Pc.GetRoleIndex(), PC.GetSquadIndex(), PC.VehiclePoolIndex) &&
        GetSpawnPosition(SpawnLocation, SpawnRotation, PC.VehiclePoolIndex))
    {
        if (PC.VehiclePoolIndex >= 0)
        {
            return G.SpawnManager.SpawnVehicle(PC, SpawnLocation, SpawnRotation) != none;
        }
        else
        {
            // spawn infantry
            return G.SpawnPawn(PC, SpawnLocation, SpawnRotation, self) != none;
        }
    }

    return false;
}

// TODO: not sure what to do with this
function bool GetSpawnPosition(out vector SpawnLocation, out rotator SpawnRotation, int VehiclePoolIndex)
{
    local Controller    C;
    local Pawn          P;
    local array<vector> EnemyLocations;
    local array<DHLocationHint> LocationHints;
    local array<int>    LocationHintIndices;
    local int           LocationHintIndex, i, j, k;
    local bool          bIsBlocked;
    local class<ROVehicle>  VehicleClass;
    local float         TestCollisionRadius;

    if (VehiclePoolIndex >= 0)
    {
        LocationHints = VehicleLocationHints;
        VehicleClass = class<ROVehicle>(GRI.GetVehiclePoolVehicleClass(VehiclePoolIndex));
        TestCollisionRadius = VehicleClass.default.CollisionRadius;
    }
    else
    {
        LocationHints = InfantryLocationHints;
        TestCollisionRadius = class'DHPawn'.default.CollisionRadius;
    }

    // Scramble location hint indices so we don't use the same ones repeatedly
    LocationHintIndices = class'UArray'.static.Range(0, LocationHints.Length - 1);
    class'UArray'.static.IShuffle(LocationHintIndices);

    // TODO: make this functionality generic so it applied to all spawn point types?

    // Put location hints with enemies nearby at the end of the array to be evaluated last
    if (LocationHintIndices.Length > 1)
    {
        // Get all enemy locations
        for (C = Level.ControllerList; C != none; C = C.NextController)
        {
            if (C.Pawn != none && C.GetTeamNum() != TeamIndex)
            {
                EnemyLocations[EnemyLocations.Length] = C.Pawn.Location;
            }
        }

        for (i = LocationHintIndices.Length - 1; i >= 0; --i)
        {
            for (j = 0; j < EnemyLocations.Length; ++j)
            {
                // Location hint has enemies nearby, so move to end of the array
                if (VSize(EnemyLocations[j] - LocationHints[LocationHintIndices[i]].Location) <= LocationHintDeferDistance)
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

        foreach RadiusActors(class'Pawn', P, TestCollisionRadius, LocationHints[LocationHintIndices[i]].Location)
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
        SpawnLocation = Location;
        SpawnRotation = Rotation;
    }

    return true;
}

defaultproperties
{
    bDirectional=true
    bHidden=true
    bStatic=true
    RemoteRole=ROLE_SimulatedProxy
    DrawScale=1.5
    bCollideWhenPlacing=true
    CollisionRadius=+00040.0
    CollisionHeight=+00043.0
    LocationHintDeferDistance=2048.0
}

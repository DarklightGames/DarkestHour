//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DHSpawnPoint extends Actor
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
var()   bool            bIsInitiallyActive;        // whether or not the SP is active at the start of the round (or waits to be activated later)
var()   name            InfantryLocationHintTag;   // the Tag for associated LocationHint actors used to spawn players on foot
var()   name            VehicleLocationHintTag;    // the Tag for associated LocationHint actors used to spawn players in vehicles
var()   float           SpawnProtectionTime;       // duration in seconds when a spawned player is protected from all damage
var()   name            MineVolumeProtectionTag;   // optional Tag for associated mine volume that protects this SP only when the SP is active
var()   name            NoArtyVolumeProtectionTag; // optional Tag for associated no arty volume that protects this SP only when the SP is active

// Colin: The spawn manager will defer evaluation of any location hints that
// have enemies within this distance. In layman's terms, the spawn manager will
// prefer to spawn players at location hints where there are not enemies nearby.
var()   float                   LocationHintDeferDistance;

// Colin: Locked spawn points will not be affected by enable or disable commands.
var()   bool                    bIsInitiallyLocked;
var     bool                    bIsLocked;

var     int                     TeamIndex;
var     array<DHLocationHint>   InfantryLocationHints;
var     array<DHLocationHint>   VehicleLocationHints;
var     ROMineVolume            MineVolumeProtectionRef;

function PostBeginPlay()
{
    local DHLocationHint LH;
    local RONoArtyVolume NAV;

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

    // Find any associated no arty volume (that will only protect this objective if the objective is active)
    // Note that we don't need to record a reference to the no arty volume actor, we only need to set its AssociatedActor reference to be this spawn point
    if (NoArtyVolumeProtectionTag != '')
    {
        foreach AllActors(class'RONoArtyVolume', NAV, NoArtyVolumeProtectionTag)
        {
            NAV.AssociatedActor = self;
            break;
        }
    }

    super.PostBeginPlay();
}

simulated function bool CanSpawnInfantry()
{
    return Type == ESPT_Infantry || Type == ESPT_InfantryVehicles || Type == ESPT_All;
}

simulated function bool CanSpawnVehicles()
{
    return Type == ESPT_Vehicles || Type == ESPT_All;
}

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

defaultproperties
{
    bDirectional=true
    bHidden=true
    bStatic=true
    RemoteRole=ROLE_None
    DrawScale=1.5
    SpawnProtectionTime=5.0
    bCollideWhenPlacing=true
    CollisionRadius=+00040.0
    CollisionHeight=+00043.0
    LocationHintDeferDistance=2048.0
}

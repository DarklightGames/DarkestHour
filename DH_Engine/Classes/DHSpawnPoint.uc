//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHSpawnPoint extends Actor
    hidecategories(Lighting,LightColor,Karma,Force,Sound)
    abstract;

enum ESpawnPointType
{
    ESPT_Infantry,
    ESPT_Vehicles,
    ESPT_Mortars,
    ESPT_All
};

var() ESpawnPointType Type;
var() bool bIsInitiallyActive;
var() name InfantryLocationHintTag;
var() name VehicleLocationHintTag;
var() float SpawnProtectionTime;

// Colin: The spawn manager will defer evaluation of any location hints that
// have enemies within this distance. In layman's terms, the spawn manager will
// prefer to spawn players at location hints where there are not enemies nearby.
var() float LocationHintDeferDistance;

var int TeamIndex;

var   array<DHLocationHint> InfantryLocationHints;
var   array<DHLocationHint> VehicleLocationHints;

function PostBeginPlay()
{
    local DHLocationHint LH;

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

    super.PostBeginPlay();
}

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

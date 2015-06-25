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
}

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
    ESPT_Both
};

enum ESpawnPointMethod
{
    ESPM_Hints,
    ESPM_Radius
};

var() ESpawnPointType Type;
var() ESpawnPointMethod Method;
var() bool bIsInitiallyActive;
var() name InfantryLocationHintTag;
var() name VehicleLocationHintTag;
var() string SpawnPointName;
var() float SpawnProtectionTime;
var int TeamIndex;

var   array<DHLocationHint> InfantryLocationHints;
var   array<DHLocationHint> VehicleLocationHints;

function PostBeginPlay()
{
    local DHLocationHint LH;

    foreach AllActors(class'DHLocationHint', LH)
    {
        if (LH.Tag == '')
        {
            continue;
        }

        if (LH.Tag == InfantryLocationHintTag)
        {
            InfantryLocationHints[InfantryLocationHints.Length] = LH;
        }
        else if (LH.Tag == VehicleLocationHintTag)
        {
            VehicleLocationHints[VehicleLocationHints.Length] = LH;
        }
    }

    super.PostBeginPlay();
}

simulated function bool CanSpawnInfantry()
{
    return Type == ESPT_Infantry || Type == ESPT_Both;
}

simulated function bool CanSpawnVehicles()
{
    return Type == ESPT_Vehicles || Type == ESPT_Both;
}

defaultproperties
{
    bDirectional=true
    bHidden=true
    bStatic=true
    RemoteRole=ROLE_None
    DrawScale=1.5
    SpawnPointName="UNNAMED SPAWN POINT!!!"
    SpawnProtectionTime=5.0
    Method=ESPM_LocationHint
    bCollideWhenPlacing=true
    CollisionRadius=+00040.0
    CollisionHeight=+00043.0
}

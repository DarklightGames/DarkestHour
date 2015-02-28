//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHSpawnPoint extends Actor
    hidecategories(Lighting,LightColor,Karma,Force,Sound)
    placeable;

enum ESpawnPointType
{
    ESPT_Infantry,
    ESPT_Vehicles
};

enum ESpawnPointMethod
{
    ESPM_Hints,
    ESPM_Radius
};

var() ESpawnPointType Type;
var() ESpawnPointMethod Method;
var() bool bIsInitiallyActive;
var() int TeamIndex;
var() name LocationHintTag;
var() string SpawnPointName;
var() float SpawnProtectionTime;

var   array<DHLocationHint> LocationHints;

function PostBeginPlay()
{
    local DHLocationHint LH;

    foreach AllActors(class'DHLocationHint', LH)
    {
        if (LH.Tag == LocationHintTag)
        {
            LocationHints[LocationHints.Length] = LH;
        }
    }

    super.PostBeginPlay();
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

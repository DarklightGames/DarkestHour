class DHSpawnPoint extends Actor
    hidecategories(Object,Collision,Lighting,LightColor,Karma,Force,Sound)
    placeable;

enum ESpawnPointType
{
    ESPT_Infantry,
    ESPT_Vehicles
};

var() ESpawnPointType Type;
var() bool bIsInitiallyActive;
var() int TeamIndex;
var() name LocationHintTag;
var() string SpawnPointName;

var   array<DHLocationHint> LocationHints;
var   bool bIsActive;

function PostBeginPlay()
{
    local DHLocationHint LH;

    bIsActive = bIsInitiallyActive;

    foreach AllActors(class'DHLocationHint', LH)
    {
        if (LH.Tag == LocationHintTag)
        {
            LocationHints[LocationHints.Length] = LH;
        }
    }

    super.PostBeginPlay();
}

function Reset()
{
    bIsActive = bIsInitiallyActive;

    super.Reset();
}

defaultproperties
{
    bHidden=true
    bStatic=true
    RemoteRole=ROLE_None
    DrawScale=3.0
    SpawnPointName="UNNAMED SPAWN POINT!!!"
}

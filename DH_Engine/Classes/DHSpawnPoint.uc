class DHSpawnPoint extends Actor
    hidecategories(Object,Collision,Lighting,LightColor,Karma,Force,Sound)
    placeable;

struct Position
{
    var vector Location;
    var rotator Rotation;
};

var() bool bIsInitiallyActive;
var() int TeamIndex;
var() name LocationHintTag;

var   array<Position> Positions;
var   bool bIsActive;

function PostBeginPlay()
{
    local DHLocationHint LH;
    local Position P;

    bIsActive = bIsInitiallyActive;

    foreach AllActors(class'DHLocationHint', LH)
    {
        P.Location = LH.Location;
        P.Rotation = LH.Rotation;

        Positions[Positions.Length] = P;

        LH.Destroy();
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
}

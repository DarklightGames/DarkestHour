//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DHConstructionProxy extends Actor;

enum EProvisionalPositionResult
{
    PPR_OK,         // Position was obtained and is valid
    PPR_Fatal,      // Position was not obtained, some fatal error occurred
    PPR_NoGround,   // Position was not obtained, unable to find solid ground to sit on
    PPR_TooSteep,   // Position was not obtained, the ground is too steep
};

var DHPawn                  PawnOwner;
var class<DHConstruction>   ConstructionClass;

var Material                GreenMaterial;
var Material                RedMaterial;

var rotator                 LocalRotation;
var rotator                 LocalRotationRate;

function PostBeginPlay()
{
    super.PostBeginPlay();

    PawnOwner = DHPawn(Owner);

    if (PawnOwner == none)
    {
        Destroy();
    }
}

function SetConstructionClass(class<DHConstruction> ConstructionClass)
{
    local int i;

    self.ConstructionClass = ConstructionClass;

    SetStaticMesh(ConstructionClass.default.StaticMesh);

    // TODO: set all skins to simple color skin.
    Skins.Length = 0;

//    for (i = 0; i < StaticMesh.Skins.Length; ++i)
//    {
//        Skins[i] = default.GreenMaterial;
//    }

    // TODO: detect validity
}

function Tick(float DeltaTime)
{
    local vector L;
    local rotator R;

    super.Tick(DeltaTime);

    if (PawnOwner == none || PawnOwner.Health == 0 || PawnOwner.bDeleteMe || PawnOwner.Controller == none)
    {
        Destroy();
    }

    LocalRotation += (LocalRotationRate * DeltaTime);

    switch (GetProvisionalPosition(L, R))
    {
        case PPR_OK:
            // TODO: make GOOD color
            break;
        default:
            // TODO: make BAD color
            break;
    }

    SetLocation(L);
    SetRotation(R);
}

// This function gets the provisional location and rotation of the construction.
// Returns true if the function was able to determine these provisional values.
function EProvisionalPositionResult GetProvisionalPosition(out vector OutLocation, out rotator OutRotation)
{
    local PlayerController PC;
    local vector TraceStart, TraceEnd, HitLocation, HitNormal, Left, Forward;
    local Actor HitActor;
    local rotator R;
    local EProvisionalPositionResult Result;
    local float GroundSlopeDegrees;

    if (PawnOwner == none)
    {
        return PPR_Fatal;
    }

    PC = PlayerController(PawnOwner.Controller);

    if (PC == none || ConstructionClass == none || Level.NetMode == NM_DedicatedServer)
    {
        return PPR_Fatal;
    }

    // Trace out into the world and try and hit something static.
    TraceStart = PawnOwner.Location + PawnOwner.EyePosition();
    TraceEnd = TraceStart + (vector(PC.CalcViewRotation) * class'DHUnits'.static.MetersToUnreal(ConstructionClass.default.ProxyDistanceInMeters));
    HitActor = Trace(HitLocation, HitNormal, TraceEnd, TraceStart);

    if (HitActor == none)
    {
        // We didn't hit anything, trace down to the ground in hopes of finding
        // something solid to rest on
        TraceStart = TraceEnd;
        TraceEnd = TraceStart + vect(0, 0, -16384); // TODO: get rid of magic number
        HitActor = Trace(HitLocation, HitNormal, TraceEnd, TraceStart);
    }

    if (HitActor != none && HitActor.bStatic && !HitActor.bDeleteMe)
    {
        GroundSlopeDegrees = class'UUnits'.static.RadiansToDegrees(Acos(HitNormal dot vect(0, 0, 1)));

        if (GroundSlopeDegrees >= class'UUnits'.static.DegreesToRadians(ConstructionClass.default.GroundSlopeMaxInDegrees))
        {
            // Too steep!
            Result = PPR_TooSteep;

            // Just point the normal straight up so  it doesn't look wacky
            HitNormal = vect(0, 0, 1);
        }

        // Hit something static in the world. Based the location and rotation
        // off of the hit position.
        if (!ConstructionClass.default.bShouldAlignToGround)
        {
            // Not aligning to ground, just use world up vector as the hit normal
            HitNormal = vect(0, 0, 1);
        }

        Forward = Normal(vector(PC.CalcViewRotation));
        Left = Forward cross HitNormal;
        Forward = HitNormal cross Left;
    }
    else
    {
        Result = PPR_NoGround;
        // TODO: verify correctness
        HitLocation = TraceStart;
        R = PC.CalcViewRotation;
        R.Pitch = 0;
        R.Roll = 0;
        Forward = vector(R);
    }

    OutLocation = HitLocation;
    OutRotation = QuatToRotator(QuatProduct(QuatFromRotator(LocalRotation), QuatFromRotator(rotator(Forward))));

    return Result;
}

function bool IsValidPosition(vector TestLocation, vector TestRotation)
{
    local int i;
    // TODO: test the anchor points

    for (i = 0; i < ConstructionClass.default.Anchors.Length; ++i)
    {
        switch (ConstructionClass.default.Anchors[i].Type)
        {
            case ANCHOR_Above:
                break;
            case ANCHOR_Below:
                break;
            default:
                return false;
        }
    }

    // TODO: how do we deal with things that are RIGHT next to a wall??
    // TODO: should we

    return false;
}

defaultproperties
{
    RemoteRole=ROLE_None
    DrawType=DT_StaticMesh
    bCollideActors=false
    bCollideWhenPlacing=false
    bCollideWorld=false
}


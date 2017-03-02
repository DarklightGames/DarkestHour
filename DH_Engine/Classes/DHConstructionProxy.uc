//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DHConstructionProxy extends Actor;

enum EConstructionProxyError
{
    CPE_None,
    CPE_Fatal,      // Some fatal error occurred, usually a case of unexpected values
    CPE_NoGround,   // No solid ground was able to be found
    CPE_TooSteep,   // The ground slope exceeded the allowable maximum
    CPE_InWater,    // The construction is in water and the construction type disallows this
    CPE_Restricted, // Construction overlaps a restriction volume
};

var EConstructionProxyError ProxyError;

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
    self.ConstructionClass = ConstructionClass;

    if (ConstructionClass == none)
    {
        Error("Cannot set the construction class to none");
    }

    SetStaticMesh(ConstructionClass.default.StaticMesh);

    // Initialize the local rotation based on the parameters in the new construction class
    LocalRotation = class'URotator'.static.RandomRange(ConstructionClass.default.StartRotationMin, ConstructionClass.default.StartRotationMax);
}

function Tick(float DeltaTime)
{
    local vector L;
    local rotator R;
    local Actor A;

    super.Tick(DeltaTime);

    if (PawnOwner == none || PawnOwner.Health == 0 || PawnOwner.bDeleteMe || PawnOwner.Controller == none)
    {
        Destroy();
    }

    LocalRotation += (LocalRotationRate * DeltaTime);

    // TODO: combine getprovisionallocation and getpositionerror into one
    // function able to be run on the client and the server independently
    // An error may be thrown when determining the location, so store it here.
    ProxyError = GetProvisionalPosition(L, R);

    // Set the location
    SetLocation(L);
    SetRotation(R);

    if (ProxyError == CPE_None)
    {
        // Location was determined to be okay, now do another pass.
        ProxyError = GetPositionError();
    }

    switch (ProxyError)
    {
        case CPE_None:
            Style = STY_Normal;
            // TODO: make GOOD color
            break;
        default:
            (new class'UStaticMesh').MakeActorTranslucent(self);
            break;
    }
}

// This function gets the provisional location and rotation of the construction.
// Returns true if the function was able to determine these provisional values.
function EConstructionProxyError GetProvisionalPosition(out vector OutLocation, out rotator OutRotation)
{
    local PlayerController PC;
    local vector TraceStart, TraceEnd, HitLocation, HitNormal, Left, Forward;
    local Actor HitActor;
    local rotator R;
    local float GroundSlopeDegrees;
    local EConstructionProxyError Error;

    if (PawnOwner == none)
    {
        return CPE_Fatal;
    }

    PC = PlayerController(PawnOwner.Controller);

    if (PC == none || ConstructionClass == none)
    {
        return CPE_Fatal;
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
        // Hit something static in the world.
        GroundSlopeDegrees = class'UUnits'.static.RadiansToDegrees(Acos(HitNormal dot vect(0, 0, 1)));

        // TODO:

        if (GroundSlopeDegrees >= ConstructionClass.default.GroundSlopeMaxInDegrees)
        {
            // Too steep!
            Error = CPE_TooSteep;

            // Just point the normal straight up so  it doesn't look wacky
            HitNormal = vect(0, 0, 1);
        }

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
        // Didn't hit anything!
        Error = CPE_NoGround;
        // TODO: verify correctness
        HitLocation = TraceEnd;
        R = PC.CalcViewRotation;
        R.Pitch = 0;
        R.Roll = 0;
        Forward = vector(R);
    }

    OutLocation = HitLocation;
    OutRotation = QuatToRotator(QuatProduct(QuatFromRotator(LocalRotation), QuatFromRotator(rotator(Forward))));

    return Error;
}

// We separate this function from GetProvisionalPosition because we need to have
// the server do it's own check before attempting to spawn the construction.
function EConstructionProxyError GetPositionError()
{
    local int i;
    local DHRestrictionVolume RV;

    // TODO: refactor this out to another function
    if (!ConstructionClass.default.bCanPlaceInWater && PhysicsVolume != none && PhysicsVolume.bWaterVolume)
    {
        return CPE_InWater;
    }

    foreach TouchingActors(class'DHRestrictionVolume', RV)
    {
        if (RV != none && RV.bNoConstructions)
        {
            return CPE_Restricted;
        }
    }

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
                break;
        }
    }

    // TODO: how do we deal with things that are RIGHT next to a wall??
    // TODO: should we

    return CPE_None;
}

defaultproperties
{
    RemoteRole=ROLE_None
    DrawType=DT_StaticMesh
    bCollideActors=true
    bCollideWorld=false
    bBlockActors=true
    bBlockPlayers=false
}


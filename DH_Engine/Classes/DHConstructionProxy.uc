//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DHConstructionProxy extends Actor
    dependson(DHConstruction);

var DHConstruction.EConstructionError   ProxyError;

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
        Warn("Cannot set the construction class to none");
        return;
    }

    SetCollisionSize(ConstructionClass.default.CollisionHeight, ConstructionClass.default.CollisionRadius);
    SetStaticMesh(ConstructionClass.default.StaticMesh);

    // Initialize the local rotation based on the parameters in the new construction class
    LocalRotation = class'URotator'.static.RandomRange(ConstructionClass.default.StartRotationMin, ConstructionClass.default.StartRotationMax);

    // TODO: create "OK" textures
    CreateMaterials();

}

function CreateMaterials()
{
    local int i;
    local array<Material> StaticMeshSkins;
    local Combiner C;
    local FadeColor FC;
    local FinalBlend FB;

    StaticMeshSkins = (new class'UStaticMesh').FindStaticMeshSkins(StaticMesh);

    for (i = 0; i < StaticMeshSkins.Length; ++i)
    {
        FC = new class'FadeColor';
        FC.Color1 = class'UColor'.default.White;
        FC.Color1.A = 128;
        FC.Color2 = class'UColor'.default.White;
        FC.Color2.A = 255;
        FC.FadePeriod = 0.25;
        FC.ColorFadeType = FC_Sinusoidal;

        C = new class'Combiner';
        C.CombineOperation = CO_Multiply;
        C.AlphaOperation = AO_Multiply;
        C.Material1 = StaticMeshSkins[i];
        C.Material2 = FC;
        C.Modulate4X = true;

        FB = new class'FinalBlend';
        FB.FrameBufferBlending = FB_AlphaBlend;
        FB.ZWrite = true;
        FB.ZTest = true;
        FB.AlphaTest = true;
        FB.TwoSided = true;
        FB.Material = C;

        Skins[i] = FB;
    }
}

function SetStaticMeshColor(color Color)
{
    local FinalBlend FB;
    local Combiner C;
    local FadeColor FC;
    local int i;

    for (i = 0; i < Skins.Length; ++i)
    {
        FB = FinalBlend(Skins[i]);

        if (FB != none)
        {
            C = Combiner(FB.Material);

            if (C != none)
            {
                FC = FadeColor(C.Material2);

                if (FC != none)
                {
                    FC.Color1 = Color;
                    FC.Color1.A = 128;

                    FC.Color2 = Color;
                    FC.Color2.A = 255;
                }
            }
        }
    }
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

    // TODO: combine getprovisionallocation and getpositionerror into one
    // function able to be run on the client and the server independently
    // An error may be thrown when determining the location, so store it here.
    ProxyError = GetProvisionalPosition(L, R);

    // Set the location
    SetLocation(L);
    SetRotation(R);

    if (ProxyError == ERROR_None)
    {
        // Location was determined to be okay, now do another pass.
        ProxyError = GetPositionError();
    }

    switch (ProxyError)
    {
        case ERROR_None:
            SetStaticMeshColor(class'UColor'.default.Green);
            break;
        default:
            SetStaticMeshColor(class'UColor'.default.Red);
            break;
    }
}

// This function gets the provisional location and rotation of the construction.
function DHConstruction.EConstructionError GetProvisionalPosition(out vector OutLocation, out rotator OutRotation)
{
    local PlayerController PC;
    local vector TraceStart, TraceEnd, HitLocation, HitNormal, Left, Forward, X, Y, Z, HitNormalSum, BaseLocation;
    local Actor TempHitActor, HitActor;
    local rotator R;
    local float GroundSlopeDegrees, AngleRadians;
    local DHConstruction.EConstructionError Error;
    local int i;

    if (PawnOwner == none)
    {
        return ERROR_Fatal;
    }

    PC = PlayerController(PawnOwner.Controller);

    if (PC == none || ConstructionClass == none)
    {
        return ERROR_Fatal;
    }

    // Trace out into the world and try and hit something static.
    TraceStart = PawnOwner.Location + PawnOwner.EyePosition();
    TraceEnd = TraceStart + (vector(PC.CalcViewRotation) * class'DHUnits'.static.MetersToUnreal(ConstructionClass.default.ProxyDistanceInMeters));

    foreach TraceActors(class'Actor', TempHitActor, HitLocation, HitNormal, TraceEnd, TraceStart)
    {
        if (TempHitActor.bStatic && !TempHitActor.IsA('ROBulletWhipAttachment') && !TempHitActor.IsA('Volume'))
        {
            HitActor = TempHitActor;
            break;
        }
    }

    if (HitActor == none)
    {
        // We didn't hit anything, trace down to the ground in hopes of finding
        // something solid to rest on
        TraceStart = TraceEnd;
        TraceEnd = TraceStart + vect(0, 0, -16384); // TODO: get rid of magic number

        foreach TraceActors(class'Actor', TempHitActor, HitLocation, HitNormal, TraceEnd, TraceStart)
        {
            if (TempHitActor.bStatic && !TempHitActor.IsA('ROBulletWhipAttachment') && !TempHitActor.IsA('Volume'))
            {
                HitActor = TempHitActor;
                break;
            }
        }
    }

    if (HitActor == none)
    {
        // Didn't hit anything!
        Error = ERROR_NoGround;
        // TODO: verify correctness
        BaseLocation = TraceStart;
        R = PC.CalcViewRotation;
        R.Pitch = 0;
        R.Roll = 0;
        Forward = vector(R);
    }
    else
    {
        BaseLocation = HitLocation;

        if (ConstructionClass.default.bCanOnlyPlaceOnTerrain && !HitActor.IsA('TerrainInfo'))
        {
            Error = ERROR_NotOnTerrain;
        }

        if (!ConstructionClass.default.bShouldAlignToGround)
        {
            // Not aligning to ground, just use world up vector as the hit normal.
            HitNormal = vect(0, 0, 1);
        }

        Forward = Normal(vector(PC.CalcViewRotation));
        Left = Forward cross HitNormal;
        Forward = HitNormal cross Left;

        // Hit something static in the world.
        GroundSlopeDegrees = class'UUnits'.static.RadiansToDegrees(Acos(HitNormal dot vect(0, 0, 1)));

        if (Error == ERROR_None && GroundSlopeDegrees >= ConstructionClass.default.GroundSlopeMaxInDegrees)
        {
            // Too steep!
            Error = ERROR_TooSteep;
        }

        if (Error == ERROR_None)
        {
            // TODO: test the anchor points
            // TODO: enable or disable this check
            GetAxes(rotator(Forward), X, Y, Z);

            const TRACE_RESOLUTION = 8;

            for (i = 0; i < TRACE_RESOLUTION; ++i)
            {
                AngleRadians = (float(i) / TRACE_RESOLUTION) * Pi;

                TraceStart = vect(0, 0, 0);
                TraceStart.Z = CollisionHeight;
                TraceEnd = TraceStart;
                TraceEnd.X = Sin(AngleRadians) * CollisionRadius;
                TraceEnd.Y = Cos(AngleRadians) * CollisionRadius;
                TraceStart.X = -TraceEnd.X;
                TraceStart.Y = -TraceEnd.Y;

                TraceStart = BaseLocation + QuatRotateVector(QuatFromRotator(rotator(X)), TraceStart);
                TraceEnd = BaseLocation + QuatRotateVector(QuatFromRotator(rotator(X)), TraceEnd);

                // Trace across the diameter of the collision cylinder
                HitActor = Trace(HitLocation, HitNormal, TraceEnd, TraceStart, true);

                if (HitActor != none && !HitActor.IsA('ROBulletWhipAttachment') && !HitActor.IsA('Volume'))
                {
                    Error = ERROR_NoRoom;
                    break;
                }

                // Trace down from the top of the cylinder to the bottom
                TraceEnd = TraceStart - (Z * (CollisionHeight + class'DHUnits'.static.MetersToUnreal(ConstructionClass.default.FloatToleranceInMeters)));

                HitActor = Trace(HitLocation, HitNormal, TraceEnd, TraceStart, false);

                if (HitActor == none)
                {
                    Error = ERROR_NoGround;
                    break;
                }
                else
                {
                    HitNormalSum += HitNormal;
                }
            }
        }

        if (Error == ERROR_None)
        {
            HitNormalSum.X /= TRACE_RESOLUTION;
            HitNormalSum.Y /= TRACE_RESOLUTION;
            HitNormalSum.Z /= TRACE_RESOLUTION;
        }
        else
        {
            HitNormalSum = vect(0, 0, 1);
        }

        Forward = Normal(vector(PC.CalcViewRotation));
        Left = Forward cross HitNormalSum;
        Forward = HitNormalSum cross Left;
    }

    OutLocation = BaseLocation;
    OutRotation = QuatToRotator(QuatProduct(QuatFromRotator(LocalRotation), QuatFromRotator(rotator(Forward))));

    return Error;
}

// We separate this function from GetProvisionalPosition because we need to have
// the server do it's own check before attempting to spawn the construction.
function DHConstruction.EConstructionError GetPositionError()
{
    local DHRestrictionVolume RV;
    local Actor A;
    local DHConstruction C;
    local Actor TouchingActor;

    if (!ConstructionClass.default.bCanPlaceInWater && PhysicsVolume != none && PhysicsVolume.bWaterVolume)
    {
        return ERROR_InWater;
    }

    foreach TouchingActors(class'DHRestrictionVolume', RV)
    {
        if (RV != none && RV.bNoConstructions)
        {
            return ERROR_Restricted;
        }
    }

    foreach TouchingActors(class'Actor', TouchingActor)
    {
        if (TouchingActor != none && TouchingActor.bBlockActors)
        {
            return ERROR_NoRoom;
        }
    }

    if (ConstructionClass.default.DuplicateDistanceInMeters > 0.0)
    {
        foreach RadiusActors(ConstructionClass, A, class'DHUnits'.static.MetersToUnreal(ConstructionClass.default.DuplicateDistanceInMeters))
        {
            C = DHConstruction(A);

            if (C != none && C.GetTeamIndex() == PawnOwner.GetTeamNum())
            {
                return ERROR_TooClose;
            }
        }
    }

    return ERROR_None;
}

defaultproperties
{
    RemoteRole=ROLE_None
    DrawType=DT_StaticMesh
    bCollideActors=true
    bCollideWorld=false
    bBlockActors=true
}


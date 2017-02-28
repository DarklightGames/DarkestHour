//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DHConstructionProxy extends Actor;

var DHPawn                  Pawn;
var class<DHConstruction>   ConstructionClass;

var Material                GreenMaterial;
var Material                RedMaterial;

var rotator                 LocalRotation;

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

// This function gets the provisional location and rotation of the construction.
// Returns true if the function was able to determine these provisional values.
function bool GetProvisionalPosition(DHPlayer PC, out vector OutLocation, out rotator OutRotation)
{
    local vector TraceStart, TraceEnd, HitLocation, HitNormal, Left, Forward;
    local Actor HitActor;
    local rotator R;

    if (PC == none || ConstructionClass == none || Level.NetMode == NM_DedicatedServer)
    {
        return false;
    }

    // Trace out into the world and try and hit something static.
    TraceStart = PC.CalcViewLocation;
    TraceEnd = TraceStart + (vector(PC.CalcViewRotation) * ConstructionClass.default.ProxyDistanceInMeters);
    HitActor = Trace(HitLocation, HitNormal, TraceEnd, TraceStart, false);

    if (HitActor != none && HitActor.bStatic && !HitActor.bDeleteMe)
    {
        // Hit something static in the world. Based the location and rotation
        // off of the hit position.
        if (!ConstructionClass.default.bShouldAlignToGround)
        {
            // Not aligning to ground, just use world up vector as the hit normal
            HitNormal = vect(0, 0, 1);
        }

        // TODO: verify correctness
        Forward = Normal(vector(PC.CalcViewRotation));
        Left = Forward cross HitNormal;
        Forward = Left cross HitNormal;
    }
    else
    {
        // TODO: verify correctness
        HitLocation = TraceEnd;
        R = PC.CalcViewRotation;
        R.Pitch = 0;
        R.Roll = 0;
        Forward = vector(R);
    }

    OutLocation = HitLocation;
    OutRotation = QuatToRotator(QuatProduct(QuatFromRotator(LocalRotation), QuatFromRotator(rotator(Forward))));

    return true;
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
    bCollideActors=false
    bCollideWhenPlacing=false
    bCollideWorld=false
}


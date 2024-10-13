//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================
// Plane flyby actor, sends a plane flying when triggered.
//==============================================================================

class DHPlaneFlyby extends Actor
    placeable;

var() StaticMesh    PlaneStaticMesh;
var() Rotator       PlaneRelativeRotation;
var() Sound         PlaneDistantSound;  // Sound to play when the plane is far away.
var() Sound         PlaneCloseSound;    // Sound to play when the plane is close.

var() float         PlaneDistantSoundRadius;
var() float         PlaneCloseSoundRadius;
var() float         PlaneDistantSoundVolume;
var() float         PlaneCloseSoundVolume;

var() name          PlaneBoneName;      // Bone to attach the plane to.
var() name          PlaneFlybyAnimation;
var() float         PlaneFlybyAnimationRate;

var DHDecoAttachment  PlaneAttachment;
var ROSoundAttachment PlaneDistantSoundAttachment;
var ROSoundAttachment PlaneCloseSoundAttachment;

function ROSoundAttachment SpawnSoundAttachment(Sound S, float Volume, float Radius)
{
    local ROSoundAttachment SA;

    SA = Spawn(class'ROSoundAttachment');
    SA.SoundRadius = Radius;
    SA.SoundVolume = Volume;
    SA.AmbientSound = S;

    AttachToBone(SA, PlaneBoneName);

    return SA;
}

function SpawnAttachments()
{
    if (PlaneAttachment != none)
    {
        PlaneAttachment.Destroy();
    }

    PlaneAttachment = Spawn(class'DHDecoAttachment');
    PlaneAttachment.SetStaticMesh(PlaneStaticMesh);
    AttachToBone(PlaneAttachment, PlaneBoneName);
    PlaneAttachment.SetRelativeRotation(PlaneRelativeRotation);

    if (PlaneDistantSoundAttachment != none)
    {
        PlaneDistantSoundAttachment.Destroy();
    }

    PlaneDistantSoundAttachment = SpawnSoundAttachment(PlaneDistantSound, PlaneDistantSoundVolume, PlaneDistantSoundRadius);

    if (PlaneCloseSoundAttachment != none)
    {
        PlaneCloseSoundAttachment.Destroy();
    }

    PlaneCloseSoundAttachment = SpawnSoundAttachment(PlaneCloseSound, PlaneCloseSoundVolume, PlaneCloseSoundRadius);
}

event Trigger(Actor Other, Pawn EventInstigator)
{
    super.Trigger(Other, EventInstigator);

    SpawnAttachments();

    PlayAnim(PlaneFlybyAnimation, PlaneFlybyAnimationRate);
}

defaultproperties
{
    DrawType=DT_Mesh
    CullDistance=0.0
    Mesh=SkeletalMesh'DH_Planes_anm.plane_flyby'
    PlaneFlybyAnimation="plane_flyby_1"
    PlaneFlybyAnimationRate=1.0
    PlaneDistantSoundVolume=1.0
    PlaneCloseSoundVolume=1.0
    PlaneDistantSoundRadius=10000.0
    PlaneCloseSoundRadius=5000.0
}

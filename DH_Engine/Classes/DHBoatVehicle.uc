//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHBoatVehicle extends DHWheeledVehicle
    abstract;

var     sound               WashSound;
var     name                WashSoundBoneL;
var     ROSoundAttachment   WashSoundAttachL;
var     name                WashSoundBoneR;
var     ROSoundAttachment   WashSoundAttachR;

var     name                DestroyedAnimName;
var     float               DestroyedAnimRate;

// Modified to spawn wash sound attachments
simulated function PostBeginPlay()
{
    super.PostBeginPlay();

    if (Level.NetMode != NM_DedicatedServer)
    {
        if (WashSoundAttachL == none)
        {
            WashSoundAttachL = Spawn(class'ROSoundAttachment');
            WashSoundAttachL.AmbientSound = WashSound;
            WashSoundAttachL.SoundVolume = 75;
            WashSoundAttachL.SoundRadius = 300.0;
            AttachToBone(WashSoundAttachL, WashSoundBoneL);
        }

        if (WashSoundAttachR == none)
        {
            WashSoundAttachR = Spawn(class'ROSoundAttachment');
            WashSoundAttachR.AmbientSound = WashSound;
            WashSoundAttachR.SoundVolume = 75;
            WashSoundAttachR.SoundRadius = 300.0;
            AttachToBone(WashSoundAttachR, WashSoundBoneR);
        }
    }
}

// Modified to avoid switching to static mesh DestroyedVehicleMesh, instead just re-skinning normal mesh with DestroyedMeshSkins & playing a destroyed animation
simulated event DestroyAppearance()
{
    local int i;

    bDestroyAppearance = true; // replicated, natively triggering this function on net clients
    NetPriority = 2.0;
    Disable('Tick');

    // Zero the driving controls (vehicle will come to a stop naturally)
    Throttle = 0.0;
    Steering = 0.0;
    Rise     = 0.0;

    // Destroy the vehicle weapons
    if (Role == ROLE_Authority)
    {
        for (i = 0; i < WeaponPawns.Length; ++i)
        {
            if (WeaponPawns[i] != none)
            {
                WeaponPawns[i].Destroy();
            }
        }
    }

    WeaponPawns.Length = 0;

    // Destroy the effects
    if (DamagedEffect != none)
    {
        DamagedEffect.Kill();
    }

    DestroyAttachments();

    // Switch to destroyed vehicle texture
    if (Level.NetMode != NM_DedicatedServer && DestroyedMeshSkins.Length > 0)
    {
        for (i = 0; i < DestroyedMeshSkins.Length; ++i)
        {
            if (DestroyedMeshSkins[i] != none)
            {
                Skins[i] = DestroyedMeshSkins[i];
            }
        }
    }

    // Loop any destroyed vehicle animation
    if (DestroyedAnimName != '')
    {
        LoopAnim(DestroyedAnimName, DestroyedAnimRate);
    }
}

// Modified to include wash sound attachments
simulated function DestroyAttachments()
{
    if (WashSoundAttachL != none)
    {
        WashSoundAttachL.Destroy();
    }

    if (WashSoundAttachR != none)
    {
        WashSoundAttachR.Destroy();
    }

    super.DestroyAttachments();
}

defaultproperties
{
    EngineHealth=100 // reinstate default from ROWheeledVehicle
    ChangeUpPoint=1990.0
    ChangeDownPoint=1000.0
    SteerBoneName="steeringwheel"
    DustSlipRate=0.0
    DustSlipThresh=100000.0
    ViewShakeRadius=600.0
    ViewShakeOffsetMag=(X=0.5,Z=2.0)
    ViewShakeOffsetFreq=7.0
    DestroyedAnimRate=1.0
    DestructionEffectClass=class'ROEffects.ROVehicleDestroyedEmitter' // reinstate defaults x 3 from ROWheeledVehicle
    DisintegrationEffectClass=class'ROEffects.ROVehicleObliteratedEmitter'
    DisintegrationEffectLowClass=class'ROEffects.ROVehicleObliteratedEmitter_simple'
    DisintegrationHealth=-10000.0
    DestructionLinearMomentum=(Min=100.0,Max=350.0)
    DestructionAngularMomentum=(Max=150.0)
    ExplosionSoundRadius=800.0
    ExplosionDamage=300.0
    ExplosionRadius=600.0
    ImpactDamageThreshold=5000.0 // reinstate default from ROWheeledVehicle
    ImpactDamageMult=0.001
    DriverTraceDistSquared=4000000.0 // default 2000 from ROWheeledVehicle, but squared for new DistSquared variable
    InitialPositionIndex=0
    VehicleMass=12.0
    bKeyVehicle=true
    bFPNoZFromCameraPitch=true
    CenterSpringForce="SpringONSSRV"
    MaxDesireability=0.1
    WaterDamage=0.0
    bCanSwim=true
    GroundSpeed=200.0
    WaterSpeed=200.0
    PitchUpLimit=500
    PitchDownLimit=58000
    bKeepDriverAuxCollision=false // reinstate default from ROWheeledVehicle
    CollisionRadius=300.0
    CollisionHeight=45.0
}

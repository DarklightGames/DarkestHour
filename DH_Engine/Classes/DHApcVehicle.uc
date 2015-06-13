//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHApcVehicle extends DHWheeledVehicle
    abstract;

var     float               MaxCriticalSpeed; // if vehicle goes over max speed, it forces player to pull back on throttle

// Treads
var     int                 LeftTreadIndex, RightTreadIndex;
var     VariableTexPanner   LeftTreadPanner, RightTreadPanner;
var     float               TreadVelocityScale;
var     rotator             LeftTreadPanDirection, RightTreadPanDirection;
var     sound               LeftTreadSound, RightTreadSound;
var     ROSoundAttachment   LeftTreadSoundAttach, RightTreadSoundAttach;
var     name                LeftTrackSoundBone, RightTrackSoundBone;

// Wheel animation
var     array<name>         LeftWheelBones, RightWheelBones; // for animation only - the bone names for the wheels on each side
var     rotator             LeftWheelRot, RightWheelRot;     // keep track of the wheel rotational speed for animation
var     int                 WheelRotationScale;              // allows adjustment of wheel rotation speed for each vehicle

// Modified to add treads (from ROTreadCraft)
simulated function PostBeginPlay()
{
    super.PostBeginPlay();

    if (Level.NetMode != NM_DedicatedServer)
    {
        SetupTreads();
    }
}

// Modified to add features from DHArmoredVehicle for treads
simulated function Tick(float DeltaTime)
{
    local KRigidBodyState BodyState;
    local float           MySpeed, LinTurnSpeed;
    local int             i;

    super.Tick(DeltaTime);

    // Only need these effects client side
    if (Level.NetMode != NM_DedicatedServer)
    {
        MySpeed = Abs(ForwardVel);

        // Set tread & wheel movement rates
        KGetRigidBodyState(BodyState);
        LinTurnSpeed = 0.5 * BodyState.AngVel.Z;

        if (LeftTreadPanner != none)
        {
            LeftTreadPanner.PanRate = MySpeed / TreadVelocityScale;

            if (Velocity dot vector(Rotation) < 0.0)
            {
                LeftTreadPanner.PanRate = -1.0 * LeftTreadPanner.PanRate;
            }

            LeftTreadPanner.PanRate += LinTurnSpeed;
            LeftWheelRot.Pitch += LeftTreadPanner.PanRate * WheelRotationScale;
        }

        if (RightTreadPanner != none)
        {
            RightTreadPanner.PanRate = MySpeed / TreadVelocityScale;

            if (Velocity dot vector(Rotation) < 0.0)
            {
                RightTreadPanner.PanRate = -1.0 * RightTreadPanner.PanRate;
            }

            RightTreadPanner.PanRate -= LinTurnSpeed;
            RightWheelRot.Pitch += RightTreadPanner.PanRate * WheelRotationScale;
        }

        // Animate the tank wheels
        for (i = 0; i < LeftWheelBones.Length; ++i)
        {
            SetBoneRotation(LeftWheelBones[i], LeftWheelRot);
        }

        for (i = 0; i < RightWheelBones.Length; ++i)
        {
            SetBoneRotation(RightWheelBones[i], RightWheelRot);
        }

        // Force player to pull back on throttle if over max speed
        if (MySpeed >= MaxCriticalSpeed && ROPlayer(Controller) != none)
        {
            ROPlayer(Controller).aForward = -32768.0;
        }
    }
}

// Modified to stop tread movement if player has exited
simulated event DrivingStatusChanged()
{
    super.DrivingStatusChanged();

    if (Level.NetMode != NM_DedicatedServer && !bDriving)
    {
        if (LeftTreadPanner != none)
        {
            LeftTreadPanner.PanRate = 0.0;
        }

        if (RightTreadPanner != none)
        {
            RightTreadPanner.PanRate = 0.0;
        }
    }
}

// Modified to add chance of engine being destroyed & engine fire starting
function TakeDamage(int Damage, Pawn InstigatedBy, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional int HitIndex)
{
    super.TakeDamage(Damage, InstigatedBy, HitLocation, Momentum, DamageType, HitIndex);

    // If vehicle health is very low, kill the engine (which will start a fire)
    if (Health <= HealthMax / 3 && Health >= 0)
    {
        EngineHealth = 0;
        bEngineOff = true;
        SetEngine();
    }
}

// From DHArmoredVehicle & ROTreadCraft (combines SetupTreads & some PostBeginPlay)
simulated function SetupTreads()
{
    LeftTreadPanner = VariableTexPanner(Level.ObjectPool.AllocateObject(class'VariableTexPanner'));

    if (LeftTreadPanner != none)
    {
        LeftTreadPanner.Material = Skins[LeftTreadIndex];
        LeftTreadPanner.PanDirection = LeftTreadPanDirection;
        LeftTreadPanner.PanRate = 0.0;
        Skins[LeftTreadIndex] = LeftTreadPanner;
    }

    RightTreadPanner = VariableTexPanner(Level.ObjectPool.AllocateObject(class'VariableTexPanner'));

    if (RightTreadPanner != none)
    {
        RightTreadPanner.Material = Skins[RightTreadIndex];
        RightTreadPanner.PanDirection = RightTreadPanDirection;
        RightTreadPanner.PanRate = 0.0;
        Skins[RightTreadIndex] = RightTreadPanner;
    }

    if (LeftTreadSound != none && LeftTrackSoundBone != '' && LeftTreadSoundAttach == none)
    {
        LeftTreadSoundAttach = Spawn(class'ROSoundAttachment');
        LeftTreadSoundAttach.AmbientSound = LeftTreadSound;
        AttachToBone(LeftTreadSoundAttach, LeftTrackSoundBone);
    }

    if (RightTreadSound != none && RightTrackSoundBone != '' && RightTreadSoundAttach == none)
    {
        RightTreadSoundAttach = Spawn(class'ROSoundAttachment');
        RightTreadSoundAttach.AmbientSound = RightTreadSound;
        AttachToBone(RightTreadSoundAttach, RightTrackSoundBone);
    }
}

// Modified to add tread sounds (from ROTreadCraft)
simulated function UpdateMovementSound(float MotionSoundVolume)
{
    super.UpdateMovementSound(MotionSoundVolume);

    if (LeftTreadSoundAttach != none)
    {
       LeftTreadSoundAttach.SoundVolume = MotionSoundVolume;
    }

    if (RightTreadSoundAttach != none)
    {
       RightTreadSoundAttach.SoundVolume = MotionSoundVolume;
    }
}

// Modified to destroy treads
simulated function DestroyAttachments()
{
    super.DestroyAttachments();

    if (Level.NetMode != NM_DedicatedServer)
    {
        if (LeftTreadPanner != none)
        {
            Level.ObjectPool.FreeObject(LeftTreadPanner);
            LeftTreadPanner = none;
        }

        if (RightTreadPanner != none)
        {
            Level.ObjectPool.FreeObject(RightTreadPanner);
            RightTreadPanner = none;
        }

        if (LeftTreadSoundAttach != none)
        {
            LeftTreadSoundAttach.Destroy();
        }

        if (RightTreadSoundAttach != none)
        {
            RightTreadSoundAttach.Destroy();
        }
    }
}

// Modified to disable if vehicle takes major damage, as well as if engine is dead
// This should give time for troops to bail out & escape before vehicle blows
simulated function bool IsDisabled()
{
    return (EngineHealth <= 0 || (Health >= 0 && Health <= HealthMax / 3));
}

defaultproperties
{
    bIsApc=true
    PointValue=2.0
    MinVehicleDamageModifier=0.25 // needs APCDamageModifier of at least 0.25 to damage this type of vehicle
    bKeepDriverAuxCollision=false
    LeftTreadIndex=1
    RightTreadIndex=2
    LeftTreadPanDirection=(Pitch=0,Yaw=0,Roll=16384)
    RightTreadPanDirection=(Pitch=0,Yaw=0,Roll=16384)
    MaxCriticalSpeed=800.0
    WheelRotationScale=500
    DestructionEffectClass=class'ROEffects.ROVehicleDestroyedEmitter'
    VehicleSpikeTime=60.0
}

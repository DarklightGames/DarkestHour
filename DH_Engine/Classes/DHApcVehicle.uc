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

// Optional collision static mesh for driver's armoured visor
var    DHCollisionMeshActor VisorColMeshActor;
var    StaticMesh           VisorColStaticMesh;
var    name                 VisorColAttachBone;

// Modified to add treads (from ROTreadCraft)
// Also to add optional collision static mesh actor to represent a driver's armoured visor, which will raise or lower with driver view changes
simulated function PostBeginPlay()
{
    super.PostBeginPlay();

    // If an already destroyed vehicle gets replicated, there's nothing more we want to do here; it will only spawn pointless stuff
    if (Health <= 0)
    {
        return;
    }

    if (Level.NetMode != NM_DedicatedServer)
    {
        SetupTreads();
    }

    if (VisorColStaticMesh != none)
    {
        VisorColMeshActor = Spawn(class'DHCollisionMeshActor', self); // vital that this vehicle owns the col mesh actor

        if (VisorColMeshActor != none)
        {
            VisorColMeshActor.bHardAttach = true;
            AttachToBone(VisorColMeshActor, VisorColAttachBone);
            VisorColMeshActor.SetRelativeRotation(Rotation - GetBoneRotation(VisorColAttachBone)); // because a visor bone may be modelled with rotation in the reference pose
            VisorColMeshActor.SetRelativeLocation((Location - GetBoneCoords(VisorColAttachBone).Origin) << (Rotation - VisorColMeshActor.RelativeRotation));
            VisorColMeshActor.SetStaticMesh(VisorColStaticMesh);
        }
    }
}

// Modified to add features from DHArmoredVehicle for treads
simulated function Tick(float DeltaTime)
{
    local KRigidBodyState BodyState;
    local float           MySpeed, MotionSoundVolume, LinTurnSpeed;
    local int             i;

    super(ROWheeledVehicle).Tick(DeltaTime);

    if (Level.NetMode != NM_DedicatedServer)
    {
        MySpeed = Abs(ForwardVel); // don't need VSize(Velocity), as already have ForwardVel

        // If vehicle is moving, update sounds, treads & wheels, based on speed
        if (MySpeed > 0.1)
        {
            // Update engine, interior rumble & tread sounds
            MotionSoundVolume = FClamp(MySpeed / MaxPitchSpeed * 255.0, 0.0, 255.0);
            UpdateMovementSound(MotionSoundVolume);

            // Update tread & wheel movement rates
            KGetRigidBodyState(BodyState);
            LinTurnSpeed = 0.5 * BodyState.AngVel.Z;

            if (LeftTreadPanner != none)
            {
                LeftTreadPanner.PanRate = (ForwardVel / TreadVelocityScale) + LinTurnSpeed;
                LeftWheelRot.Pitch += LeftTreadPanner.PanRate * WheelRotationScale;
            }

            if (RightTreadPanner != none)
            {
                RightTreadPanner.PanRate = (ForwardVel / TreadVelocityScale) - LinTurnSpeed;
                RightWheelRot.Pitch += RightTreadPanner.PanRate * WheelRotationScale;
            }

            // Animate the wheels
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
        // If vehicle isn't moving, zero the movement sounds & tread movement
        else
        {
            UpdateMovementSound(0.0);
            LeftTreadPanner.PanRate = 0.0;
            RightTreadPanner.PanRate = 0.0;
        }
    }

    // Stop all movement if engine off
    if (bEngineOff)
    {
        Velocity = vect(0.0, 0.0, 0.0);
        Throttle = 0.0;
        ThrottleAmount = 0.0;
        Steering = 0.0;
        ForwardVel = 0.0;
    }
    // If we crushed an object, apply brake & clamp throttle (server only)
    else if (bCrushedAnObject)
    {
        // If our crush stall time is over, we are no longer crushing
        if (Level.TimeSeconds > (LastCrushedTime + ObjectCrushStallTime))
        {
            bCrushedAnObject = false;
        }
        else
        {
            Throttle = FClamp(Throttle, -0.1, 0.1);

            if (ROPlayer(Controller) != none)
            {
                ROPlayer(Controller).bPressedJump = true;
            }
        }
    }
    // Very heavy damage to engine limits speed
    else if (EngineHealth <= (default.EngineHealth * 0.25) && EngineHealth > 0)
    {
        Throttle = FClamp(Throttle, -0.5, 0.5);
    }

    // Disable Tick if vehicle isn't moving & has no driver
    if (!bDriving && ForwardVel ~= 0.0)
    {
        MinBrakeFriction = LowSpeedBrakeFriction;
        Disable('Tick');
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
    if (Health <= (HealthMax / 3) && Health > 0)
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

// Modified to destroy treads & visor collision mesh
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

    if (VisorColMeshActor != none)
    {
        VisorColMeshActor.Destroy();
    }
}

// Modified to disable if vehicle takes major damage, as well as if engine is dead
// This should give time for troops to bail out & escape before vehicle blows
simulated function bool IsDisabled()
{
    return (EngineHealth <= 0 || (Health >= 0 && Health <= HealthMax / 3));
}

// New debugging exec function to toggle showing the optional collision mesh representing a driver's armoured visor
exec function ShowColMesh()
{
    if ((Level.NetMode == NM_Standalone || class'DH_LevelInfo'.static.DHDebugMode()) && VisorColMeshActor != none)
    {
        VisorColMeshActor.bHidden = !VisorColMeshActor.bHidden;
    }
}

defaultproperties
{
    bIsApc=true
    PointValue=2.0
    ImpactDamageMult=0.001
    LeftTreadIndex=1
    RightTreadIndex=2
    LeftTreadPanDirection=(Pitch=0,Yaw=0,Roll=16384)
    RightTreadPanDirection=(Pitch=0,Yaw=0,Roll=16384)
    MaxCriticalSpeed=800.0
    WheelRotationScale=500
    DestructionEffectClass=class'ROEffects.ROVehicleDestroyedEmitter'
    VehicleSpikeTime=60.0
}

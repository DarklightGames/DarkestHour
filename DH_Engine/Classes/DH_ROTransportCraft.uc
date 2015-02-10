//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_ROTransportCraft extends DH_ROWheeledVehicle
    abstract;

var()   float               MaxCriticalSpeed;
var()   float               MaxPitchSpeed;

// Tread stuff
var     int                 LeftTreadIndex;
var     int                 RightTreadIndex;
var     VariableTexPanner   LeftTreadPanner, RightTreadPanner;
var()   float               TreadVelocityScale;

// Wheel animation
var()   array<name>         LeftWheelBones;     // for animation only - the bone names for the wheels on the left side
var()   array<name>         RightWheelBones;    // for animation only - the bone names for the wheels on the right side
var     rotator             LeftWheelRot;       // keep track of the left wheels rotational speed for animation
var     rotator             RightWheelRot;      // keep track of the right wheels rotational speed for animation
var()   int                 WheelRotationScale;

// Sound attachment actor variables
var()   sound               LeftTreadSound;    // sound for the left tread squeaking
var()   sound               RightTreadSound;   // sound for the right tread squeaking
var()   sound               RumbleSound;       // interior rumble sound
var     bool                bPlayTreadSound;
var     float               TreadSoundVolume;
var     ROSoundAttachment   LeftTreadSoundAttach;
var     ROSoundAttachment   RightTreadSoundAttach;
var     ROSoundAttachment   InteriorRumbleSoundAttach;
var     float               MotionSoundVolume;
var()   name                LeftTrackSoundBone;
var()   name                RightTrackSoundBone;
var()   name                RumbleSoundBone;


simulated function SetupTreads()
{
    LeftTreadPanner = VariableTexPanner(Level.ObjectPool.AllocateObject(class'VariableTexPanner'));

    if (LeftTreadPanner != none)
    {
        LeftTreadPanner.Material = Skins[LeftTreadIndex];
        LeftTreadPanner.PanDirection = rot(0, 0, 16384);
        LeftTreadPanner.PanRate = 0.0;
        Skins[LeftTreadIndex] = LeftTreadPanner;
    }

    RightTreadPanner = VariableTexPanner(Level.ObjectPool.AllocateObject(class'VariableTexPanner'));

    if (RightTreadPanner != none)
    {
        RightTreadPanner.Material = Skins[RightTreadIndex];
        RightTreadPanner.PanDirection = rot(0, 0, 16384);
        RightTreadPanner.PanRate = 0.0;
        Skins[RightTreadIndex] = RightTreadPanner;
    }
}

simulated function PostBeginPlay()
{
    super.PostBeginPlay();

    if (Level.NetMode != NM_DedicatedServer)
    {
        SetupTreads();

        if (LeftTreadSoundAttach == none)
        {
            LeftTreadSoundAttach = Spawn(class'ROSoundAttachment');
            LeftTreadSoundAttach.AmbientSound = LeftTreadSound;
            AttachToBone(LeftTreadSoundAttach, LeftTrackSoundBone);
        }

        if (RightTreadSoundAttach == none)
        {
            RightTreadSoundAttach = Spawn(class'ROSoundAttachment');
            RightTreadSoundAttach.AmbientSound = RightTreadSound;
            AttachToBone(RightTreadSoundAttach, RightTrackSoundBone);
        }

        if (InteriorRumbleSoundAttach == none)
        {
            InteriorRumbleSoundAttach = Spawn(class'ROSoundAttachment');
            InteriorRumbleSoundAttach.AmbientSound = RumbleSound;
            AttachToBone(InteriorRumbleSoundAttach, RumbleSoundBone);
        }
    }

/*  if (HasAnim('driver_hatch_idle_open'))
    {
        LoopAnim('driver_hatch_idle_open');
    }*/
}

simulated function UpdateMovementSound()
{
    if (LeftTreadSoundAttach != none)
    {
       LeftTreadSoundAttach.SoundVolume = MotionSoundVolume * 1.0;
    }

    if (RightTreadSoundAttach != none)
    {
       RightTreadSoundAttach.SoundVolume = MotionSoundVolume * 1.0;
    }

    if (InteriorRumbleSoundAttach != none)
    {
       InteriorRumbleSoundAttach.SoundVolume = MotionSoundVolume;
    }
}

simulated event DrivingStatusChanged()
{
    super.DrivingStatusChanged();

    if (!bDriving)
    {
        if (LeftTreadPanner != none)
        {
            LeftTreadPanner.PanRate = 0.0;
        }

        if (RightTreadPanner != none)
        {
            RightTreadPanner.PanRate = 0.0;
        }

        // Not moving, so no motion sound
        MotionSoundVolume = 0.0;
        UpdateMovementSound();
    }
}

simulated function Destroyed()
{
    DestroyTreads();

    if (LeftTreadSoundAttach != none)
    {
        LeftTreadSoundAttach.Destroy();
    }

    if (RightTreadSoundAttach != none)
    {
        RightTreadSoundAttach.Destroy();
    }

    if (InteriorRumbleSoundAttach != none)
    {
        InteriorRumbleSoundAttach.Destroy();
    }

    super.Destroyed();
}

// DriverLeft() called by KDriverLeave()
function DriverLeft()
{
    // Not moving, so no motion sound
    MotionSoundVolume = 0.0;
    UpdateMovementSound();

    super.DriverLeft();
}

simulated function DestroyTreads()
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
}

simulated function Tick(float DeltaTime)
{
    local KRigidBodyState BodyState;
    local float           LinTurnSpeed, MotionSoundTemp, MySpeed;
    local int             i;

    super.Tick(DeltaTime);

    // Only need these effects client side
    if (Level.NetMode != NM_DedicatedServer)
    {
        // Shame on you Psyonix, for calling VSize() 3 times every tick, when it only needed to be called once, as VSize() is very CPU intensive - Ramm
        MySpeed = VSize(Velocity);

        // Setup sounds that are dependent on velocity
        MotionSoundTemp =  MySpeed / MaxPitchSpeed * 255.0;

        if (MySpeed > 0.1)
        {
            MotionSoundVolume = FClamp(MotionSoundTemp, 0.0, 255.0);
        }
        else
        {
            MotionSoundVolume = 0.0;
        }

        UpdateMovementSound();

        if (MySpeed >= MaxCriticalSpeed && ROPlayer(Controller) != none)
        {
            ROPlayer(Controller).aForward = -32768.0; // forces player to pull back on throttle
        }

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
        }

        if (RightTreadPanner != none)
        {
            RightTreadPanner.PanRate = MySpeed / TreadVelocityScale;

            if (Velocity dot vector(Rotation) < 0.0)
            {
                RightTreadPanner.PanRate = -1.0 * RightTreadPanner.PanRate;
            }

            RightTreadPanner.PanRate -= LinTurnSpeed;
        }

        // Animate the tank wheels
        LeftWheelRot.pitch += LeftTreadPanner.PanRate * WheelRotationScale;
        RightWheelRot.pitch += RightTreadPanner.PanRate * WheelRotationScale;

        for (i = 0; i < LeftWheelBones.Length; i++)
        {
            SetBoneRotation(LeftWheelBones[i], LeftWheelRot);
        }

        for (i = 0; i < RightWheelBones.Length; i++)
        {
            SetBoneRotation(RightWheelBones[i], RightWheelRot);
        }
    }
}

function TakeDamage(int Damage, Pawn InstigatedBy, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional int HitIndex)
{
    local Controller InstigatorController;
    local float      VehicleDamageMod;
    local int        HitPointDamage, InstigatorTeam, i;

    // Fix for suicide death messages
    if (DamageType == class'Suicided')
    {
        DamageType = class'ROSuicided';

        super(ROVehicle).TakeDamage(Damage, InstigatedBy, Hitlocation, Momentum, DamageType);
    }
    else if (DamageType == class'ROSuicided')
    {
        super(ROVehicle).TakeDamage(Damage, InstigatedBy, Hitlocation, Momentum, DamageType);
    }

    // Quick fix for the thing giving itself impact damage
    if (InstigatedBy == self)
    {
        return;
    }

    // Don't allow your own teammates to destroy vehicles in spawns (and you know some jerks would get off on doing that to thier team :))
    if (!bDriverAlreadyEntered)
    {
        if (InstigatedBy != none)
        {
            InstigatorController = InstigatedBy.Controller;
        }

        if (InstigatorController == none && DamageType.default.bDelayedDamage)
        {
            InstigatorController = DelayedDamageInstigatorController;
        }

        if (InstigatorController != none)
        {
            InstigatorTeam = InstigatorController.GetTeamNum();

            if (GetTeamNum() != 255 && InstigatorTeam != 255 && GetTeamNum() == InstigatorTeam)
            {
                return;
            }
        }
    }

    // Hacked in APC damage mod for halftracks and armored cars, but bullets/bayo/nades/bashing still shouldn't work ...
    if (class<ROWeaponDamageType>(DamageType) != none && class<ROWeaponDamageType>(DamageType).default.APCDamageModifier >= 0.25)
    {
        VehicleDamageMod = class<ROWeaponDamageType>(DamageType).default.APCDamageModifier;
    }
    else if (class<ROVehicleDamageType>(DamageType) != none && class<ROVehicleDamageType>(DamageType).default.APCDamageModifier >= 0.25)
    {
        VehicleDamageMod = class<ROVehicleDamageType>(DamageType).default.APCDamageModifier;
    }

    for (i = 0; i < VehHitpoints.Length; i++)
    {
        HitPointDamage=Damage;

        if (VehHitpoints[i].HitPointType == HP_Driver)
        {
            // Damage for large weapons
            if (class<ROWeaponDamageType>(DamageType) != none && class<ROWeaponDamageType>(DamageType).default.VehicleDamageModifier > 0.25)
            {
                if (Driver != none && DriverPositions[DriverPositionIndex].bExposed && IsPointShot(Hitlocation,Momentum, 1.0, i))
                {
                    Driver.TakeDamage(Damage, InstigatedBy, Hitlocation, Momentum, DamageType);
                }
            }
            // Damage for small (non penetrating) arms
            else
            {
                if (Driver != none && DriverPositions[DriverPositionIndex].bExposed && IsPointShot(Hitlocation,Momentum, 1.0, i, DriverHitCheckDist))
                {
                    Driver.TakeDamage(150, InstigatedBy, Hitlocation, Momentum, DamageType);
                }
            }
        }
        else if (IsPointShot(Hitlocation,Momentum, 1.0, i))
        {
            HitPointDamage *= VehHitpoints[i].DamageMultiplier;
            HitPointDamage *= VehicleDamageMod;

            if (VehHitpoints[i].HitPointType == HP_Engine)
            {
                if (bDebuggingText)
                {
                    Level.Game.Broadcast(self, "Engine hit effective");
                }

                DamageEngine(HitPointDamage, InstigatedBy, Hitlocation, Momentum, DamageType);
            }
            else if (VehHitpoints[i].HitPointType == HP_AmmoStore)
            {
                if (bDebuggingText)
                {
                    Level.Game.Broadcast(self, "Ammo hit effective");
                }

                Damage *= Health;
                break;
            }
        }
    }

    Damage *= RandRange(0.85, 1.15);

    // Add in the Vehicle damage modifier for the actual damage to the vehicle itself
    Damage *= VehicleDamageMod;

    super(ROVehicle).TakeDamage(Damage, InstigatedBy, Hitlocation, Momentum, DamageType);

    // If vehicle health is very low, kill the engine (which will start a fire)
    if (Health >= 0 && Health <= HealthMax / 3)
    {
        bEngineDead = true;
        EngineHealth = 0;
        bEngineOff = true;
        SetEngine();
    }
}

// We want to disable APC if: engine is dead or vehicle takes big damage
// This should give time for troops to bail out and escape before vehicle blows
simulated function bool IsDisabled()
{
    return (EngineHealth <= 0 || (Health >= 0 && Health <= HealthMax / 3));
}

defaultproperties
{
    bEnterringUnlocks=false
    LeftTreadIndex=1
    RightTreadIndex=2
    MaxCriticalSpeed=800.0
    WheelRotationScale=500
    PointValue=2.0
    DestructionEffectClass=class'ROEffects.ROVehicleDestroyedEmitter'
    VehicleSpikeTime=60.0
    bIsApc=true
    bKeepDriverAuxCollision=false
}

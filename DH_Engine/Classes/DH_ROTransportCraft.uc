//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_ROTransportCraft extends DH_ROWheeledVehicle
    abstract;

var()   float               MaxCriticalSpeed; // if vehicle goes over max speed, it forces player to pull back on throttle

// Tread stuff
var     int                 LeftTreadIndex, RightTreadIndex;
var     VariableTexPanner   LeftTreadPanner, RightTreadPanner;
var()   float               TreadVelocityScale;
var     rotator             LeftTreadPanDirection, RightTreadPanDirection;

// Tread sounds
var()   sound               LeftTreadSound, RightTreadSound; // sound for each tread squeaking
var     float               TreadSoundVolume;
var     ROSoundAttachment   LeftTreadSoundAttach, RightTreadSoundAttach;
var()   name                LeftTrackSoundBone, RightTrackSoundBone;

// Wheel animation
var()   array<name>         LeftWheelBones, RightWheelBones; // for animation only - the bone names for the wheels on each side
var     rotator             LeftWheelRot, RightWheelRot;     // keep track of the wheel rotational speed for animation
var()   int                 WheelRotationScale;

// From DH_ROTreadCraft & ROTreadCraft (combines SetupTreads & some PostBeginPlay)
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

// Modified to add treads (from ROTreadCraft)
simulated function PostBeginPlay()
{
    super.PostBeginPlay();

    if (Level.NetMode != NM_DedicatedServer)
    {
        SetupTreads();
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

// Modified to add treads (from ROTreadCraft)
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
    }
}

// Modified to destroy treads (from ROTreadCraft)
simulated function Destroyed()
{
    super.Destroyed();

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

simulated function Tick(float DeltaTime)
{
    local KRigidBodyState BodyState;
    local float           MySpeed, LinTurnSpeed;
    local int             i;

    super.Tick(DeltaTime);

    // Only need these effects client side
    if (Level.NetMode != NM_DedicatedServer)
    {
        // Shame on you Psyonix, for calling VSize() 3 times every tick, when it only needed to be called once, as VSize() is very CPU intensive - Ramm
        MySpeed = VSize(Velocity);

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
        EngineHealth = 0;
        bEngineOff = true;
        SetEngine();
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
    LeftTreadPanDirection=(Pitch=0,Yaw=0,Roll=16384)
    RightTreadPanDirection=(Pitch=0,Yaw=0,Roll=16384)
}

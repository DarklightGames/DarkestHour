//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2021
//==============================================================================
// A simple pendulum simulation to allow bipods to wobble around realistically.
// All angles are in radians.
//
// BUGS:
// * Simulation runs faster at higher FPS
//==============================================================================

class DHBipodPhysicsSimulation extends Object;

var name BarrelBoneName;
var name BipodBoneName;

var bool bIsLocked;
var bool bIsLocking;

var float LockAngleStart;
var float LockAngleTarget;
var float LockStartTimeSeconds;
var float LockEndTimeSeconds;

var float Angle;
var float AngleMin;
var float AngleMax;
var float ArmLength;
var float AngularAcceleration;
var float AngularDamping;
var float AngularVelocity;
var float GravityScale;
var float YawDeltaFactor;
var float InstantaneousAngularAcceleration;
var float AngularVelocityThreshold;    // The angular velocity must be greater than or equal to this value in order for the bipod to move.
var float CoefficientOfRestitution;

var bool    bDebugPhysicsSimulation;
var float   NextDebugPrintTimeSeconds;

var float OldInstigatorYaw;

function Impulse(float ImpulseAngularAcceleration)
{
    InstantaneousAngularAcceleration += ImpulseAngularAcceleration;
}

function LockBipod(Weapon Weapon, float LockAngle, float DurationSeconds)
{
    if (bIsLocked || bIsLocking)
    {
        return;
    }

    bIsLocking = true;
    LockAngleStart = Angle;
    LockAngleTarget = LockAngle;
    LockStartTimeSeconds = Weapon.Level.TimeSeconds;
    LockEndTimeSeconds = LockStartTimeSeconds + DurationSeconds;
}

function UnlockBipod()
{
    bIsLocked = false;
    bIsLocking = false;
}

function PhysicsTick(DHWeapon Weapon, float DeltaTime)
{
    local rotator BarrelBoneRotation, BipodBoneRotation;
    local Controller Controller;
    local float InstigatorYaw;
    local float YawDeltaAngularAcceleration;
    local float BarrelRoll;
    local float BarrelPitch;
    local float PendulumForce;
    local float T;
    local float AngleExcess;

    if (Weapon == none || Weapon.Instigator == none || bIsLocked)
    {
        return;
    }

    if (bIsLocking)
    {
        T = (Weapon.Level.TimeSeconds - LockStartTimeSeconds) / (LockEndTimeSeconds - LockStartTimeSeconds);
        Angle = class'UInterp'.static.Acceleration(T, LockAngleStart, LockAngleTarget);

        if (T >= 1.0)
        {
            bIsLocked = true;
        }
    }

    Controller = Weapon.Instigator.Controller;

    DeltaTime /= Weapon.Level.TimeDilation;

    // TODO: get the local "world" location of the BAR (rotation of world only)
    InstigatorYaw = class'UUnits'.static.UnrealToRadians(Controller.Rotation.Yaw);

    // Angular acceleration imparted by the weapon's rotation in the world
    YawDeltaAngularAcceleration = -1.0 * ((InstigatorYaw - OldInstigatorYaw) * YawDeltaFactor);

    // Update the instigator yaw for the next frame
    OldInstigatorYaw = InstigatorYaw;

    // Get the barrel bone roll (so that we know which way is down!)
    BarrelBoneRotation = Weapon.GetBoneRotation(BarrelBoneName);
    BarrelRoll = class'UUnits'.static.UnrealToRadians(BarrelBoneRotation.Roll - 16384);
    BarrelPitch = class'UUnits'.static.UnrealToRadians(BarrelBoneRotation.Pitch);
    BarrelPitch = FClamp(BarrelPitch, class'UUnits'.static.DegreesToRadians(-90), class'UUnits'.static.DegreesToRadians(90));

    PendulumForce = (-1 * GravityScale / ArmLength) * Sin(Angle - BarrelRoll) * Cos(BarrelPitch);

    AngularAcceleration = PendulumForce + YawDeltaAngularAcceleration + InstantaneousAngularAcceleration;

    AngularVelocity += AngularAcceleration;

    if (Abs(AngularVelocity) < AngularVelocityThreshold)
    {
        AngularVelocity = 0;
    }

    Angle += AngularVelocity * ((AngularDamping ** DeltaTime) - 1.0) / Loge(AngularDamping);
    AngularVelocity *= AngularDamping ** DeltaTime;

    // Collision Bounciness (this is technically wrong!!)
    // Clamp the angle and apply
    if (Angle < AngleMin)
    {
        AngleExcess = Angle - AngleMin;
        Angle = AngleMin - AngleExcess;
        AngularVelocity = -AngleExcess * CoefficientOfRestitution;
    }
    else if (Angle > AngleMax)
    {
        AngleExcess = Angle - AngleMax;
        Angle = AngleMax - AngleExcess;
        AngularVelocity = -AngleExcess * CoefficientOfRestitution;
    }

    // Reset instantaneous angular acceleration.
    InstantaneousAngularAcceleration = 0;

    // Set the bone's rotation
    BipodBoneRotation.Pitch = class'UUnits'.static.RadiansToUnreal(Angle);
    Weapon.SetBoneRotation(BipodBoneName, BipodBoneRotation);

    if (bDebugPhysicsSimulation)
    {
        if (Weapon.Level.TimeSeconds > NextDebugPrintTimeSeconds)
        {
            NextDebugPrintTimeSeconds = Weapon.Level.TimeSeconds + 0.5f;
        }
    }
}

defaultproperties
{
    Angle=0
    AngularVelocity=0
    AngularDamping=0.01
    GravityScale=100.0
    AngularVelocityThreshold=0.06
    ArmLength=155.0
    YawDeltaFactor=2.0

    BarrelBoneName="Muzzle"
    BipodBoneName="Bipod"

    bDebugPhysicsSimulation=true    // TODO: make false by default

    bIsLocking=false
    bIsLocked=false

    // ~35 degrees either way
    AngleMin=-0.60
    AngleMax=0.60
    CoefficientOfRestitution=0.5
}


//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================
// A simple pendulum simulation to allow bipods to wobble around realistically.
// All angles are in radians.
//
// BUGS:
// * Simulation runs faster at higher FPS
//==============================================================================

class DHBipodPhysicsSimulation extends Object;

var DHBipodPhysicsSettings Settings;

var bool bIsLocked;
var bool bIsLocking;

var float LockAngleStart;
var float LockAngleTarget;
var float LockStartTimeSeconds;
var float LockEndTimeSeconds;

var float Angle;
var float AngularAcceleration;
var float AngularVelocity;
var float InstantaneousAngularAcceleration;

var float OldInstigatorYaw;

function int GetRotationComponent(EAxis Axis, Rotator Rotation)
{
    switch (Axis)
    {
        case AXIS_X: return Rotation.Roll;
        case AXIS_Y: return Rotation.Pitch;
        case AXIS_Z: return Rotation.Yaw;
        default:     return 0;
    }
}

function Initialize(DHBipodPhysicsSettings Settings)
{
    self.Settings = Settings;
}

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

    if (Settings == none || Weapon == none || Weapon.Instigator == none || bIsLocked)
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
    YawDeltaAngularAcceleration = -1.0 * ((InstigatorYaw - OldInstigatorYaw) * Settings.YawDeltaFactor);

    // Update the instigator yaw for the next frame
    OldInstigatorYaw = InstigatorYaw;

    // Get the barrel bone roll (so that we know which way is down!)
    BarrelBoneRotation = Weapon.GetBoneRotation(Settings.BarrelBoneName) + Settings.BarrelBoneRotationOffset;
    BarrelRoll = class'UUnits'.static.UnrealToRadians(GetRotationComponent(Settings.BarrelRollAxis, BarrelBoneRotation));
    BarrelPitch = class'UUnits'.static.UnrealToRadians(GetRotationComponent(Settings.BarrelPitchAxis, BarrelBoneRotation));
    BarrelPitch = FClamp(BarrelPitch, class'UUnits'.static.DegreesToRadians(-90), class'UUnits'.static.DegreesToRadians(90));

    PendulumForce = (-1 * Settings.GravityScale / Settings.ArmLength) * Sin(Angle - BarrelRoll) * Cos(BarrelPitch);

    AngularAcceleration = PendulumForce + YawDeltaAngularAcceleration + InstantaneousAngularAcceleration;

    AngularVelocity += AngularAcceleration;

    if (Abs(AngularVelocity) < Settings.AngularVelocityThreshold)
    {
        AngularVelocity = 0;
    }

    Angle += AngularVelocity * ((Settings.AngularDamping ** DeltaTime) - 1.0) / Loge(Settings.AngularDamping);
    AngularVelocity *= Settings.AngularDamping ** DeltaTime;

    // Collision Bounciness (this is technically wrong!!)
    // Clamp the angle and apply
    if (Settings.bLimitAngle)
    {
        if (Angle < Settings.AngleMin)
        {
            AngleExcess = Angle - Settings.AngleMin;
            Angle = Settings.AngleMin - AngleExcess;
            AngularVelocity = -AngleExcess * Settings.CoefficientOfRestitution;
        }
        else if (Angle > Settings.AngleMax)
        {
            AngleExcess = Angle - Settings.AngleMax;
            Angle = Settings.AngleMax - AngleExcess;
            AngularVelocity = -AngleExcess * Settings.CoefficientOfRestitution;
        }
    }

    // Reset instantaneous angular acceleration.
    InstantaneousAngularAcceleration = 0;

    // Set the bone's rotation
    BipodBoneRotation.Pitch = class'UUnits'.static.RadiansToUnreal(Angle * Settings.AngleFactor);
    Weapon.SetBoneRotation(Settings.BipodBoneName, BipodBoneRotation);
}

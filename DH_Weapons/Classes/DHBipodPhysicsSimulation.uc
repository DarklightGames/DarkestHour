//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2020
//==============================================================================
// A simple pendulum simulation to allow bipods to wobble around realistically.
// All angles are in radians.
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
var float MinAngle;
var float MaxAngle;
var float ArmLength;
var float AngularAcceleration;
var float AngularDamping;
var float AngularVelocity;
var float GravityScale;
var float YawDeltaFactor;
var float InstantaneousAngularAcceleration;
var float AngularVelocityThreshold;    // The angular velocity must be greater than or equal to this value in order for the bipod to move.

var bool    bDebugPhysicsSimulation;
var float   NextDebugPrintTimeSeconds;

var float OldInstigatorYaw;

function float Damp(float Source, float Smoothing, float DeltaTime)
{
    return Source * (Smoothing ** DeltaTime);
}

function Impulse(float ImpulseAngularAcceleration)
{
    InstantaneousAngularAcceleration += ImpulseAngularAcceleration;
}

/*
function LockBipod(float LockAngle, float DurationSeconds)
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
*/

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
    local float BarrelAngle;
    local float PendulumForce;
    local float T;

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
    YawDeltaAngularAcceleration = -1.0 * ((InstigatorYaw - OldInstigatorYaw) * YawDeltaFactor * DeltaTime);

    // Update the instigator yaw for the next frame
    OldInstigatorYaw = InstigatorYaw;

    // Get the barrel bone roll (so that we know which way is down!)
    BarrelBoneRotation = Weapon.GetBoneRotation(BarrelBoneName);
    BarrelAngle = class'UUnits'.static.UnrealToRadians(BarrelBoneRotation.Roll - 16384);

    PendulumForce = (-1 * GravityScale / ArmLength) * Sin(Angle - BarrelAngle);

    AngularAcceleration = PendulumForce + YawDeltaAngularAcceleration + InstantaneousAngularAcceleration;

    AngularVelocity += AngularAcceleration;

    // Damp the angular velocity.
    AngularVelocity = Damp(AngularVelocity, 1.0 - AngularDamping, DeltaTime);

    Angle += AngularVelocity;

    // Reset instantaneous angular acceleration.
    InstantaneousAngularAcceleration = 0;

    // Set the bone's rotation
    BipodBoneRotation.Pitch = class'UUnits'.static.RadiansToUnreal(Angle);
    Weapon.SetBoneRotation(BipodBoneName, BipodBoneRotation);

    if (bDebugPhysicsSimulation)
    {
        if (Weapon.Level.TimeSeconds > NextDebugPrintTimeSeconds)
        {
            Log("BarrelAngle" @ class'UUnits'.static.RadiansToDegrees(BarrelAngle));

            NextDebugPrintTimeSeconds = Weapon.Level.TimeSeconds + 0.5f;
        }
    }
}

defaultproperties
{
    Angle=0
    AngularVelocity=0
    AngularDamping=0.98
    GravityScale=1.0
    AngularVelocityThreshold=0.0
    ArmLength=125.0
    YawDeltaFactor=2.0

    BarrelBoneName='Muzzle'
    BipodBoneName='Bipod'

    bDebugPhysicsSimulation=true    // TODO: make false by default

    bIsLocking=false
    bIsLocked=false
}

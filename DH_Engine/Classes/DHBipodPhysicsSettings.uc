//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================
// Settings for use in a DHBipodPhysicsSimulation.
// All angle in radians.
//==============================================================================

class DHBipodPhysicsSettings extends Object;

var bool bLimitAngle;
var float AngleMin;
var float AngleMax;
var float AngleFactor;
var float ArmLength;
var float AngularDamping;
var float AngularVelocityThreshold;    // The angular velocity must be greater than or equal to this value in order for the bipod to move.
var name BarrelBoneName;
var name BipodBoneName;
var float CoefficientOfRestitution;
var float GravityScale;
var float YawDeltaFactor;

var Rotator BarrelBoneRotationOffset;
var EAxis BarrelRollAxis;
var EAxis BarrelPitchAxis;

defaultproperties
{
    AngularDamping=0.01
    AngularVelocityThreshold=0.06
    AngleMin=-0.60
    AngleMax=0.60
    AngleFactor=1.0
    ArmLength=155.0
    BarrelBoneName="Muzzle"
    BipodBoneName="Bipod"
    CoefficientOfRestitution=0.5
    GravityScale=100.0
    YawDeltaFactor=2.0
    BarrelRollAxis=AXIS_X
    BarrelPitchAxis=AXIS_Y
    bLimitAngle=true
}

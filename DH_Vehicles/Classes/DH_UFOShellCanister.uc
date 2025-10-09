//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_UFOShellCanister extends DHBullet;

var int NumberOfProjectilesPerShot; // the number of separate small projectiles launched by each canister shot

defaultproperties
{

    NumberOfProjectilesPerShot=50
    WhizType=2
    WhizSoundEffect=Class'DHBulletWhizUFO'
    BallisticCoefficient=4.0
    Speed=4988.0
    Damage=120000.0
    MyDamageType=Class'DHCanisterShotDamageType'

    bIsTracerBullet=true
    TracerEffectClass=Class'DHBulletTracerUFO_YellowOrange'
    StaticMesh=StaticMesh'DH_Tracers.Ger_Tracer_Ball'
    DeflectedMesh=StaticMesh'DH_Tracers.Ger_Tracer_Ball'
    SpeedFudgeScale=1.0
    TracerHue=40
}

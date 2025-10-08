//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_UFOLaserBulletBlue extends DH_GeratPIIBullet;

defaultproperties
{
    Speed=9000.0  //very slow
    TracerEffectClass=Class'DHBulletTracerUFO_Blue'
    StaticMesh=StaticMesh'DH_Tracers.Ger_Tracer_Ball'
    DeflectedMesh=StaticMesh'DH_Tracers.Ger_Tracer_Ball'
    SpeedFudgeScale=1.0
    TracerHue=0

    DHPenetrationTable(0)=31.9  // 100
    DHPenetrationTable(1)=31.4  // 250
    DHPenetrationTable(2)=21.8  // 500
    DHPenetrationTable(3)=21.2  // 750
    DHPenetrationTable(4)=11.5  // 1000
    DHPenetrationTable(5)=11.0  // 1250
    DHPenetrationTable(6)=10.5  // 1500
    DHPenetrationTable(7)=10.4  // 1750
    DHPenetrationTable(8)=10.3  // 2000
    DHPenetrationTable(9)=10.2  // 2500
    DHPenetrationTable(10)=10.1 // 3000
}

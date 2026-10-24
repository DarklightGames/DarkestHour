//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_GapStopSignBullet extends DHCannonShellAPDS;

defaultproperties
{
    Damage=5000000
    Speed=8000.0  //very slow
    TracerEffectClass=none
    StaticMesh=StaticMesh'DH_UFO_stc.UFO.stopsign_bullet'
    DeflectedMesh=StaticMesh'DH_UFO_stc.UFO.stopsign_bullet'
    SpeedFudgeScale=1.0
    TracerHue=0
    CoronaClass=none
    bHasTracer=false
    bHasShellTrail=false

    AmbientSound=none

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

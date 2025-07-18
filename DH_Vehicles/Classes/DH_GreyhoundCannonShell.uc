//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_GreyhoundCannonShell extends DHCannonShell;

defaultproperties
{
    Speed=53346.0 //2900 fps or 884 m/s
    MaxSpeed=53346.0
    ShellDiameter=3.7
    BallisticCoefficient=1.52 //Correct - verified on range at 1000 yards

    //Damage
    ImpactDamage=215  //solid shell
    ShellImpactDamage=Class'DH_StuartCannonShellDamageAP'
    HullFireChance=0.17
    EngineFireChance=0.3

    //Effects
    bShatterProne=true
    CoronaClass=Class'DHShellTracer_Red'
    ShellShatterEffectClass=Class'DHShellShatterEffect_Small'
    ShellHitVehicleEffectClass=Class'TankAPHitPenetrateSmall'

    //Sound
    VehicleDeflectSound=SoundGroup'ProjectileSounds.PTRD_deflect'
    VehicleHitSound=SoundGroup'ProjectileSounds.PTRD_penetrate'

    //Penetration
    DHPenetrationTable(0)=7.1
    DHPenetrationTable(1)=6.1
    DHPenetrationTable(2)=5.7
    DHPenetrationTable(3)=5.3
    DHPenetrationTable(4)=5.0
    DHPenetrationTable(5)=4.6
    DHPenetrationTable(6)=4.3
    DHPenetrationTable(7)=3.9
    DHPenetrationTable(8)=3.6
    DHPenetrationTable(9)=3.3
    DHPenetrationTable(10)=3.0
}

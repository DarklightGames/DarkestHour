//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================
// TODO
//==============================================================================
// [ ] Velocity
// [ ] Damage
// [ ] Penetration
//==============================================================================

class DH_R35CannonShell extends DHCannonShell;

defaultproperties
{
    Speed=53346.0 //2900 fps or 884 m/s
    MaxSpeed=53346.0
    ShellDiameter=3.7
    BallisticCoefficient=1.52 //Correct - verified on range at 1000 yards

    //Damage
    ImpactDamage=245  //solid shell
    Damage=980.0 //"regular" damage is only changed so that AT guns can be killed more reliably, so the radius is very small
    DamageRadius=70.0
    ShellImpactDamage=Class'DH_R35CannonShellDamageAPCBC'
    HullFireChance=0.17
    EngineFireChance=0.3

    //Effects
    bShatterProne=true
    CoronaClass=Class'DHShellTracer_White'
    ShellHitVehicleEffectClass=Class'TankAPHitPenetrateSmall'
    ShellShatterEffectClass=Class'DHShellShatterEffect_Small'
    TracerEffectClass=Class'DHShellTracer_White'

    //Sound
    VehicleDeflectSound=SoundGroup'ProjectileSounds.PTRD_deflect'
    VehicleHitSound=SoundGroup'ProjectileSounds.PTRD_penetrate'

    //Penetration
    DHPenetrationTable(0)=7.1   // 100 m
    DHPenetrationTable(1)=6.1   // 250 m
    DHPenetrationTable(2)=5.7   // 500 m
    DHPenetrationTable(3)=5.3   // 750 m
    DHPenetrationTable(4)=5.0   // 1000 m
    DHPenetrationTable(5)=4.6   // 1250 m
    DHPenetrationTable(6)=4.3   // 1500 m
    DHPenetrationTable(7)=3.9   // 1750 m
    DHPenetrationTable(8)=3.6   // 2000 m
    DHPenetrationTable(9)=3.3   // 2500 m
    DHPenetrationTable(10)=3.0  // 3000 m
}

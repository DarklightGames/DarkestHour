//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_StuartCannonShellHE extends DHCannonShellHE;

defaultproperties
{
    Speed=47828.0 // 2600 fps or 793 m/s
    MaxSpeed=47828.0
    ShellDiameter=3.7
    BallisticCoefficient=0.984 //TODO: double check this

    //Damage
    ImpactDamage=185
    Damage=100.0   //39 gramms TNT
    DamageRadius=400.0
    MyDamageType=Class'DHShellHE37mmDamageType'
    HullFireChance=0.5
    EngineFireChance=0.5

    //Effects
    CoronaClass=Class'DHShellTracer_Red'
    ShellHitVehicleEffectClass=Class'TankAPHitPenetrateSmall'
    ShellHitDirtEffectClass=Class'GrenadeExplosion'
    ShellHitSnowEffectClass=Class'GrenadeExplosionSnow'
    ShellHitWoodEffectClass=Class'GrenadeExplosion'
    ShellHitRockEffectClass=Class'GrenadeExplosion'
    ShellHitWaterEffectClass=Class'GrenadeExplosion'

    //Sound
    //VehicleDeflectSound=SoundGroup'ProjectileSounds.Bullets.PTRD_deflect'   <why would an explosive shell produce sound of bullet deflection?
    //VehicleHitSound=SoundGroup'ProjectileSounds.Bullets.PTRD_penetrate'

    //Penetration
    DHPenetrationTable(0)=1.2
    DHPenetrationTable(1)=1.1
    DHPenetrationTable(2)=1.0
    DHPenetrationTable(3)=1.0
    DHPenetrationTable(4)=1.0
}

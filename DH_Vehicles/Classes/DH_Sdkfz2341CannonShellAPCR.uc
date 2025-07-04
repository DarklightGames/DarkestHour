//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_Sdkfz2341CannonShellAPCR extends DHGermanCannonShell;

defaultproperties
{
    bNetTemporary=true // so its torn off straight after actor replication, like a bullet instead of a shell, due to volume of fire adding to net load (each shell is a net channel)

    RoundType=RT_APDS
    Speed=63369.6
    MaxSpeed=63369.6
    ShellDiameter=1.2 // sub-caliber round, 12mm tungsten core
    BallisticCoefficient=0.75 //Guesstimate based on lower weight and higher velocity of shell

    //Damage
    bShatterProne=true
    ImpactDamage=120
    ShellImpactDamage=Class'DH_Sdkfz2341CannonShellDamageAP'
    HullFireChance=0.20 // Slightly increased fire chances due to incendiary characteristics of projectile
    EngineFireChance=0.35

    Damage=50 //no explosive filler in 20mm PzGr -- this damage is just to simulate some splinters flying
    DamageRadius=120

    //Effects
    DrawScale=0.75
    CoronaClass=Class'DHShellTracer_Orange'
    ShellTrailClass=Class'DH20mmShellTrail_Red'

    ShellShatterEffectClass=Class'DHShellShatterEffect_Small'
    ShellDeflectEffectClass=Class'TankAPHitDeflect'
    ShellHitVehicleEffectClass=Class'DH20mmAPHitPenetrate'
    ShellHitDirtEffectClass=Class'DH20mmAPHitDirtEffect'
    ShellHitSnowEffectClass=Class'DH20mmAPHitSnowEffect'
    ShellHitWoodEffectClass=Class'DH20mmAPHitWoodEffect'
    ShellHitRockEffectClass=Class'DH20mmAPHitConcreteEffect'
    ShellHitWaterEffectClass=Class'DHShellSplashEffect'

    ExplosionDecal=Class'BulletHoleConcrete'
    ExplosionDecalSnow=Class'BulletHoleSnow'

    //Sounds
    VehicleDeflectSound=SoundGroup'ProjectileSounds.Impact_Metal'
    VehicleHitSound=SoundGroup'ProjectileSounds.PTRD_penetrate'
    DirtHitSound=SoundGroup'ProjectileSounds.Impact_Gravel'
    RockHitSound=SoundGroup'ProjectileSounds.Impact_Gravel'
    WaterHitSound=SoundGroup'ProjectileSounds.Impact_Water'
    WoodHitSound=SoundGroup'ProjectileSounds.Impact_Wood'

    //Penetration
    DHPenetrationTable(0)=5.8 //100m
    DHPenetrationTable(1)=4.2 //250
    DHPenetrationTable(2)=2.4 //500
    DHPenetrationTable(3)=1.3 //750
    DHPenetrationTable(4)=0.9 //1000
    DHPenetrationTable(5)=0.4 //1250
    DHPenetrationTable(6)=0.2 //1500
    DHPenetrationTable(7)=0.1 //1750
    DHPenetrationTable(8)=0.1 //2000
    DHPenetrationTable(9)=0.1 //2500
    DHPenetrationTable(10)=0.1 //3000

    //Gunsight adjustments
    MechanicalRanges(0)=(Range=0,RangeValue=-5.0)
    MechanicalRanges(1)=(Range=100,RangeValue=10.0)
    MechanicalRanges(2)=(Range=200,RangeValue=14.0)
    MechanicalRanges(3)=(Range=300,RangeValue=19.0)
    MechanicalRanges(4)=(Range=400,RangeValue=26.0)
    MechanicalRanges(5)=(Range=500,RangeValue=31.0)
    MechanicalRanges(6)=(Range=600,RangeValue=39.0)
    MechanicalRanges(7)=(Range=700,RangeValue=46.0)
    MechanicalRanges(8)=(Range=800,RangeValue=54.0)
    MechanicalRanges(9)=(Range=900,RangeValue=62.0)
    MechanicalRanges(10)=(Range=1000,RangeValue=71.0)
    MechanicalRanges(11)=(Range=1100,RangeValue=79.0)
    MechanicalRanges(12)=(Range=1200,RangeValue=90.0)
    bMechanicalAiming=true
}

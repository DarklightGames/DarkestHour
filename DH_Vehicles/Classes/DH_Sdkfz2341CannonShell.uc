//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_Sdkfz2341CannonShell extends DHGermanCannonShell;

defaultproperties
{
    bNetTemporary=true // so its torn off straight after actor replication, like a bullet instead of a shell, due to volume of fire adding to net load (each shell is a net channel)

    Speed=47075.0
    MaxSpeed=47075.0
    ShellDiameter=2.0
    BallisticCoefficient=0.68 //G1 figure based on JBM calculation for US M95 20mm AP

    //Damage
    ImpactDamage=155
    ShellImpactDamage=Class'DH_Sdkfz2341CannonShellDamageAP'
    HullFireChance=0.15
    EngineFireChance=0.3

    Damage=50 //no explosive filler in 20mm PzGr -- this damage is just to simulate some splinters flying
    DamageRadius=120

    //Effects
    DrawScale=0.75
    CoronaClass=Class'DHShellTracer_Orange'
    ShellTrailClass=Class'DH20mmShellTrail_YellowOrange'

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
    DHPenetrationTable(0)=3.1 //100m
    DHPenetrationTable(1)=2.6 //250
    DHPenetrationTable(2)=2.0 //500
    DHPenetrationTable(3)=1.4 //750
    DHPenetrationTable(4)=1.1 //1000
    DHPenetrationTable(5)=0.8 //1250
    DHPenetrationTable(6)=0.6 //1500
    DHPenetrationTable(7)=0.4 //1750
    DHPenetrationTable(8)=0.2 //2000
    DHPenetrationTable(9)=0.1 //2500
    DHPenetrationTable(10)=0.1 //3000

    //Gunsight adjustments
    MechanicalRanges(1)=(Range=100,RangeValue=33.0)
    MechanicalRanges(2)=(Range=200,RangeValue=37.0)
    MechanicalRanges(3)=(Range=300,RangeValue=41.0)
    MechanicalRanges(4)=(Range=400,RangeValue=48.0)
    MechanicalRanges(5)=(Range=500,RangeValue=56.0)
    MechanicalRanges(6)=(Range=600,RangeValue=64.0)
    MechanicalRanges(7)=(Range=700,RangeValue=76.0)
    MechanicalRanges(8)=(Range=800,RangeValue=87.0)
    MechanicalRanges(9)=(Range=900,RangeValue=97.0)
    MechanicalRanges(10)=(Range=1000,RangeValue=109.0)
    MechanicalRanges(11)=(Range=1100,RangeValue=122.0)
    MechanicalRanges(12)=(Range=1200,RangeValue=131.0)
    bMechanicalAiming=true
}

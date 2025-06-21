//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_T60CannonShell extends DHSovietCannonShell;

defaultproperties
{
    bNetTemporary=true // so its torn off straight after actor replication, like a bullet instead of a shell, due to volume of fire adding to net load (each shell is a net channel)

    Speed=47075.0
    MaxSpeed=47075.0
    ShellDiameter=2.0
    BallisticCoefficient=0.68 //G1 figure based on JBM calculation for US M95 20mm AP

    //Damage
    ImpactDamage=175
    ShellImpactDamage=Class'DH_Sdkfz2341CannonShellDamageAP'
    HullFireChance=0.15
    EngineFireChance=0.35

    Damage=50 //no explosive filler in 20mm BZT -- this damage is just to simulate some splinters flying (it did have some incendiary filler)
    DamageRadius=120

    //Effects
    DrawScale=0.75
    CoronaClass=Class'DHShellTracer_Green'
    ShellTrailClass=Class'DH20mmShellTrail_Green'

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
    DHPenetrationTable(0)=2.99 //100m; increased so that it can penetrate 35mm point blank (which it should be able to according to info that i found)
    DHPenetrationTable(1)=2.1 //250
    DHPenetrationTable(2)=1.7 //500
    DHPenetrationTable(3)=1.3 //750
    DHPenetrationTable(4)=1.0 //1000
    DHPenetrationTable(5)=0.8 //1250
    DHPenetrationTable(6)=0.6 //1500
    DHPenetrationTable(7)=0.4 //1750
    DHPenetrationTable(8)=0.2 //2000
    DHPenetrationTable(9)=0.1 //2500
    DHPenetrationTable(10)=0.1 //3000

    //Gunsight adjustments
    bOpticalAiming=true
    OpticalRanges(0)=(Range=0,RangeValue=0.471)
    OpticalRanges(1)=(Range=500,RangeValue=0.505)
    OpticalRanges(2)=(Range=1000,RangeValue=0.543)
    OpticalRanges(3)=(Range=1500,RangeValue=0.597)
    OpticalRanges(4)=(Range=2000,RangeValue=0.661)
    OpticalRanges(5)=(Range=2500,RangeValue=0.733)

    bMechanicalAiming=true // this cannon doesn't actually have mechanical aiming, but this is a fudge to adjust for sight markings that are 'out'
    MechanicalRanges(1)=(Range=500,RangeValue=-30.0)
    MechanicalRanges(2)=(Range=1000,RangeValue=-65.0)
    MechanicalRanges(3)=(Range=1500,RangeValue=-85.0) // can only set up to here
    MechanicalRanges(4)=(Range=2000,RangeValue=-105.0)
    MechanicalRanges(5)=(Range=2500,RangeValue=-125.0)
}

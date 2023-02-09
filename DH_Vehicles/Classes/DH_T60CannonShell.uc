//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
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
    ShellImpactDamage=class'DH_Vehicles.DH_Sdkfz2341CannonShellDamageAP'
    HullFireChance=0.15
    EngineFireChance=0.35

    Damage=50 //no explosive filler in 20mm BZT -- this damage is just to simulate some splinters flying (it did have some incendiary filler)
    DamageRadius=120

    //Effects
    DrawScale=0.75
    CoronaClass=class'DH_Effects.DHShellTracer_Green'
    ShellTrailClass=class'DH_Effects.DH20mmShellTrail_Green'

    ShellDeflectEffectClass=class'ROEffects.TankAPHitDeflect'
    ShellHitVehicleEffectClass=class'DH_Effects.DH20mmAPHitPenetrate'
    ShellHitDirtEffectClass=class'DH_Effects.DH20mmAPHitDirtEffect'
    ShellHitSnowEffectClass=class'DH_Effects.DH20mmAPHitSnowEffect'
    ShellHitWoodEffectClass=class'DH_Effects.DH20mmAPHitWoodEffect'
    ShellHitRockEffectClass=class'DH_Effects.DH20mmAPHitConcreteEffect'
    ShellHitWaterEffectClass=class'DH_Effects.DHShellSplashEffect'

    ExplosionDecal=class'ROEffects.BulletHoleConcrete'
    ExplosionDecalSnow=class'ROEffects.BulletHoleSnow'

    //Sounds
    VehicleDeflectSound=SoundGroup'ProjectileSounds.Bullets.Impact_Metal'
    VehicleHitSound=SoundGroup'ProjectileSounds.Bullets.PTRD_penetrate'
    DirtHitSound=SoundGroup'ProjectileSounds.Bullets.Impact_Gravel'
    RockHitSound=SoundGroup'ProjectileSounds.Bullets.Impact_Gravel'
    WaterHitSound=SoundGroup'ProjectileSounds.Bullets.Impact_Water'
    WoodHitSound=SoundGroup'ProjectileSounds.Bullets.Impact_Wood'

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

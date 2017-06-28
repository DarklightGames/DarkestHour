//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DH_Sdkfz2341CannonShell extends DHGermanCannonShell;

defaultproperties
{
    bNetTemporary=true // so is torn off straight after actor replication, like a bullet instead of a shell, due to volume of fire adding to net load (each shell is a net channel)
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
    DHPenetrationTable(0)=2.5
    DHPenetrationTable(1)=2.1
    DHPenetrationTable(2)=1.8
    DHPenetrationTable(3)=1.3
    DHPenetrationTable(4)=1.1
    DHPenetrationTable(5)=0.8
    DHPenetrationTable(6)=0.6
    DHPenetrationTable(7)=0.4
    DHPenetrationTable(8)=0.2
    DHPenetrationTable(9)=0.1
    DHPenetrationTable(10)=0.1
    ShellDiameter=2.0
    bHasTracer=false
    ShellImpactDamage=class'DH_Vehicles.DH_Sdkfz2341CannonShellDamageAP'
    ImpactDamage=175
    VehicleDeflectSound=SoundGroup'ProjectileSounds.Bullets.Impact_Metal'
    VehicleHitSound=SoundGroup'ProjectileSounds.Bullets.PTRD_penetrate'
    DirtHitSound=SoundGroup'ProjectileSounds.Bullets.Impact_Grass'
    RockHitSound=SoundGroup'ProjectileSounds.Bullets.Impact_Asphalt'
    WaterHitSound=SoundGroup'ProjectileSounds.Bullets.Impact_Water'
    WoodHitSound=SoundGroup'ProjectileSounds.Bullets.Impact_Wood'
    ShellHitVehicleEffectClass=class'ROEffects.TankAPHitPenetrateSmall'
    ShellHitDirtEffectClass=class'ROEffects.ROBulletHitDirtEffect'
    ShellHitSnowEffectClass=class'ROEffects.ROBulletHitSnowEffect'
    ShellHitWoodEffectClass=class'ROEffects.ROBulletHitWoodEffect'
    ShellHitRockEffectClass=class'ROEffects.ROBulletHitConcreteEffect'
    ShellHitWaterEffectClass=class'ROEffects.ROBulletHitWaterEffect'
    AmbientVolumeScale=2.0
    BallisticCoefficient=0.77
    SpeedFudgeScale=0.75
    Speed=47075.0
    MaxSpeed=47075.0
    ExplosionDecal=class'ROEffects.BulletHoleConcrete'
    ExplosionDecalSnow=class'ROEffects.BulletHoleSnow'
    StaticMesh=StaticMesh'EffectsSM.Weapons.Ger_Tracer'
    AmbientSound=SoundGroup'DH_ProjectileSounds.Bullets.Bullet_Whiz'
    Tag="PzGr."
    SoundRadius=350.0
    TransientSoundRadius=600.0
}

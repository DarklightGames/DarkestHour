//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_ShermanM4A3105CannonShellHE extends DH_ROTankCannonShellHE;

defaultproperties
{
    ExplosionSound(0)=SoundGroup'Artillery.explosions.explo01'
    ExplosionSound(1)=SoundGroup'Artillery.explosions.explo02'
    ExplosionSound(2)=SoundGroup'Artillery.explosions.explo03'
    ExplosionSound(3)=SoundGroup'Artillery.explosions.explo04'
    MechanicalRanges(1)=(Range=400)
    MechanicalRanges(2)=(Range=800)
    MechanicalRanges(3)=(Range=1200)
    MechanicalRanges(4)=(Range=1600)
    MechanicalRanges(5)=(Range=2000)
    MechanicalRanges(6)=(Range=2400)
    MechanicalRanges(7)=(Range=2800)
    MechanicalRanges(8)=(Range=3200)
    MechanicalRanges(9)=(Range=4200)
    bMechanicalAiming=true
    DHPenetrationTable(0)=8.000000
    DHPenetrationTable(1)=7.500000
    DHPenetrationTable(2)=7.200000
    DHPenetrationTable(3)=6.700000
    DHPenetrationTable(4)=6.100000
    DHPenetrationTable(5)=5.700000
    DHPenetrationTable(6)=5.200000
    DHPenetrationTable(7)=4.800000
    DHPenetrationTable(8)=4.200000
    DHPenetrationTable(9)=3.900000
    DHPenetrationTable(10)=3.500000
    ShellDiameter=10.500000
    PenetrationMag=1000.000000
    ShellImpactDamage=class'DH_Vehicles.DH_Sherman105ShellImpactDamageHEAT'
    ImpactDamage=650
    ShellDeflectEffectClass=class'ROEffects.ROArtilleryDirtEmitter'
    ShellHitDirtEffectClass=class'ROEffects.ROArtilleryDirtEmitter'
    ShellHitSnowEffectClass=class'ROEffects.ROArtillerySnowEmitter'
    ShellHitWoodEffectClass=class'ROEffects.ROArtilleryDirtEmitter'
    ShellHitRockEffectClass=class'ROEffects.ROArtilleryDirtEmitter'
    ShellHitWaterEffectClass=class'ROEffects.ROArtilleryWaterEmitter'
    BallisticCoefficient=2.960000
    Speed=28486.000000
    MaxSpeed=28486.000000
    Damage=500.000000
    DamageRadius=1350.000000
    MyDamageType=class'DH_Vehicles.DH_Sherman105CannonShellDamageHE'
    Tag="M1 HE"
    DrawScale=1.300000
}

//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_Cromwell95mmCannonShellHE extends DHCannonShellHE;

defaultproperties
{
    Speed=19916.0 // 330 m/s
    MaxSpeed=19916.0
    ShellDiameter=9.5
    BallisticCoefficient=2.6 // between 75mm (P3N) & 105mm howitzers

    //Damage
    ImpactDamage=1700
    Damage=750
    DamageRadius=1200
    PenetrationMag=965.0 // between 75mm (P3N) & 105mm howitzers
    HullFireChance=1.0
    EngineFireChance=1.0

    //Effects
    DrawScale=1.2
    ShellDeflectEffectClass=class'ROEffects.ROArtilleryDirtEmitter' // as 105mm howitzers
    ShellHitDirtEffectClass=class'ROEffects.ROArtilleryDirtEmitter'
    ShellHitSnowEffectClass=class'ROEffects.ROArtillerySnowEmitter'
    ShellHitWoodEffectClass=class'ROEffects.ROArtilleryDirtEmitter'
    ShellHitRockEffectClass=class'ROEffects.ROArtilleryDirtEmitter'
    ShellHitWaterEffectClass=class'ROEffects.ROArtilleryWaterEmitter'

    //Sounds
    ExplosionSound(0)=SoundGroup'Artillery.explosions.explo01' // as 105mm howitzers
    ExplosionSound(1)=SoundGroup'Artillery.explosions.explo02'
    ExplosionSound(2)=SoundGroup'Artillery.explosions.explo03'
    ExplosionSound(3)=SoundGroup'Artillery.explosions.explo04'

    //Penetration
    DHPenetrationTable(0)=5.7 // midway between 75mm (P3N) & 105mm howitzers
    DHPenetrationTable(1)=5.3
    DHPenetrationTable(2)=4.9
    DHPenetrationTable(3)=4.5
    DHPenetrationTable(4)=4.1
    DHPenetrationTable(5)=3.7
    DHPenetrationTable(6)=3.3
    DHPenetrationTable(7)=2.9
    DHPenetrationTable(8)=2.5
    DHPenetrationTable(9)=2.2
    DHPenetrationTable(10)=1.9

    //Gunsight adjustments
    MechanicalRanges(0)=(RangeValue=45.0)
    MechanicalRanges(1)=(Range=200,RangeValue=103.0)
    MechanicalRanges(2)=(Range=400,RangeValue=215.0)
    MechanicalRanges(3)=(Range=600,RangeValue=328.0)
    MechanicalRanges(4)=(Range=800,RangeValue=440.0)
    MechanicalRanges(5)=(Range=1000,RangeValue=558.0)
    MechanicalRanges(6)=(Range=1200,RangeValue=680.0)
    MechanicalRanges(7)=(Range=1400,RangeValue=800.0)
    MechanicalRanges(8)=(Range=1600,RangeValue=890.0)
    bMechanicalAiming=true
}

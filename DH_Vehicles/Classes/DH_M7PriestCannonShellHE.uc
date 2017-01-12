//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================
// This is a 105mm shell with the "base" charge, which has a significantly lower
// muzzle velocity than a fully charged round. This allows the Priest to be used
// to deliver rounds with a higher angle-of-incidence.
//==============================================================================

class DH_M7PriestCannonShellHE extends DHCannonShellHE;

defaultproperties
{
    SpeedFudgeScale=1.0
    ExplosionSound(0)=SoundGroup'Artillery.explosions.explo01'
    ExplosionSound(1)=SoundGroup'Artillery.explosions.explo02'
    ExplosionSound(2)=SoundGroup'Artillery.explosions.explo03'
    ExplosionSound(3)=SoundGroup'Artillery.explosions.explo04'
    DHPenetrationTable(0)=8.0
    DHPenetrationTable(1)=7.5
    DHPenetrationTable(2)=7.2
    DHPenetrationTable(3)=6.7
    DHPenetrationTable(4)=6.1
    DHPenetrationTable(5)=5.7
    DHPenetrationTable(6)=5.2
    DHPenetrationTable(7)=4.8
    DHPenetrationTable(8)=4.2
    DHPenetrationTable(9)=3.9
    DHPenetrationTable(10)=3.5
    ShellDiameter=10.5
    PenetrationMag=1000.0
    ImpactDamage=650
    ShellDeflectEffectClass=class'ROEffects.ROArtilleryDirtEmitter'
    ShellHitDirtEffectClass=class'ROEffects.ROArtilleryDirtEmitter'
    ShellHitSnowEffectClass=class'ROEffects.ROArtillerySnowEmitter'
    ShellHitWoodEffectClass=class'ROEffects.ROArtilleryDirtEmitter'
    ShellHitRockEffectClass=class'ROEffects.ROArtilleryDirtEmitter'
    ShellHitWaterEffectClass=class'ROEffects.ROArtilleryWaterEmitter'
    BallisticCoefficient=2.96
    Speed=9000           // 198m/s 75%
    MaxSpeed=9000
    Damage=500.0
    DamageRadius=1350.0
    MyDamageType=class'DH_Engine.DHShellHE105mmDamageType'
    Tag="M1 HE"
    DrawScale=1.3
}


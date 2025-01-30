//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================
// Carbon-copy of the priest shell, atm.
//==============================================================================

class DH_LeFH18CannonShellHE extends DHCannonShellHE;

defaultproperties
{
    Speed=8962.5         // 198m/s x 75%
    MaxSpeed=8962.5
    LifeSpan=20.0
    SpeedFudgeScale=1.0
    
    HitMapMarkerClass=class'DH_Engine.DHMapMarker_ArtilleryHit_HE'
    ShellImpactDamage=class'DH_Engine.DHShellHEImpactDamageType_Artillery'

    // Speed=28486.0
    // MaxSpeed=28486.0
    ShellDiameter=10.5
    BallisticCoefficient=2.96

    //Damage
    ImpactDamage=2000  //2.2 KG TNT
    Damage=1000.0
    DamageRadius=1350.0
    MyDamageType=class'DH_Engine.DHShellHE105mmDamageType_Artillery'
    PenetrationMag=1000.0
    HullFireChance=1.0
    EngineFireChance=1.0

    //Effects
    DrawScale=1.5
    ExplosionSound(0)=Sound'Artillery.explosions.explo01'
    ExplosionSound(1)=Sound'Artillery.explosions.explo02'
    ExplosionSound(2)=Sound'Artillery.explosions.explo03'
    ExplosionSound(3)=Sound'Artillery.explosions.explo04'
    TransientSoundRadius=20000.0    // Match the transient sound radius of the 105mm off-map artillery shell

    ShellDeflectEffectClass=class'ROEffects.ROArtilleryDirtEmitter'
    ShellHitDirtEffectClass=class'ROEffects.ROArtilleryDirtEmitter'
    ShellHitSnowEffectClass=class'ROEffects.ROArtillerySnowEmitter'
    ShellHitWoodEffectClass=class'ROEffects.ROArtilleryDirtEmitter'
    ShellHitRockEffectClass=class'ROEffects.ROArtilleryDirtEmitter'
    ShellHitWaterEffectClass=class'ROEffects.ROArtilleryWaterEmitter'

    //Penetration
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
}

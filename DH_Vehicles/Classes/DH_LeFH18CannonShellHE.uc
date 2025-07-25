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
    
    HitMapMarkerClass=class'DHMapMarker_ArtilleryHit_HE'
    ShellImpactDamage=class'DHShellHEImpactDamageType_Artillery'

    //Effects
    bHasTracer=false
    bHasShellTrail=false

    // Speed=28486.0
    // MaxSpeed=28486.0
    ShellDiameter=10.5
    BallisticCoefficient=2.96

    //Damage
    ImpactDamage=2000  //2.2 KG TNT
    Damage=1000.0
    DamageRadius=1350.0
    MyDamageType=class'DHShellHE105mmDamageType_Artillery'
    PenetrationMag=1000.0
    HullFireChance=1.0
    EngineFireChance=1.0

    //Effects
    DrawScale=1.5
    ExplosionSound(0)=Sound'Artillery.explo01'
    ExplosionSound(1)=Sound'Artillery.explo02'
    ExplosionSound(2)=Sound'Artillery.explo03'
    ExplosionSound(3)=Sound'Artillery.explo04'
    TransientSoundRadius=20000.0    // Match the transient sound radius of the 105mm off-map artillery shell

    ShellDeflectEffectClass=class'ROArtilleryDirtEmitter'
    ShellHitDirtEffectClass=class'ROArtilleryDirtEmitter'
    ShellHitSnowEffectClass=class'ROArtillerySnowEmitter'
    ShellHitWoodEffectClass=class'ROArtilleryDirtEmitter'
    ShellHitRockEffectClass=class'ROArtilleryDirtEmitter'
    ShellHitWaterEffectClass=class'ROArtilleryWaterEmitter'

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

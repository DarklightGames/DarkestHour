//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_ShermanM4A3105CannonShellHE extends DHCannonShellHE;

defaultproperties
{
    Speed=28486.0
    MaxSpeed=28486.0
    ShellDiameter=10.5
    BallisticCoefficient=2.96 //TODO: pls check

    //Damage
    ImpactDamage=2000  //2.2 KG TNT
    Damage=1000.0
    DamageRadius=1350.0
    MyDamageType=Class'DHShellHE105mmDamageType'
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

    ShellDeflectEffectClass=Class'ROArtilleryDirtEmitter'
    ShellHitDirtEffectClass=Class'ROArtilleryDirtEmitter'
    ShellHitSnowEffectClass=Class'ROArtillerySnowEmitter'
    ShellHitWoodEffectClass=Class'ROArtilleryDirtEmitter'
    ShellHitRockEffectClass=Class'ROArtilleryDirtEmitter'
    ShellHitWaterEffectClass=Class'ROArtilleryWaterEmitter'

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

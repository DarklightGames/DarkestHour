//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_AT57CannonShellHE extends DHCannonShellHE;

defaultproperties
{
    Speed=50152.0
    MaxSpeed=50152.0
    ShellDiameter=5.7
    BallisticCoefficient=1.19

    //Damage
    ImpactDamage=350
    ShellImpactDamage=class'DH_Engine.DHShellHEGunImpactDamageType'
    Damage=260.0  //couldnt find any information, so copied from ZIS-2
    DamageRadius=650.0
    MyDamageType=class'DH_Engine.DHShellHE50mmATDamageType'
    PenetrationMag=690.0
    HullFireChance=0.5
    EngineFireChance=0.50

    //Effects
    ShellHitDirtEffectClass=class'ROEffects.TankHEHitDirtEffect'
    ShellHitSnowEffectClass=class'ROEffects.TankHEHitSnowEffect'
    ShellHitWoodEffectClass=class'ROEffects.TankHEHitWoodEffect'
    ShellHitRockEffectClass=class'ROEffects.TankHEHitRockEffect'
    ShellHitWaterEffectClass=class'ROEffects.TankHEHitWaterEffect'

    //Penetration
    DHPenetrationTable(0)=2.9
    DHPenetrationTable(1)=2.7
    DHPenetrationTable(2)=2.4
    DHPenetrationTable(3)=2.1
    DHPenetrationTable(4)=1.9
    DHPenetrationTable(5)=1.6
    DHPenetrationTable(6)=1.3
    DHPenetrationTable(7)=1.2
    DHPenetrationTable(8)=1.0
    DHPenetrationTable(9)=0.9
    DHPenetrationTable(10)=0.7
}

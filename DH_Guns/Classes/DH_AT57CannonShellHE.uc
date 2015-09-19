//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_AT57CannonShellHE extends DHCannonShellHE;

defaultproperties
{
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
    ShellDiameter=5.7
    bHasTracer=true
    PenetrationMag=630.0
    ShellImpactDamage=class'DH_Engine.DHShellATImpactDamageType'
    ImpactDamage=295
    ShellHitDirtEffectClass=class'ROEffects.TankHEHitDirtEffect'
    ShellHitSnowEffectClass=class'ROEffects.TankHEHitSnowEffect'
    ShellHitWoodEffectClass=class'ROEffects.TankHEHitWoodEffect'
    ShellHitRockEffectClass=class'ROEffects.TankHEHitRockEffect'
    ShellHitWaterEffectClass=class'ROEffects.TankHEHitWaterEffect'
    BallisticCoefficient=1.62
    Speed=50152.0
    MaxSpeed=50152.0
    Damage=250.0
    DamageRadius=600.0
    MyDamageType=class'DH_Engine.DHShellHE50mmATDamageType'
    Tag="M303 HE"
}

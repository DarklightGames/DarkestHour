//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_AT57CannonShellHE extends DH_ROTankCannonShellHE;

defaultproperties
{
    DHPenetrationTable(0)=2.900000
    DHPenetrationTable(1)=2.700000
    DHPenetrationTable(2)=2.400000
    DHPenetrationTable(3)=2.100000
    DHPenetrationTable(4)=1.900000
    DHPenetrationTable(5)=1.600000
    DHPenetrationTable(6)=1.300000
    DHPenetrationTable(7)=1.200000
    DHPenetrationTable(8)=1.000000
    DHPenetrationTable(9)=0.900000
    DHPenetrationTable(10)=0.700000
    ShellDiameter=5.700000
    bHasTracer=true
    PenetrationMag=630.000000
    ShellImpactDamage=class'DH_Guns.DH_AT57CannonShellDamageAP'
    ImpactDamage=295
    ShellHitDirtEffectClass=class'ROEffects.TankHEHitDirtEffect'
    ShellHitSnowEffectClass=class'ROEffects.TankHEHitSnowEffect'
    ShellHitWoodEffectClass=class'ROEffects.TankHEHitWoodEffect'
    ShellHitRockEffectClass=class'ROEffects.TankHEHitRockEffect'
    ShellHitWaterEffectClass=class'ROEffects.TankHEHitWaterEffect'
    BallisticCoefficient=1.620000
    Speed=50152.000000
    MaxSpeed=50152.000000
    Damage=250.000000
    DamageRadius=600.000000
    MyDamageType=class'DH_Guns.DH_AT57CannonShellDamageHE'
    Tag="M303 HE"
}

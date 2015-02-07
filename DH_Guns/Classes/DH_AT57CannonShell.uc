//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_AT57CannonShell extends DH_ROTankCannonShell;

defaultproperties
{
    DHPenetrationTable(0)=11.500000
    DHPenetrationTable(1)=11.000000
    DHPenetrationTable(2)=10.300000
    DHPenetrationTable(3)=9.600000
    DHPenetrationTable(4)=9.000000
    DHPenetrationTable(5)=8.400000
    DHPenetrationTable(6)=7.800000
    DHPenetrationTable(7)=7.300000
    DHPenetrationTable(8)=6.800000
    DHPenetrationTable(9)=6.000000
    DHPenetrationTable(10)=5.200000
    ShellDiameter=5.700000
    bShatterProne=true
    ShellShatterEffectClass=class'DH_Effects.DH_TankAPShellShatterSmall'
    TracerEffect=class'DH_Effects.DH_RedTankShellTracer'
    ShellImpactDamage=class'DH_Guns.DH_AT57CannonShellDamageAP'
    ImpactDamage=350
    BallisticCoefficient=1.620000
    Speed=50152.000000
    MaxSpeed=50152.000000
    Tag="M86 APC"
}

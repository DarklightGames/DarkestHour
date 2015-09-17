//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_HellcatCannonShellHE extends DHCannonShellHE;

defaultproperties
{
    DHPenetrationTable(0)=4.2
    DHPenetrationTable(1)=3.8
    DHPenetrationTable(2)=3.2
    DHPenetrationTable(3)=2.9
    DHPenetrationTable(4)=2.4
    DHPenetrationTable(5)=2.0
    DHPenetrationTable(6)=1.7
    DHPenetrationTable(7)=1.3
    DHPenetrationTable(8)=1.1
    DHPenetrationTable(9)=1.0
    DHPenetrationTable(10)=0.8
    ShellDiameter=7.62
    PenetrationMag=780.0
    ShellImpactDamage=class'DH_Vehicles.DH_ShermanM4A176WCannonShellDamageAP'
    ImpactDamage=450
    BallisticCoefficient=1.368
    Speed=47799.0
    MaxSpeed=47799.0
    Damage=400.0
    DamageRadius=1140.0
    MyDamageType=class'DH_Vehicles.DH_ShermanM4A176WCannonShellDamageHE'
    Tag="M42A1 HE"
}

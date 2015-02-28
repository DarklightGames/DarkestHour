//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_JacksonCannonShellHE extends DH_ROTankCannonShellHE;

defaultproperties
{
    DHPenetrationTable(0)=5.2
    DHPenetrationTable(1)=4.9
    DHPenetrationTable(2)=4.3
    DHPenetrationTable(3)=4.0
    DHPenetrationTable(4)=3.8
    DHPenetrationTable(5)=3.2
    DHPenetrationTable(6)=3.0
    DHPenetrationTable(7)=2.7
    DHPenetrationTable(8)=2.3
    DHPenetrationTable(9)=1.9
    DHPenetrationTable(10)=1.5
    ShellDiameter=9.0
    PenetrationMag=1020.0
    ShellImpactDamage=class'DH_Vehicles.DH_JacksonCannonShellDamageAP'
    ImpactDamage=510
    BallisticCoefficient=1.79
    Speed=49609.0
    MaxSpeed=49609.0
    Damage=450.0
    DamageRadius=1570.0
    MyDamageType=class'DH_Vehicles.DH_JacksonCannonShellDamageHE'
    Tag="M71 HE"
}

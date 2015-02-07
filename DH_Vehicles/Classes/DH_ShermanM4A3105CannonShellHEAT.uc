//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_ShermanM4A3105CannonShellHEAT extends DH_ROTankCannonShellHEAT;

defaultproperties
{
    DHPenetrationTable(0)=12.800000
    DHPenetrationTable(1)=12.800000
    DHPenetrationTable(2)=12.800000
    DHPenetrationTable(3)=12.800000
    DHPenetrationTable(4)=12.800000
    DHPenetrationTable(5)=12.800000
    DHPenetrationTable(6)=12.800000
    DHPenetrationTable(7)=12.800000
    DHPenetrationTable(8)=12.800000
    DHPenetrationTable(9)=12.800000
    DHPenetrationTable(10)=12.800000
    ShellDiameter=10.500000
    ShellImpactDamage=class'DH_Vehicles.DH_Sherman105ShellImpactDamageHEAT'
    ImpactDamage=650
    BallisticCoefficient=2.960000
    SpeedFudgeScale=0.700000
    Speed=22994.000000
    MaxSpeed=22994.000000
    Damage=415.000000
    DamageRadius=700.000000
    MyDamageType=class'DH_Vehicles.DH_Sherman105CannonShellDamageHEAT'
    Tag="M67 HEAT"
}

//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_ShermanM4A3105CannonShellHEAT extends DH_ROTankCannonShellHEAT;

defaultproperties
{
    DHPenetrationTable(0)=12.8
    DHPenetrationTable(1)=12.8
    DHPenetrationTable(2)=12.8
    DHPenetrationTable(3)=12.8
    DHPenetrationTable(4)=12.8
    DHPenetrationTable(5)=12.8
    DHPenetrationTable(6)=12.8
    DHPenetrationTable(7)=12.8
    DHPenetrationTable(8)=12.8
    DHPenetrationTable(9)=12.8
    DHPenetrationTable(10)=12.8
    ShellDiameter=10.5
    ShellImpactDamage=class'DH_Vehicles.DH_Sherman105ShellImpactDamageHEAT'
    ImpactDamage=650
    BallisticCoefficient=2.96
    SpeedFudgeScale=0.7
    Speed=22994.0
    MaxSpeed=22994.0
    Damage=415.0
    DamageRadius=700.0
    MyDamageType=class'DH_Vehicles.DH_Sherman105CannonShellDamageHEAT'
    Tag="M67 HEAT"
}

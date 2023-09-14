//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_ShermanM4A3105CannonShellHEAT extends DHCannonShellHEAT;

defaultproperties
{
    Speed=22994.0
    MaxSpeed=22994.0
    ShellDiameter=10.5
    BallisticCoefficient=2.96 //TODO: check BC

    //Damage
    ImpactDamage=650  //1.6 KG TNT
    Damage=700.0
    DamageRadius=1000.0

    //Effects
    DrawScale=1.5

    //Penetration
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
}

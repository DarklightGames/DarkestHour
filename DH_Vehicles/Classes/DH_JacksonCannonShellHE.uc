//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_JacksonCannonShellHE extends DHCannonShellHE;

defaultproperties
{
    Speed=49667.0 //2700 fps or 823 m/s
    MaxSpeed=49667.0
    ShellDiameter=9.0
    BallisticCoefficient=3.62 //Correct - verified on range at 1000 yards

    //Damage
    ImpactDamage=1000
    Damage=475.0   // 1 KG TNT
    DamageRadius=1550.0
    MyDamageType=class'DH_Engine.DHShellHE88mmDamageType'
    PenetrationMag=1020.0
    HullFireChance=1.0
    EngineFireChance=1.0

    //Penetration
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
}

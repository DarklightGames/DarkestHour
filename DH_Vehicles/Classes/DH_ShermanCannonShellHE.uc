//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2020
//==============================================================================

class DH_ShermanCannonShellHE extends DHCannonShellHE;

defaultproperties
{
    Speed=37358.0 // 2030 fps or 619 m/s -using APC shells Mv
    MaxSpeed=37358.0
    ShellDiameter=7.5
    BallisticCoefficient=2.8 //TODO: pls check - this is the APC shell's BC

    //Damage
    ImpactDamage=475
    Damage=415.0
    DamageRadius=1550.0
    PenetrationMag=1000.0
    HullFireChance=0.34
    EngineFireChance=0.68

    //Penetration
    DHPenetrationTable(0)=3.3
    DHPenetrationTable(1)=3.1
    DHPenetrationTable(2)=2.8
    DHPenetrationTable(3)=2.4
    DHPenetrationTable(4)=2.0
    DHPenetrationTable(5)=1.7
    DHPenetrationTable(6)=1.3
    DHPenetrationTable(7)=1.1
    DHPenetrationTable(8)=0.9
    DHPenetrationTable(9)=0.5
    DHPenetrationTable(10)=0.3
}

//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_ShermanCannonShellHE extends DHCannonShellHE;

defaultproperties
{
    Speed=37358.0 // 2030 fps or 619 m/s -using APC shells Mv
    MaxSpeed=37358.0
    ShellDiameter=7.5
    BallisticCoefficient=2.8 //TODO: pls check - this is the APC shell's BC

    //Damage
    ImpactDamage=710
    ShellImpactDamage=class'DH_Engine.DHShellHEGunImpactDamageType'
    PenetrationMag=750.0
    Damage=350.0   //680 gramms TNT
    DamageRadius=950.0
    MyDamageType=class'DH_Engine.DHShellHE75mmATDamageType'
    HullFireChance=0.8
    EngineFireChance=0.8

    //Penetration
    DHPenetrationTable(0)=3.3
    DHPenetrationTable(1)=3.1
    DHPenetrationTable(2)=2.8
    DHPenetrationTable(3)=2.4
    DHPenetrationTable(4)=2.0
    DHPenetrationTable(5)=2.0
    DHPenetrationTable(6)=2.0
    DHPenetrationTable(7)=2.0
    DHPenetrationTable(8)=2.0
    DHPenetrationTable(9)=2.0
    DHPenetrationTable(10)=2.0
}

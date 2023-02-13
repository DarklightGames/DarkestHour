//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_CromwellCannonShellHE extends DHCannonShellHE;

defaultproperties
{
    Speed=27943.0
    MaxSpeed=27943.0
    ShellDiameter=7.5
    BallisticCoefficient=1.686 //TODO: pls check

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

    //Gunsight adjustment
    MechanicalRanges(0)=(RangeValue=16.0)
    MechanicalRanges(1)=(Range=200,RangeValue=36.0)
    MechanicalRanges(2)=(Range=400,RangeValue=68.0)
    MechanicalRanges(3)=(Range=600,RangeValue=96.0)
    MechanicalRanges(4)=(Range=800,RangeValue=136.0)
    MechanicalRanges(5)=(Range=1000,RangeValue=176.0)
    MechanicalRanges(6)=(Range=1200,RangeValue=228.0)
    MechanicalRanges(7)=(Range=1400,RangeValue=292.0)
    MechanicalRanges(8)=(Range=1600,RangeValue=352.0)
    MechanicalRanges(9)=(Range=1800,RangeValue=412.0)
    MechanicalRanges(10)=(Range=2000,RangeValue=476.0)
    MechanicalRanges(11)=(Range=2200,RangeValue=556.0)
    MechanicalRanges(12)=(Range=2400,RangeValue=640.0)
    MechanicalRanges(13)=(Range=2600,RangeValue=726.0)
    MechanicalRanges(14)=(Range=2800,RangeValue=828.0)
    MechanicalRanges(15)=(Range=3000,RangeValue=938.0)
    MechanicalRanges(16)=(Range=3200,RangeValue=1064.0)
    bMechanicalAiming=true
}

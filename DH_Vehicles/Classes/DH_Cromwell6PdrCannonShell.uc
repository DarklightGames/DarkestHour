//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_Cromwell6PdrCannonShell extends DHCannonShell;

defaultproperties
{
    Speed=50152.0
    MaxSpeed=50152.0
    ShellDiameter=5.7
    BallisticCoefficient=1.19 //pls check

    //Damage
    ImpactDamage=390  //solid shell
    ShellImpactDamage=class'DH_Engine.DHShellAPGunImpactDamageType'
    HullFireChance=0.25
    EngineFireChance=0.45

    //Effects
    CoronaClass=class'DH_Effects.DHShellTracer_Red'
    ShellShatterEffectClass=class'DH_Effects.DHShellShatterEffect_Small'

    //Penetration
    DHPenetrationTable(0)=11.5
    DHPenetrationTable(1)=11.0
    DHPenetrationTable(2)=10.3
    DHPenetrationTable(3)=9.6
    DHPenetrationTable(4)=9.0
    DHPenetrationTable(5)=8.4
    DHPenetrationTable(6)=7.8
    DHPenetrationTable(7)=7.3
    DHPenetrationTable(8)=6.8
    DHPenetrationTable(9)=6.0
    DHPenetrationTable(10)=5.2

    //Gunsight adjustment
    MechanicalRanges(1)=(Range=100,RangeValue=1.0)
    MechanicalRanges(2)=(Range=200,RangeValue=2.0)
    MechanicalRanges(3)=(Range=300,RangeValue=3.0)
    MechanicalRanges(4)=(Range=400,RangeValue=4.0)
    MechanicalRanges(5)=(Range=500,RangeValue=5.5)
    MechanicalRanges(6)=(Range=600,RangeValue=7.0)
    MechanicalRanges(7)=(Range=700,RangeValue=15.0)
    MechanicalRanges(8)=(Range=800,RangeValue=25.0)
    MechanicalRanges(9)=(Range=900,RangeValue=45.0)
    MechanicalRanges(10)=(Range=1000,RangeValue=62.0)
    MechanicalRanges(11)=(Range=1100,RangeValue=72.0)
    MechanicalRanges(12)=(Range=1200,RangeValue=80.0)
    MechanicalRanges(13)=(Range=1300,RangeValue=92.0)
    MechanicalRanges(14)=(Range=1400,RangeValue=102.0)
    MechanicalRanges(15)=(Range=1500,RangeValue=112.0)
    MechanicalRanges(16)=(Range=1600,RangeValue=118.0)
    MechanicalRanges(17)=(Range=1700,RangeValue=134.0)
    MechanicalRanges(18)=(Range=1800,RangeValue=172.0)
    MechanicalRanges(19)=(Range=1900,RangeValue=186.0)
    MechanicalRanges(20)=(Range=2000,RangeValue=210.0)
    MechanicalRanges(21)=(Range=2200,RangeValue=258.0)
    MechanicalRanges(22)=(Range=2400,RangeValue=306.0)
    MechanicalRanges(23)=(Range=2600,RangeValue=354.0)
    MechanicalRanges(24)=(Range=2800,RangeValue=402.0)
    bMechanicalAiming=true
}

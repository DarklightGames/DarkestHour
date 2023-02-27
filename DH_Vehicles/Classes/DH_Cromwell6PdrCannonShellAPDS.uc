//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_Cromwell6PdrCannonShellAPDS extends DHCannonShellAPDS;

defaultproperties
{
    Speed=73569.0
    MaxSpeed=73569.0
    ShellDiameter=3.7 //sub-caliber
    BallisticCoefficient=1.15 //TODO: pls, check

    //Damage
    bShatterProne=true
    ImpactDamage=310
    ShellImpactDamage=class'DH_Vehicles.DH_Cromwell6PdrCannonShellDamageAPDS'
    HullFireChance=0.4
    EngineFireChance=0.6

    //Effects
    ShellShatterEffectClass=class'DH_Effects.DHShellShatterEffect_Small'

    //Penetration
    DHPenetrationTable(0)=14.2
    DHPenetrationTable(1)=13.4
    DHPenetrationTable(2)=12.7
    DHPenetrationTable(3)=11.7
    DHPenetrationTable(4)=11.0
    DHPenetrationTable(5)=10.4
    DHPenetrationTable(6)=9.5
    DHPenetrationTable(7)=8.9
    DHPenetrationTable(8)=8.3
    DHPenetrationTable(9)=7.3
    DHPenetrationTable(10)=6.4

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

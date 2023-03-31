//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_Flak88CannonShellHE extends DHCannonShellHE;

defaultproperties
{
    Speed=49489.0
    MaxSpeed=49489.0
    ShellDiameter=8.8
    BallisticCoefficient=2.4 //TODO: pls, check


	//Damage
    ImpactDamage=1000
    Damage=475.0   // 1002 gramms TNT
    DamageRadius=1550.0
    MyDamageType=class'DH_Engine.DHShellHE88mmDamageType'
    PenetrationMag=1020.0
    HullFireChance=1.0
    EngineFireChance=1.0

    ShellImpactDamage=class'DH_Engine.DHShellHEGunImpactDamageType'


    bDebugInImperial=false

    //Effects
    bHasTracer=false
    bHasShellTrail=false

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

    //Gunsight adjustments
    MechanicalRanges(1)=(Range=100,RangeValue=18.0)
    MechanicalRanges(2)=(Range=200,RangeValue=32.0)
    MechanicalRanges(3)=(Range=300,RangeValue=44.0)
    MechanicalRanges(4)=(Range=400,RangeValue=60.0)
    MechanicalRanges(5)=(Range=500,RangeValue=74.0)
    MechanicalRanges(6)=(Range=600,RangeValue=94.0)
    MechanicalRanges(7)=(Range=700,RangeValue=112.0)
    MechanicalRanges(8)=(Range=800,RangeValue=126.0)
    MechanicalRanges(9)=(Range=900,RangeValue=142.0)
    MechanicalRanges(10)=(Range=1000,RangeValue=166.0)
    MechanicalRanges(11)=(Range=1100,RangeValue=180.0)
    MechanicalRanges(12)=(Range=1200,RangeValue=202.0)
    MechanicalRanges(13)=(Range=1300,RangeValue=218.0)
    MechanicalRanges(14)=(Range=1400,RangeValue=238.0)
    MechanicalRanges(15)=(Range=1500,RangeValue=264.0)
    MechanicalRanges(16)=(Range=1600,RangeValue=284.0)
    MechanicalRanges(17)=(Range=1700,RangeValue=306.0)
    MechanicalRanges(18)=(Range=1800,RangeValue=326.0)
    MechanicalRanges(19)=(Range=1900,RangeValue=350.0)
    MechanicalRanges(20)=(Range=2000,RangeValue=372.0)
    MechanicalRanges(21)=(Range=2200,RangeValue=409.0)
    MechanicalRanges(22)=(Range=2400,RangeValue=447.0)
    MechanicalRanges(23)=(Range=2600,RangeValue=484.0)
    MechanicalRanges(24)=(Range=2800,RangeValue=521.0)
    MechanicalRanges(25)=(Range=3000,RangeValue=558.0)
    bMechanicalAiming=true
}

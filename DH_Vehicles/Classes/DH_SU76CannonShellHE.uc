//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_SU76CannonShellHE extends DHCannonShellHE;

defaultproperties
{
    Speed=39953.0 // 662 m/s TODO: fix this
    MaxSpeed=39953.0
    ShellDiameter=7.62
    BallisticCoefficient=1.55

    //Damage
    ImpactDamage=750
    ShellImpactDamage=class'DH_Engine.DHShellHEGunImpactDamageType'
    PenetrationMag=800.0
    Damage=400.0   //710 gramms TNT
    DamageRadius=1000.0
    MyDamageType=class'DH_Engine.DHShellHE75mmATDamageType'
    HullFireChance=0.8
    EngineFireChance=0.8

    bDebugInImperial=false

    //Effects
    CoronaClass=class'DH_Effects.DHShellTracer_Green'

    //Penetration
    DHPenetrationTable(0)=3.3
    DHPenetrationTable(1)=3.1
    DHPenetrationTable(2)=2.8
    DHPenetrationTable(3)=2.4
    DHPenetrationTable(4)=2.4
    DHPenetrationTable(5)=2.4
    DHPenetrationTable(6)=2.4
    DHPenetrationTable(7)=2.4
    DHPenetrationTable(8)=2.4
    DHPenetrationTable(9)=2.4
    DHPenetrationTable(10)=2.4

    //Gunsight adjustments
	//adjusted from zis3 because for some weird reason SU76 gun shoots significantly below the cross on 0 meters setting
    bMechanicalAiming=true
	MechanicalRanges(0)=(Range=0,RangeValue=100.0)
    MechanicalRanges(1)=(Range=200,RangeValue=107.0)
    MechanicalRanges(2)=(Range=400,RangeValue=103.0)
    MechanicalRanges(3)=(Range=600,RangeValue=127.0)
    MechanicalRanges(4)=(Range=800,RangeValue=155.0)
    MechanicalRanges(5)=(Range=1000,RangeValue=187.0)
    MechanicalRanges(6)=(Range=1200,RangeValue=223.0)
    MechanicalRanges(7)=(Range=1400,RangeValue=260.0)
    MechanicalRanges(8)=(Range=1600,RangeValue=300.0)
    MechanicalRanges(9)=(Range=1800,RangeValue=347.0)
    MechanicalRanges(10)=(Range=2000,RangeValue=385.0)
    MechanicalRanges(11)=(Range=2200,RangeValue=438.0)
    MechanicalRanges(12)=(Range=2400,RangeValue=497.0)
    MechanicalRanges(13)=(Range=2600,RangeValue=558.0)
    MechanicalRanges(14)=(Range=2800,RangeValue=609.0) // estimates from here on as these extreme ranges are largely theoretical
    MechanicalRanges(15)=(Range=3000,RangeValue=650.0)
    MechanicalRanges(16)=(Range=3200,RangeValue=711.0)
    MechanicalRanges(17)=(Range=3400,RangeValue=772.0)
    MechanicalRanges(18)=(Range=3600,RangeValue=833.0)
    MechanicalRanges(19)=(Range=3800,RangeValue=894.0)
    MechanicalRanges(20)=(Range=4000,RangeValue=955.0)
}

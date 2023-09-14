//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_SU76CannonShellAPCR extends DHCannonShellAPDS;

defaultproperties
{
    RoundType=RT_APDS //RT_APDS because APCR uses same pen calcs
    Speed=39953.0 // 662 m/s
    MaxSpeed=39953.0
    ShellDiameter=5.0 //sub-caliber round
    BallisticCoefficient=1.55 //TODO: pls, check

    //Damage
    ImpactDamage=375 // just a tungsten slug; no explosive filler
    ShellImpactDamage=class'DH_Engine.DHShellSubCalibreImpactDamageType'
    HullFireChance=0.26
    EngineFireChance=0.55

    //Effects
    CoronaClass=class'DH_Effects.DHShellTracer_Green'
    ShellShatterEffectClass=class'DH_Effects.DHShellShatterEffect'

    //Penetration
    DHPenetrationTable(0)=13.0  // 100m
    DHPenetrationTable(1)=11.4  // 250m
    DHPenetrationTable(2)=9.2   // 500m
    DHPenetrationTable(3)=7.5
    DHPenetrationTable(4)=6.0   // 1000m
    DHPenetrationTable(5)=4.9
    DHPenetrationTable(6)=3.9   // 1500m
    DHPenetrationTable(7)=3.1
    DHPenetrationTable(8)=2.6   // 2000m
    DHPenetrationTable(9)=1.7
    DHPenetrationTable(10)=1.1  // 3000m

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

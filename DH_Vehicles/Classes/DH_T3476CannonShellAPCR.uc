//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_T3476CannonShellAPCR extends DHCannonShellAPDS;

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
    bOpticalAiming=true
    OpticalRanges(0)=(Range=0,RangeValue=0.410)
    OpticalRanges(1)=(Range=200,RangeValue=0.417)
    OpticalRanges(2)=(Range=400,RangeValue=0.425)
    OpticalRanges(3)=(Range=600,RangeValue=0.432)
    OpticalRanges(4)=(Range=800,RangeValue=0.440)
    OpticalRanges(5)=(Range=1000,RangeValue=0.449)
    OpticalRanges(6)=(Range=1200,RangeValue=0.459)
    OpticalRanges(7)=(Range=1400,RangeValue=0.469)
    OpticalRanges(8)=(Range=1600,RangeValue=0.483)
    OpticalRanges(9)=(Range=1800,RangeValue=0.497)
    OpticalRanges(10)=(Range=2000,RangeValue=0.511)
    OpticalRanges(11)=(Range=2200,RangeValue=0.526)
    OpticalRanges(12)=(Range=2400,RangeValue=0.542)
    OpticalRanges(13)=(Range=2600,RangeValue=0.560)
    OpticalRanges(14)=(Range=2800,RangeValue=0.5785)
    OpticalRanges(15)=(Range=3000,RangeValue=0.596)
    OpticalRanges(16)=(Range=3200,RangeValue=0.616)
    OpticalRanges(17)=(Range=3400,RangeValue=0.638)
    OpticalRanges(18)=(Range=3600,RangeValue=0.660)
    OpticalRanges(19)=(Range=3800,RangeValue=0.680)
    OpticalRanges(20)=(Range=4000,RangeValue=0.703)
    OpticalRanges(21)=(Range=4200,RangeValue=0.725)
    OpticalRanges(22)=(Range=4400,RangeValue=0.746)
    OpticalRanges(23)=(Range=4600,RangeValue=0.768)
    OpticalRanges(24)=(Range=4800,RangeValue=0.791)
    OpticalRanges(25)=(Range=5000,RangeValue=0.813)

    bMechanicalAiming=true // this cannon doesn't actually have mechanical aiming, but this is a fudge to adjust for sight markings that are 'out'
    MechanicalRanges(1)=(Range=200,RangeValue=-8.0)
    MechanicalRanges(2)=(Range=400,RangeValue=-7.0)
    MechanicalRanges(3)=(Range=600,RangeValue=-6.0)
    MechanicalRanges(4)=(Range=800,RangeValue=5.0)
    MechanicalRanges(5)=(Range=1000,RangeValue=10.0)
    MechanicalRanges(6)=(Range=1200,RangeValue=20.0)
    MechanicalRanges(7)=(Range=1400,RangeValue=30.0)
    MechanicalRanges(8)=(Range=1600,RangeValue=48.0) // can only set up to here
    MechanicalRanges(9)=(Range=5000,RangeValue=48.0)
}

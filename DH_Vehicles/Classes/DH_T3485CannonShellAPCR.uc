//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_T3485CannonShellAPCR extends DHCannonShellAPDS;

defaultproperties
{
    RoundType=RT_APDS
    Speed=47797.0 // 792 m/s
    MaxSpeed=47797.0
    ShellDiameter=5.7 //sub-caliber round
    BallisticCoefficient=2.0 //TODO: find correct BC

    //Damage
    ImpactDamage=410 // just a tungsten slug; no explosive filler
    ShellImpactDamage=class'DH_Engine.DHShellSubCalibreImpactDamageType'
    HullFireChance=0.28
    EngineFireChance=0.58

    //Effects
    CoronaClass=class'DH_Effects.DHShellTracer_Green'
    ShellTrailClass=class'DH_Effects.DHShellTrail_Green'

    //Penetration
    DHPenetrationTable(0)=17.5 // 100m
    DHPenetrationTable(1)=15.9 // 250m
    DHPenetrationTable(2)=13.6 // 500m
    DHPenetrationTable(3)=11.7
    DHPenetrationTable(4)=10.0  // 1000m
    DHPenetrationTable(5)=8.5
    DHPenetrationTable(6)=7.3  // 1500m
    DHPenetrationTable(7)=6.6
    DHPenetrationTable(8)=5.4  // 2000m
    DHPenetrationTable(9)=3.9
    DHPenetrationTable(10)=2.9 // 3000m

    //Gunsight adjustments
    bMechanicalAiming=true
    MechanicalRanges(0)=(Range=0,RangeValue=0.0)
    MechanicalRanges(1)=(Range=400,RangeValue=33.0)
    MechanicalRanges(2)=(Range=500,RangeValue=41.0)
    MechanicalRanges(3)=(Range=600,RangeValue=52.0)
    MechanicalRanges(4)=(Range=700,RangeValue=61.0)
    MechanicalRanges(5)=(Range=800,RangeValue=72.0)
    MechanicalRanges(6)=(Range=900,RangeValue=81.0)
    MechanicalRanges(7)=(Range=1000,RangeValue=92.0)
    MechanicalRanges(8)=(Range=1200,RangeValue=113.0)
    MechanicalRanges(9)=(Range=1400,RangeValue=137.0)
    MechanicalRanges(10)=(Range=1600,RangeValue=161.0)
    MechanicalRanges(11)=(Range=1800,RangeValue=188.0)
    MechanicalRanges(12)=(Range=2000,RangeValue=216.0)
    MechanicalRanges(13)=(Range=2200,RangeValue=245.0)
    MechanicalRanges(14)=(Range=2400,RangeValue=277.0)
    MechanicalRanges(15)=(Range=2600,RangeValue=309.0)
    MechanicalRanges(16)=(Range=2800,RangeValue=341.0) // estimates from here on as these extreme ranges are largely theoretical
    MechanicalRanges(17)=(Range=3000,RangeValue=373.0)
    MechanicalRanges(18)=(Range=3200,RangeValue=405.0)
    MechanicalRanges(19)=(Range=3400,RangeValue=437.0)
    MechanicalRanges(20)=(Range=3600,RangeValue=469.0)
    MechanicalRanges(21)=(Range=3800,RangeValue=501.0)

    // For this gunsight, the moving optical bar is just a visual range indicator on the side; it doesn't actually alter the aiming point
    bOpticalAiming=true
    OpticalRanges(0)=(Range=0,RangeValue=0.374)
    OpticalRanges(1)=(Range=400,RangeValue=0.3615)
    OpticalRanges(2)=(Range=500,RangeValue=0.354)
    OpticalRanges(3)=(Range=600,RangeValue=0.348)
    OpticalRanges(4)=(Range=700,RangeValue=0.341)
    OpticalRanges(5)=(Range=800,RangeValue=0.3345)
    OpticalRanges(6)=(Range=900,RangeValue=0.328)
    OpticalRanges(7)=(Range=1000,RangeValue=0.3215)
    OpticalRanges(8)=(Range=1200,RangeValue=0.308)
    OpticalRanges(9)=(Range=1400,RangeValue=0.296)
    OpticalRanges(10)=(Range=1600,RangeValue=0.283)
    OpticalRanges(11)=(Range=1800,RangeValue=0.270)
    OpticalRanges(12)=(Range=2000,RangeValue=0.257)
    OpticalRanges(13)=(Range=2200,RangeValue=0.244)
    OpticalRanges(14)=(Range=2400,RangeValue=0.231)
    OpticalRanges(15)=(Range=2600,RangeValue=0.218)
    OpticalRanges(16)=(Range=2800,RangeValue=0.205)
    OpticalRanges(17)=(Range=3000,RangeValue=0.192)
    OpticalRanges(18)=(Range=3200,RangeValue=0.179)
    OpticalRanges(19)=(Range=3400,RangeValue=0.166)
    OpticalRanges(20)=(Range=3600,RangeValue=0.153)
    OpticalRanges(21)=(Range=3800,RangeValue=0.140)
}

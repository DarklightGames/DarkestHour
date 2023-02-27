//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_T3476CannonShell extends DHSovietCannonShell;  //BR-350B

defaultproperties
{
    RoundType=RT_APBC
    Speed=39953.0 // 662 m/s
    MaxSpeed=39953.0
    ShellDiameter=7.62
    BallisticCoefficient=1.55 //TODO: pls, check

    //Damage
    ImpactDamage=670  //109 gramms TNT filler
    ShellImpactDamage=class'DH_Vehicles.DH_ShermanCannonShellDamageAP'
    HullFireChance=0.55
    EngineFireChance=0.91

    //Penetration
    DHPenetrationTable(0)=8.2  // 100m (all penetration from Bird & Livingstone, for 662 m/s muzzle velocity, in between rolled homogenous and face hardened armor)
    DHPenetrationTable(1)=7.9  // 250m
    DHPenetrationTable(2)=7.4  // 500m
    DHPenetrationTable(3)=7.1
    DHPenetrationTable(4)=6.7  // 1000m
    DHPenetrationTable(5)=6.4
    DHPenetrationTable(6)=6.0  // 1500m
    DHPenetrationTable(7)=5.6
    DHPenetrationTable(8)=5.3  // 2000m
    DHPenetrationTable(9)=4.7
    DHPenetrationTable(10)=4.2 // 3000m

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

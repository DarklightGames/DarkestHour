//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_ZiS3CannonShell extends DHSovietCannonShell;

defaultproperties
{
    RoundType=RT_APBC
    Speed=39953.0 // 662 m/s
    MaxSpeed=39953.0
    ShellDiameter=7.62
    BallisticCoefficient=1.55 //TODO: pls, check

    //Damage
    ImpactDamage=660  //109 gramms TNT filler
    ShellImpactDamage=class'DH_Vehicles.DH_ShermanCannonShellDamageAP'
    HullFireChance=0.55
    EngineFireChance=0.91

    //Penetration
    DHPenetrationTable(0)=8.4  // 100m (all same as T34/76)
    DHPenetrationTable(1)=8.1  // 250m
    DHPenetrationTable(2)=7.6  // 500m
    DHPenetrationTable(3)=7.2
    DHPenetrationTable(4)=6.7  // 1000m
    DHPenetrationTable(5)=6.4
    DHPenetrationTable(6)=6.0  // 1500m
    DHPenetrationTable(7)=5.6
    DHPenetrationTable(8)=5.3  // 2000m
    DHPenetrationTable(9)=4.7
    DHPenetrationTable(10)=4.2 // 3000m

    //Gunsight adjustments
    bMechanicalAiming=true
    MechanicalRanges(1)=(Range=200,RangeValue=47.0)
    MechanicalRanges(2)=(Range=400,RangeValue=63.0)
    MechanicalRanges(3)=(Range=600,RangeValue=87.0)
    MechanicalRanges(4)=(Range=800,RangeValue=115.0)
    MechanicalRanges(5)=(Range=1000,RangeValue=147.0)
    MechanicalRanges(6)=(Range=1200,RangeValue=183.0)
    MechanicalRanges(7)=(Range=1400,RangeValue=220.0)
    MechanicalRanges(8)=(Range=1600,RangeValue=260.0)
    MechanicalRanges(9)=(Range=1800,RangeValue=307.0)
    MechanicalRanges(10)=(Range=2000,RangeValue=355.0)
    MechanicalRanges(11)=(Range=2200,RangeValue=408.0)
    MechanicalRanges(12)=(Range=2400,RangeValue=467.0)
    MechanicalRanges(13)=(Range=2600,RangeValue=528.0)
    MechanicalRanges(14)=(Range=2800,RangeValue=589.0) // estimates from here on as these extreme ranges are largely theoretical
    MechanicalRanges(15)=(Range=3000,RangeValue=650.0)
    MechanicalRanges(16)=(Range=3200,RangeValue=711.0)
    MechanicalRanges(17)=(Range=3400,RangeValue=772.0)
    MechanicalRanges(18)=(Range=3600,RangeValue=833.0)
    MechanicalRanges(19)=(Range=3800,RangeValue=894.0)
    MechanicalRanges(20)=(Range=4000,RangeValue=955.0)
}

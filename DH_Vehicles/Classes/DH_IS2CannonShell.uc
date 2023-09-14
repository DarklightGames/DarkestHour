//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_IS2CannonShell extends DHSovietCannonShell;

defaultproperties
{
    Speed=47073.0 // 780 m/s
    MaxSpeed=47073.0
    ShellDiameter=12.2
    BallisticCoefficient=2.3

    //Damage
    ImpactDamage=1800  //156 gramms TNT filler, extreme kinetic energy
    Damage=600 //going to treat this like a medium HE shell when it impacts the ground
    HullFireChance=1.0 //extremely powerful shell, anything that gets penetrated dies or gets severely crippled
    EngineFireChance=1.0

    //Effects
    StaticMesh=StaticMesh'WeaponPickupSM.Ammo.122mm_Shell'

    //Penetration - BR-471 (uncapped)
    DHPenetrationTable(0)=17.4  // 100m
    DHPenetrationTable(1)=16.8  // 250m
    DHPenetrationTable(2)=15.8  // 500m
    DHPenetrationTable(3)=14.9
    DHPenetrationTable(4)=14.0  // 1000m
    DHPenetrationTable(5)=13.2
    DHPenetrationTable(6)=12.5  // 1500m
    DHPenetrationTable(7)=11.8
    DHPenetrationTable(8)=11.1 // 2000m
    DHPenetrationTable(9)=9.8
    DHPenetrationTable(10)=8.7  // 3000m

    bMechanicalAiming=true
    MechanicalRanges(0)=(Range=0,RangeValue=0.0)
    MechanicalRanges(1)=(Range=400,RangeValue=36.0)
    MechanicalRanges(2)=(Range=500,RangeValue=45.0)
    MechanicalRanges(3)=(Range=600,RangeValue=54.0)
    MechanicalRanges(4)=(Range=700,RangeValue=64.0)
    MechanicalRanges(5)=(Range=800,RangeValue=73.0)
    MechanicalRanges(6)=(Range=900,RangeValue=84.0)
    MechanicalRanges(7)=(Range=1000,RangeValue=93.0)
    MechanicalRanges(8)=(Range=1200,RangeValue=116.0)
    MechanicalRanges(9)=(Range=1400,RangeValue=137.0)
    MechanicalRanges(10)=(Range=1600,RangeValue=161.0)
    MechanicalRanges(11)=(Range=1800,RangeValue=188.0)
    MechanicalRanges(12)=(Range=2000,RangeValue=213.0)
    MechanicalRanges(13)=(Range=2200,RangeValue=241.0)
    MechanicalRanges(14)=(Range=2400,RangeValue=272.0)
    MechanicalRanges(15)=(Range=2600,RangeValue=304.0)
    MechanicalRanges(16)=(Range=2800,RangeValue=336.0) // estimates from here on as these extreme ranges are largely theoretical
    MechanicalRanges(17)=(Range=3000,RangeValue=368.0)
    MechanicalRanges(18)=(Range=3200,RangeValue=400.0)
    MechanicalRanges(19)=(Range=3400,RangeValue=432.0)
    MechanicalRanges(20)=(Range=3600,RangeValue=464.0)
    MechanicalRanges(21)=(Range=3800,RangeValue=496.0)
    MechanicalRanges(22)=(Range=4000,RangeValue=528.0)
    MechanicalRanges(23)=(Range=4200,RangeValue=560.0)
    MechanicalRanges(24)=(Range=4400,RangeValue=592.0)
    MechanicalRanges(25)=(Range=4600,RangeValue=624.0)
    MechanicalRanges(26)=(Range=4800,RangeValue=656.0)
    MechanicalRanges(27)=(Range=5000,RangeValue=688.0)
    MechanicalRanges(28)=(Range=5200,RangeValue=720.0)

    bOpticalAiming=true // just a visual range indicator on the side; doesn't actually alter the aiming point
    OpticalRanges(0)=(Range=0,RangeValue=0.420)
    OpticalRanges(1)=(Range=400,RangeValue=0.397)
    OpticalRanges(2)=(Range=500,RangeValue=0.391)
    OpticalRanges(3)=(Range=600,RangeValue=0.385)
    OpticalRanges(4)=(Range=700,RangeValue=0.379)
    OpticalRanges(5)=(Range=800,RangeValue=0.373)
    OpticalRanges(6)=(Range=900,RangeValue=0.367)
    OpticalRanges(7)=(Range=1000,RangeValue=0.361)
    OpticalRanges(8)=(Range=1200,RangeValue=0.349)
    OpticalRanges(9)=(Range=1400,RangeValue=0.337)
    OpticalRanges(10)=(Range=1600,RangeValue=0.325)
    OpticalRanges(11)=(Range=1800,RangeValue=0.313)
    OpticalRanges(12)=(Range=2000,RangeValue=0.301)
    OpticalRanges(13)=(Range=2200,RangeValue=0.289)
    OpticalRanges(14)=(Range=2400,RangeValue=0.277)
    OpticalRanges(15)=(Range=2600,RangeValue=0.265)
    OpticalRanges(16)=(Range=2800,RangeValue=0.253)
    OpticalRanges(17)=(Range=3000,RangeValue=0.241)
    OpticalRanges(18)=(Range=3200,RangeValue=0.229)
    OpticalRanges(19)=(Range=3400,RangeValue=0.217)
    OpticalRanges(20)=(Range=3600,RangeValue=0.205)
    OpticalRanges(21)=(Range=3800,RangeValue=0.193)
    OpticalRanges(22)=(Range=4000,RangeValue=0.181)
    OpticalRanges(23)=(Range=4200,RangeValue=0.169)
    OpticalRanges(24)=(Range=4400,RangeValue=0.157)
    OpticalRanges(25)=(Range=4600,RangeValue=0.145)
    OpticalRanges(26)=(Range=4800,RangeValue=0.133)
    OpticalRanges(27)=(Range=5000,RangeValue=0.121)
    OpticalRanges(28)=(Range=5200,RangeValue=0.109)
}

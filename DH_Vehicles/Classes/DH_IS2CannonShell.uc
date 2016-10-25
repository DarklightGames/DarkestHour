//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_IS2CannonShell extends DHCannonShellAPBC;

defaultproperties
{
    ShellDiameter=12.2
    BallisticCoefficient=2.3
    Speed=47073.0 // 780 m/s
    MaxSpeed=47073.0
    ImpactDamage=900
    Tag="" // TODO
    StaticMesh=StaticMesh'WeaponPickupSM.Ammo.122mm_Shell'

    DHPenetrationTable(0)=22.7  // 100m // TODO: set these
    DHPenetrationTable(1)=22.0  // 250m
    DHPenetrationTable(2)=21.4  // 500m
    DHPenetrationTable(3)=20.8
    DHPenetrationTable(4)=20.1  // 1000m
    DHPenetrationTable(5)=19.5
    DHPenetrationTable(6)=18.9  // 1500m
    DHPenetrationTable(7)=18.3
    DHPenetrationTable(8)=17.7  // 2000m
    DHPenetrationTable(9)=16.6
    DHPenetrationTable(10)=15.5 // 3000m

    bMechanicalAiming=true
    MechanicalRanges(0)=(Range=0,RangeValue=0)
    MechanicalRanges(1)=(Range=400,RangeValue=38)
    MechanicalRanges(2)=(Range=500,RangeValue=45)
    MechanicalRanges(3)=(Range=600,RangeValue=57)
    MechanicalRanges(4)=(Range=700,RangeValue=65)
    MechanicalRanges(5)=(Range=800,RangeValue=77)
    MechanicalRanges(6)=(Range=900,RangeValue=85)
    MechanicalRanges(7)=(Range=1000,RangeValue=96)
    MechanicalRanges(8)=(Range=1200,RangeValue=118)
    MechanicalRanges(9)=(Range=1400,RangeValue=143)
    MechanicalRanges(10)=(Range=1600,RangeValue=172)
    MechanicalRanges(11)=(Range=1800,RangeValue=200)
    MechanicalRanges(12)=(Range=2000,RangeValue=227)
    MechanicalRanges(13)=(Range=2200,RangeValue=253)
    MechanicalRanges(14)=(Range=2400,RangeValue=282)
    MechanicalRanges(15)=(Range=2600,RangeValue=318)
    MechanicalRanges(16)=(Range=2800,RangeValue=350)
    MechanicalRanges(17)=(Range=3000,RangeValue=389)
    MechanicalRanges(18)=(Range=3200,RangeValue=430)
    MechanicalRanges(19)=(Range=3400,RangeValue=468)
    MechanicalRanges(20)=(Range=3600,RangeValue=512)
    MechanicalRanges(21)=(Range=3800,RangeValue=563)
    MechanicalRanges(22)=(Range=4000,RangeValue=610)
    MechanicalRanges(23)=(Range=4200,RangeValue=660) // estimates from here on as these extreme ranges are largely theoretical
    MechanicalRanges(24)=(Range=4400,RangeValue=710)
    MechanicalRanges(25)=(Range=4600,RangeValue=770)
    MechanicalRanges(26)=(Range=4800,RangeValue=830)
    MechanicalRanges(27)=(Range=5000,RangeValue=900)
    MechanicalRanges(28)=(Range=5200,RangeValue=970)

    bOpticalAiming=true // just a visual range indicator on the side; doesn't actually alter the aiming point
    OpticalRanges(0)=(Range=0,RangeValue=0.42)
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

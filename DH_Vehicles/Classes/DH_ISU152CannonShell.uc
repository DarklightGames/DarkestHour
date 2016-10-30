//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_ISU152CannonShell extends DHCannonShellAP;

defaultproperties
{
    ShellDiameter=15.2
    BallisticCoefficient=4.4
    Speed=36211.0 // 600 m/s
    MaxSpeed=36211.0
    ImpactDamage=3500
    Tag="BR-540" // AP round without ballistic cap
    StaticMesh=StaticMesh'WeaponPickupSM.shells.122mm_shell'

    DHPenetrationTable(0)=12.5 // 100m
    DHPenetrationTable(1)=12.5 // 250m
    DHPenetrationTable(2)=12.5 // 500m
    DHPenetrationTable(3)=12.0
    DHPenetrationTable(4)=11.5 // 1000m
    DHPenetrationTable(5)=11.0
    DHPenetrationTable(6)=10.5 // 1500m
    DHPenetrationTable(7)=9.75
    DHPenetrationTable(8)=9.0  // 2000m
    DHPenetrationTable(9)=7.5
    DHPenetrationTable(10)=6.0 // 3000m

    bOpticalAiming=true
    OpticalRanges(0)=(Range=0,RangeValue=0.411)
    OpticalRanges(1)=(Range=100,RangeValue=0.414)
    OpticalRanges(2)=(Range=200,RangeValue=0.418)
    OpticalRanges(3)=(Range=300,RangeValue=0.4205)
    OpticalRanges(4)=(Range=400,RangeValue=0.423)
    OpticalRanges(5)=(Range=500,RangeValue=0.427)
    OpticalRanges(6)=(Range=600,RangeValue=0.43)
    OpticalRanges(7)=(Range=700,RangeValue=0.434)
    OpticalRanges(8)=(Range=800,RangeValue=0.4375)
    OpticalRanges(9)=(Range=900,RangeValue=0.442)
    OpticalRanges(10)=(Range=1000,RangeValue=0.446)
    OpticalRanges(11)=(Range=1200,RangeValue=0.454)
    OpticalRanges(12)=(Range=1400,RangeValue=0.4635)
    OpticalRanges(13)=(Range=1600,RangeValue=0.4745)
    OpticalRanges(14)=(Range=1800,RangeValue=0.4875)
    OpticalRanges(15)=(Range=2000,RangeValue=0.5)
    OpticalRanges(16)=(Range=2200,RangeValue=0.513)
    OpticalRanges(17)=(Range=2400,RangeValue=0.527)
    OpticalRanges(18)=(Range=2600,RangeValue=0.542)
    OpticalRanges(19)=(Range=2800,RangeValue=0.5578)
    OpticalRanges(20)=(Range=3000,RangeValue=0.5745)
    OpticalRanges(21)=(Range=3200,RangeValue=0.592)
    OpticalRanges(22)=(Range=3400,RangeValue=0.612)
    OpticalRanges(23)=(Range=3600,RangeValue=0.629)
    OpticalRanges(24)=(Range=3800,RangeValue=0.6487)
    OpticalRanges(25)=(Range=4000,RangeValue=0.6675)
    OpticalRanges(26)=(Range=4200,RangeValue=0.6877)
    OpticalRanges(27)=(Range=4400,RangeValue=0.7064)
    OpticalRanges(28)=(Range=4600,RangeValue=0.726)
    OpticalRanges(29)=(Range=4800,RangeValue=0.7454)
    OpticalRanges(30)=(Range=5000,RangeValue=0.7657)
    OpticalRanges(31)=(Range=5200,RangeValue=0.786)
    OpticalRanges(32)=(Range=5400,RangeValue=0.805)

    bMechanicalAiming=true
    MechanicalRanges(1)=(Range=100,RangeValue=-1.0)
    MechanicalRanges(2)=(Range=200,RangeValue=-2.0)
    MechanicalRanges(3)=(Range=300,RangeValue=-3.0)
    MechanicalRanges(4)=(Range=400,RangeValue=-4.0)
    MechanicalRanges(5)=(Range=500,RangeValue=-5.0)
    MechanicalRanges(6)=(Range=600,RangeValue=-6.0)
    MechanicalRanges(7)=(Range=700,RangeValue=-7.0)
    MechanicalRanges(8)=(Range=800,RangeValue=-8.0)
    MechanicalRanges(9)=(Range=900,RangeValue=-9.0)
    MechanicalRanges(10)=(Range=1000,RangeValue=-10.0)
    MechanicalRanges(11)=(Range=1200,RangeValue=-12.0)
    MechanicalRanges(12)=(Range=1400,RangeValue=-14.0)
    MechanicalRanges(13)=(Range=1600,RangeValue=-16.0)
    MechanicalRanges(14)=(Range=1800,RangeValue=-18.0)
    MechanicalRanges(15)=(Range=2000,RangeValue=-20.0)
    MechanicalRanges(16)=(Range=2200,RangeValue=-22.0)
    MechanicalRanges(17)=(Range=2400,RangeValue=-24.0)
    MechanicalRanges(18)=(Range=2600,RangeValue=-26.0)
    MechanicalRanges(19)=(Range=2800,RangeValue=-28.0)
    MechanicalRanges(20)=(Range=3000,RangeValue=-30.0)
    MechanicalRanges(21)=(Range=3200,RangeValue=-32.0)
    MechanicalRanges(22)=(Range=3400,RangeValue=-34.0)
    MechanicalRanges(23)=(Range=3600,RangeValue=-36.0)
    MechanicalRanges(24)=(Range=3800,RangeValue=-38.0)
    MechanicalRanges(25)=(Range=4000,RangeValue=-40.0)
    MechanicalRanges(26)=(Range=4200,RangeValue=-42.0)
    MechanicalRanges(27)=(Range=4400,RangeValue=-44.0)
    MechanicalRanges(28)=(Range=4600,RangeValue=-46.0)
    MechanicalRanges(29)=(Range=4800,RangeValue=-48.0)
    MechanicalRanges(30)=(Range=5000,RangeValue=-50.0)
    MechanicalRanges(31)=(Range=5200,RangeValue=-52.0)
    MechanicalRanges(32)=(Range=5400,RangeValue=-54.0)
}

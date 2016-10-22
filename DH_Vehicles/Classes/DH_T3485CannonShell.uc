//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_T3485CannonShell extends DHCannonShellAPBC;

defaultproperties
{
    ShellDiameter=8.5
    BallisticCoefficient=2.0
    Speed=47797.0 // 792 m/s
    MaxSpeed=47797.0
    ImpactDamage=700 // 400 in RO, but have made closer to a tiger's shell (775), as is almost same speed & calibre
    ShellImpactDamage=class'DH_Vehicles.DH_ShermanM4A176WCannonShellDamageAP'
    Tag="BR-365"
    bMechanicalAiming=true
    bOpticalAiming=true // just a visual range indicator on the side; doesn't actually alter the aiming point

    DHPenetrationTable(0)=12.6 // 100m
    DHPenetrationTable(1)=12.0 // 250m
    DHPenetrationTable(2)=11.0 // 500m
    DHPenetrationTable(3)=10.25
    DHPenetrationTable(4)=9.5  // 1000m
    DHPenetrationTable(5)=8.5
    DHPenetrationTable(6)=7.5  // 1500m
    DHPenetrationTable(7)=7.0
    DHPenetrationTable(8)=6.5  // 2000m
    DHPenetrationTable(9)=5.5
    DHPenetrationTable(10)=4.5 // 3000m

    OpticalRanges(0)=(Range=0,RangeValue=0.369)
    OpticalRanges(1)=(Range=400,RangeValue=0.3565)
    OpticalRanges(2)=(Range=500,RangeValue=0.349)
    OpticalRanges(3)=(Range=600,RangeValue=0.343)
    OpticalRanges(4)=(Range=700,RangeValue=0.336)
    OpticalRanges(5)=(Range=800,RangeValue=0.3295)
    OpticalRanges(6)=(Range=900,RangeValue=0.323)
    OpticalRanges(7)=(Range=1000,RangeValue=0.3165)
    OpticalRanges(8)=(Range=1200,RangeValue=0.303)
    OpticalRanges(9)=(Range=1400,RangeValue=0.291)
    OpticalRanges(10)=(Range=1600,RangeValue=0.278)
    OpticalRanges(11)=(Range=1800,RangeValue=0.265)
    OpticalRanges(12)=(Range=2000,RangeValue=0.252)
    OpticalRanges(13)=(Range=2200,RangeValue=0.239)
    OpticalRanges(14)=(Range=2400,RangeValue=0.226)
    OpticalRanges(15)=(Range=2600,RangeValue=0.213)
    OpticalRanges(16)=(Range=2800,RangeValue=0.200)
    OpticalRanges(17)=(Range=3000,RangeValue=0.187)
    OpticalRanges(18)=(Range=3200,RangeValue=0.174)
    OpticalRanges(19)=(Range=3400,RangeValue=0.161)
    OpticalRanges(20)=(Range=3600,RangeValue=0.148)
    OpticalRanges(21)=(Range=3800,RangeValue=0.135)

    MechanicalRanges(0)=(Range=0,RangeValue=0)
    MechanicalRanges(1)=(Range=400,RangeValue=35)
    MechanicalRanges(2)=(Range=500,RangeValue=45)
    MechanicalRanges(3)=(Range=600,RangeValue=55)
    MechanicalRanges(4)=(Range=700,RangeValue=65)
    MechanicalRanges(5)=(Range=800,RangeValue=75)
    MechanicalRanges(6)=(Range=900,RangeValue=85)
    MechanicalRanges(7)=(Range=1000,RangeValue=96)
    MechanicalRanges(8)=(Range=1200,RangeValue=117)
    MechanicalRanges(9)=(Range=1400,RangeValue=139)
    MechanicalRanges(10)=(Range=1600,RangeValue=168)
    MechanicalRanges(11)=(Range=1800,RangeValue=198)
    MechanicalRanges(12)=(Range=2000,RangeValue=224)
    MechanicalRanges(13)=(Range=2200,RangeValue=253)
    MechanicalRanges(14)=(Range=2400,RangeValue=287)
    MechanicalRanges(15)=(Range=2600,RangeValue=324)
    MechanicalRanges(16)=(Range=2800,RangeValue=362)
    MechanicalRanges(17)=(Range=3000,RangeValue=399)
    MechanicalRanges(18)=(Range=3200,RangeValue=445)
    MechanicalRanges(19)=(Range=3400,RangeValue=491)
    MechanicalRanges(20)=(Range=3600,RangeValue=536)
    MechanicalRanges(21)=(Range=3800,RangeValue=588)
}

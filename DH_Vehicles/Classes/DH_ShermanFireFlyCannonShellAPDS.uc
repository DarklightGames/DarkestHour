//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_ShermanFireFlyCannonShellAPDS extends DH_ROTankCannonShellAPDS;

defaultproperties
{
    MechanicalRanges(0)=(RangeValue=32.0)
    MechanicalRanges(1)=(Range=200,RangeValue=36.0)
    MechanicalRanges(2)=(Range=400,RangeValue=40.0)
    MechanicalRanges(3)=(Range=600,RangeValue=44.0)
    MechanicalRanges(4)=(Range=800,RangeValue=60.0)
    MechanicalRanges(5)=(Range=1000,RangeValue=80.0)
    MechanicalRanges(6)=(Range=1200,RangeValue=104.0)
    MechanicalRanges(7)=(Range=1400,RangeValue=124.0)
    MechanicalRanges(8)=(Range=1600,RangeValue=148.0)
    MechanicalRanges(9)=(Range=1800,RangeValue=168.0)
    MechanicalRanges(10)=(Range=2000,RangeValue=184.0)
    MechanicalRanges(11)=(Range=2400,RangeValue=224.0)
    MechanicalRanges(12)=(Range=2800,RangeValue=264.0)
    MechanicalRanges(13)=(Range=3200,RangeValue=304.0)
    MechanicalRanges(14)=(Range=3600,RangeValue=344.0)
    MechanicalRanges(15)=(Range=4000,RangeValue=392.0)
    bMechanicalAiming=true
    DHPenetrationTable(0)=27.5
    DHPenetrationTable(1)=26.799999
    DHPenetrationTable(2)=25.6
    DHPenetrationTable(3)=23.200001
    DHPenetrationTable(4)=21.6
    DHPenetrationTable(5)=17.200001
    DHPenetrationTable(6)=16.700001
    DHPenetrationTable(7)=15.9
    DHPenetrationTable(8)=15.1
    DHPenetrationTable(9)=14.0
    DHPenetrationTable(10)=12.7
    ShellDiameter=5.7
    ShellImpactDamage=class'DH_Vehicles.DH_ShermanFireFlyCannonShellDamageAPDS'
    BallisticCoefficient=1.47
    SpeedFudgeScale=0.4
    Speed=77492.0
    MaxSpeed=77492.0
    Tag="Mk.I APDS"
}

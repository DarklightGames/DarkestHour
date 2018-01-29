//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DH_ShermanFireFlyCannonShellHE extends DHCannonShellHE;

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
    DHPenetrationTable(0)=4.5
    DHPenetrationTable(1)=4.2
    DHPenetrationTable(2)=3.8
    DHPenetrationTable(3)=3.2
    DHPenetrationTable(4)=2.9
    DHPenetrationTable(5)=2.4
    DHPenetrationTable(6)=2.0
    DHPenetrationTable(7)=1.7
    DHPenetrationTable(8)=1.3
    DHPenetrationTable(9)=1.1
    DHPenetrationTable(10)=1.0
    ShellDiameter=7.62
    bHasTracer=true
    PenetrationMag=880.0
    ImpactDamage=450
    BallisticCoefficient=2.45
    Speed=53351.0
    MaxSpeed=53351.0
    Damage=400.0
    DamageRadius=1140.0
    Tag="Mk.I HE-T"
}

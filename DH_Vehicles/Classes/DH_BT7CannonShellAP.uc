//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_BT7CannonShellAP extends DHCannonShellAP;

defaultproperties
{
    ShellDiameter=4.5
    BallisticCoefficient=1.12
    Speed=45806.0 // 759 m/s
    MaxSpeed=45806.0
    ImpactDamage=350
    ShellImpactDamage=class'DH_Vehicles.DH_BT7CannonShellDamageAP'
    Tag="BR-240"
    bMechanicalAiming=true
    StaticMesh=StaticMesh'DH_Tracers.shells.Soviet_shell'
    CoronaClass=class'DH_Effects.DHShellTracer_Green'

    DHPenetrationTable(0)=5.5
    DHPenetrationTable(1)=4.7
    DHPenetrationTable(2)=3.9
    DHPenetrationTable(3)=3.3
    DHPenetrationTable(4)=2.7
    DHPenetrationTable(5)=2.2
    DHPenetrationTable(6)=1.9
    DHPenetrationTable(7)=1.5
    DHPenetrationTable(8)=1.3
    DHPenetrationTable(9)=1.0
    DHPenetrationTable(10)=0.7

    MechanicalRanges(0)=(Range=0,RangeValue=0)
    MechanicalRanges(1)=(Range=250,RangeValue=0)
    MechanicalRanges(2)=(Range=500,RangeValue=0)
    MechanicalRanges(3)=(Range=750,RangeValue=0)
    MechanicalRanges(4)=(Range=1000,RangeValue=0)
    MechanicalRanges(5)=(Range=1500,RangeValue=0)
    MechanicalRanges(6)=(Range=2000,RangeValue=0)
    MechanicalRanges(7)=(Range=2500,RangeValue=0)

    OpticalRanges(0)=(Range=0,RangeValue=0.48)
    OpticalRanges(1)=(Range=250,RangeValue=0.496)
    OpticalRanges(2)=(Range=500,RangeValue=0.512)
    OpticalRanges(3)=(Range=750,RangeValue=0.540) // guess
    OpticalRanges(4)=(Range=1000,RangeValue=0.5426)
    OpticalRanges(5)=(Range=1500,RangeValue=0.5885)
    OpticalRanges(6)=(Range=2000,RangeValue=0.6441)
    OpticalRanges(7)=(Range=2500,RangeValue=0.7053)
}

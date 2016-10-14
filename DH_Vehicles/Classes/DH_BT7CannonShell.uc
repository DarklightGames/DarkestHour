//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_BT7CannonShell extends DHCannonShellAPBC;

defaultproperties
{
    ShellDiameter=4.5
    BallisticCoefficient=1.12
    Speed=45806 // 759 m/s
    MaxSpeed=45806
    ImpactDamage=350
    ShellImpactDamage=class'DH_Vehicles.DH_BT7CannonShellDamageAPC'
    Tag="BR-240SP"
    bMechanicalAiming=true
    StaticMesh=StaticMesh'DH_Tracers.shells.Soviet_shell'
    CoronaClass=class'DH_Effects.DHShellTracer_Green'

    DHPenetrationTable(0)=5.5
    DHPenetrationTable(1)=5.1
    DHPenetrationTable(2)=4.6
    DHPenetrationTable(3)=4.2
    DHPenetrationTable(4)=3.8
    DHPenetrationTable(5)=3.5
    DHPenetrationTable(6)=3.1
    DHPenetrationTable(7)=2.8
    DHPenetrationTable(8)=2.5
    DHPenetrationTable(9)=1.9
    DHPenetrationTable(10)=1.3

    // TODO: null values are pointless, as no adjustment (same in all BT7 shells)
    MechanicalRanges(0)=(Range=0,RangeValue=0)
    MechanicalRanges(1)=(Range=250,RangeValue=0)
    MechanicalRanges(2)=(Range=500,RangeValue=0)
    MechanicalRanges(3)=(Range=750,RangeValue=0)
    MechanicalRanges(4)=(Range=1000,RangeValue=0)
    MechanicalRanges(5)=(Range=1500,RangeValue=0)
    MechanicalRanges(6)=(Range=2000,RangeValue=0)
    MechanicalRanges(7)=(Range=2500,RangeValue=0)

    // TODO: confirm can delete these as unused
    OpticalRanges(0)=(Range=0,RangeValue=0.48)
    OpticalRanges(1)=(Range=250,RangeValue=0.496)
    OpticalRanges(2)=(Range=500,RangeValue=0.512)
    OpticalRanges(3)=(Range=750,RangeValue=0.540) // guess
    OpticalRanges(4)=(Range=1000,RangeValue=0.5426)
    OpticalRanges(5)=(Range=1500,RangeValue=0.5885)
    OpticalRanges(6)=(Range=2000,RangeValue=0.6441)
    OpticalRanges(7)=(Range=2500,RangeValue=0.7053)
}

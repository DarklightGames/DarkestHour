//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_PanzerIIILCannonShellAPCR extends DHCannonShellHVAP;

defaultproperties
{
    MechanicalRanges(1)=(Range=100,RangeValue=4.0)
    MechanicalRanges(2)=(Range=200,RangeValue=10.0)
    MechanicalRanges(3)=(Range=300,RangeValue=15.0)
    MechanicalRanges(4)=(Range=400,RangeValue=22.0)
    MechanicalRanges(5)=(Range=500,RangeValue=31.0)
    MechanicalRanges(6)=(Range=600,RangeValue=42.0)
    MechanicalRanges(7)=(Range=700,RangeValue=55.0)
    MechanicalRanges(8)=(Range=800,RangeValue=76.0)
    MechanicalRanges(9)=(Range=900,RangeValue=97.0)
    MechanicalRanges(10)=(Range=1000,RangeValue=130.0)
    MechanicalRanges(11)=(Range=1100,RangeValue=167.0)
    MechanicalRanges(12)=(Range=1200,RangeValue=204.0)
    MechanicalRanges(13)=(Range=1300,RangeValue=249.0)
    MechanicalRanges(14)=(Range=1400,RangeValue=293.0)
    MechanicalRanges(15)=(Range=1500,RangeValue=363.0)
    MechanicalRanges(16)=(Range=1600,RangeValue=432.0)
    MechanicalRanges(17)=(Range=1700,RangeValue=515.0)
    MechanicalRanges(18)=(Range=1800,RangeValue=597.0)
    MechanicalRanges(19)=(Range=1900,RangeValue=685.0)
    MechanicalRanges(20)=(Range=2000,RangeValue=772.0)
    bMechanicalAiming=true
    DHPenetrationTable(0)=14.9
    DHPenetrationTable(1)=13.2
    DHPenetrationTable(2)=10.8
    DHPenetrationTable(3)=8.8
    DHPenetrationTable(4)=7.2
    DHPenetrationTable(5)=5.9
    DHPenetrationTable(6)=4.8
    DHPenetrationTable(7)=4.1
    DHPenetrationTable(8)=3.2
    DHPenetrationTable(9)=2.1
    DHPenetrationTable(10)=1.4
    ShellDiameter=5.0
    bIsAlliedShell=false
    CoronaClass=class'DH_Effects.DHShellTracer_Orange'
    ShellImpactDamage=class'DH_Vehicles.DH_PanzerIIILCannonShellDamageAPCR'
    ImpactDamage=325
    BallisticCoefficient=0.95
    SpeedFudgeScale=0.4
    Speed=71313.0
    MaxSpeed=71313.0
    StaticMesh=StaticMesh'DH_Tracers.shells.German_shell'
    Tag="PzGr.40"
}

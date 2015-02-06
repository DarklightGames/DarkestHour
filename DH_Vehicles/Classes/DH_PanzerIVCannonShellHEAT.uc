//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_PanzerIVCannonShellHEAT extends DH_ROTankCannonShellHEAT;

defaultproperties
{
    MechanicalRanges(1)=(Range=100,RangeValue=28.000000)
    MechanicalRanges(2)=(Range=200,RangeValue=40.000000)
    MechanicalRanges(3)=(Range=300,RangeValue=58.000000)
    MechanicalRanges(4)=(Range=400,RangeValue=78.000000)
    MechanicalRanges(5)=(Range=500,RangeValue=94.000000)
    MechanicalRanges(6)=(Range=600,RangeValue=114.000000)
    MechanicalRanges(7)=(Range=700,RangeValue=134.000000)
    MechanicalRanges(8)=(Range=800,RangeValue=154.000000)
    MechanicalRanges(9)=(Range=900,RangeValue=180.000000)
    MechanicalRanges(10)=(Range=1000,RangeValue=200.000000)
    MechanicalRanges(11)=(Range=1100,RangeValue=224.000000)
    MechanicalRanges(12)=(Range=1200,RangeValue=250.000000)
    MechanicalRanges(13)=(Range=1300,RangeValue=274.000000)
    MechanicalRanges(14)=(Range=1400,RangeValue=302.000000)
    MechanicalRanges(15)=(Range=1500,RangeValue=328.000000)
    MechanicalRanges(16)=(Range=1600,RangeValue=352.000000)
    MechanicalRanges(17)=(Range=1700,RangeValue=378.000000)
    MechanicalRanges(18)=(Range=1800,RangeValue=408.000000)
    MechanicalRanges(19)=(Range=1900,RangeValue=438.000000)
    MechanicalRanges(20)=(Range=2000,RangeValue=468.000000)
    MechanicalRanges(21)=(Range=2200,RangeValue=528.000000)
    MechanicalRanges(22)=(Range=2400,RangeValue=588.000000)
    MechanicalRanges(23)=(Range=2600,RangeValue=648.000000)
    MechanicalRanges(24)=(Range=2800,RangeValue=708.000000)
    MechanicalRanges(25)=(Range=3000,RangeValue=768.000000)
    bMechanicalAiming=true
    DHPenetrationTable(0)=10.000000
    DHPenetrationTable(1)=10.000000
    DHPenetrationTable(2)=10.000000
    DHPenetrationTable(3)=10.000000
    DHPenetrationTable(4)=10.000000
    DHPenetrationTable(5)=10.000000
    DHPenetrationTable(6)=10.000000
    DHPenetrationTable(7)=10.000000
    DHPenetrationTable(8)=10.000000
    DHPenetrationTable(9)=10.000000
    DHPenetrationTable(10)=10.000000
    ShellDiameter=7.500000
    bIsAlliedShell=false
    TracerEffect=class'DH_Effects.DH_OrangeTankShellTracer'
    ShellImpactDamage=class'DH_Vehicles.DH_PanzerIVCannonShellImpactDamageHEAT'
    ImpactDamage=650
    BallisticCoefficient=2.100000
    Speed=33073.000000
    MaxSpeed=33073.000000
    Damage=450.000000
    DamageRadius=200.000000
    MyDamageType=class'DH_Vehicles.DH_PanzerIVCannonShellDamageHEAT'
    StaticMesh=StaticMesh'DH_Tracers.shells.German_shell'
    Tag="Gr.38 Hl/C"
}

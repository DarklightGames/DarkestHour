//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_BT7CannonShellAPCR extends DHCannonShellHVAP;

defaultproperties
{
    ShellDiameter=4.5
    BallisticCoefficient=1.12
    Speed=45806 // 759 m/s // TODO: speed must be higher for APCR
    MaxSpeed=45806
    ImpactDamage=350
    ShellImpactDamage=class'DH_Vehicles.DH_BT7CannonShellDamageAPCR'
    Tag="BR-240P"  // APCR shell, available from 1943
    bMechanicalAiming=true
    StaticMesh=StaticMesh'DH_Tracers.shells.Soviet_shell'
    CoronaClass=class'DH_Effects.DHShellTracer_Green'
    ShellShatterEffectClass=class'DH_Effects.DHShellShatterEffect_Small'

    DHPenetrationTable[0]=9.4
    DHPenetrationTable[1]=8.1
    DHPenetrationTable[2]=6.4
    DHPenetrationTable[3]=5.0
    DHPenetrationTable[4]=4.0
    DHPenetrationTable[5]=3.2
    DHPenetrationTable[6]=2.0
    DHPenetrationTable[7]=1.1
    DHPenetrationTable[8]=0.8
    DHPenetrationTable[9]=0.5
    DHPenetrationTable[10]=0.2

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

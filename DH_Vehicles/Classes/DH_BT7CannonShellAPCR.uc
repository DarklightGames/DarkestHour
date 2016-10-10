//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================
// BT7 tank APCR cannon shell class (available 1943)
//==============================================================================
class DH_BT7CannonShellAPCR extends  DHCannonShellHVAP;

defaultproperties
{
    Tag="BR-240P"
    BallisticCoefficient=1.12 //1.67
    Speed=45806 // 759 M/S, (60.35 * 759), using BR-240 SP ( Armor Piercing Ballistic Cap )
    MaxSpeed=45806
    SpeedFudgeScale=0.50
    bDebugBallistics=false
    bMechanicalAiming=True
    ShellDiameter=4.5
    ShellImpactDamage=Class'DH_Vehicles.DH_BT7CannonShellDamageAPCR'
    ImpactDamage=250.0

    //New Penetration Table - based on 0 degree impact
    DHPenetrationTable[0]=9.4     //100
    DHPenetrationTable[1]=8.1     //250
    DHPenetrationTable[2]=6.4     //500
    DHPenetrationTable[3]=5.0     //750
    DHPenetrationTable[4]=4.0     //1000
    DHPenetrationTable[5]=3.2     //1250
    DHPenetrationTable[6]=2.0     //1500
    DHPenetrationTable[7]=1.1     //1750
    DHPenetrationTable[8]=0.8     //2000
    DHPenetrationTable[9]=0.5     //2500
    DHPenetrationTable[10]=0.2    //3000

    //adjusts the range bar // disabled anyway
    OpticalRanges(0)=(Range=0,RangeValue=0.48)
    OpticalRanges(1)=(Range=250,RangeValue=0.496)
    OpticalRanges(2)=(Range=500,RangeValue=0.512)
    OpticalRanges(3)=(Range=750,RangeValue=0.540) // guess
    OpticalRanges(4)=(Range=1000,RangeValue=0.5426)
    OpticalRanges(5)=(Range=1500,RangeValue=0.5885)
    OpticalRanges(6)=(Range=2000,RangeValue=0.6441)
    OpticalRanges(7)=(Range=2500,RangeValue=0.7053)

    //adjusts the strike of the round (changed to normal superelevation angles)
    MechanicalRanges(0)=(Range=0,RangeValue=0)
    MechanicalRanges(1)=(Range=250,RangeValue=0)
    MechanicalRanges(2)=(Range=500,RangeValue=0)
    MechanicalRanges(3)=(Range=750,RangeValue=0)
    MechanicalRanges(4)=(Range=1000,RangeValue=0)
    MechanicalRanges(5)=(Range=1500,RangeValue=0) //
    MechanicalRanges(6)=(Range=2000,RangeValue=0) //
    MechanicalRanges(7)=(Range=2500,RangeValue=0) //

    CoronaClass=class'DH_Effects.DHShellTracer_Green'
    StaticMesh=StaticMesh'DH_Tracers.shells.Soviet_shell'
    ShellShatterEffectClass=Class'DH_Effects.DHShellShatterEffect_Small'
}

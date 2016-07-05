//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_BT7CannonShell extends DHCannonShellAPBC;

defaultproperties
{
    Tag="BR-240SP" //APBC
    BallisticCoefficient=1.12
    Speed=45806 // 759 M/S, (60.35 * 759), using BR-240 SP ( Armor Piercing Ballistic Cap )
    MaxSpeed=45806
    SpeedFudgeScale=0.50
    bDebugBallistics=false
    bMechanicalAiming=True
    ShellDiameter=4.5
    ShellImpactDamage=class'DH_Vehicles.DH_BT7CannonShellDamageAPC'
    ImpactDamage=350.0

    DHPenetrationTable(0)=5.5  //100
    DHPenetrationTable(1)=5.1  //250
    DHPenetrationTable(2)=4.6  //500
    DHPenetrationTable(3)=4.2  //750
    DHPenetrationTable(4)=3.8  //1000
    DHPenetrationTable(5)=3.5  //1250
    DHPenetrationTable(6)=3.1  //1500
    DHPenetrationTable(7)=2.8  //1750
    DHPenetrationTable(8)=2.5  //2000
    DHPenetrationTable(9)=1.9  //2500
    DHPenetrationTable(10)=1.3 //3000

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
}

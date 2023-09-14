//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_T3485CannonShellHE extends DHCannonShellHE;

defaultproperties
{
    Speed=39832.0 // 660 m/s
    MaxSpeed=39832.0
    ShellDiameter=7.62
    BallisticCoefficient=1.55 //find correct BC

    //Damage
    ImpactDamage=741
    Damage=430.0   //741 gramms TNT
    DamageRadius=1300.0
    PenetrationMag=1000.0
    HullFireChance=1.0
    EngineFireChance=1.0

    bDebugInImperial=false

    //Effects
    CoronaClass=class'DH_Effects.DHShellTracer_GreenLarge'
    ShellTrailClass=class'DH_Effects.DHShellTrail_Green'

    //Penetration
    DHPenetrationTable(0)=4.0
    DHPenetrationTable(1)=3.8
    DHPenetrationTable(2)=3.4
    DHPenetrationTable(3)=3.1
    DHPenetrationTable(4)=2.8
    DHPenetrationTable(5)=2.5
    DHPenetrationTable(6)=2.2
    DHPenetrationTable(7)=1.9
    DHPenetrationTable(8)=1.6
    DHPenetrationTable(9)=1.2
    DHPenetrationTable(10)=0.8

    bMechanicalAiming=true
    MechanicalRanges(0)=(Range=0,RangeValue=0.0)
    MechanicalRanges(1)=(Range=400,RangeValue=49.0)
    MechanicalRanges(2)=(Range=500,RangeValue=64.0)
    MechanicalRanges(3)=(Range=600,RangeValue=77.0)
    MechanicalRanges(4)=(Range=700,RangeValue=92.0)
    MechanicalRanges(5)=(Range=800,RangeValue=108.0)
    MechanicalRanges(6)=(Range=900,RangeValue=124.0)
    MechanicalRanges(7)=(Range=1000,RangeValue=141.0)
    MechanicalRanges(8)=(Range=1200,RangeValue=176.0)
    MechanicalRanges(9)=(Range=1400,RangeValue=216.0)
    MechanicalRanges(10)=(Range=1600,RangeValue=263.0)
    MechanicalRanges(11)=(Range=1800,RangeValue=310.0)
    MechanicalRanges(12)=(Range=2000,RangeValue=353.0)
    MechanicalRanges(13)=(Range=2200,RangeValue=408.0)
    MechanicalRanges(14)=(Range=2400,RangeValue=465.0)
    MechanicalRanges(15)=(Range=2600,RangeValue=527.0)
    MechanicalRanges(16)=(Range=2800,RangeValue=592.0) // estimates from here on as these extreme ranges are largely theoretical
    MechanicalRanges(17)=(Range=3000,RangeValue=657.0)
    MechanicalRanges(18)=(Range=3200,RangeValue=722.0)
    MechanicalRanges(19)=(Range=3400,RangeValue=787.0)
    MechanicalRanges(20)=(Range=3600,RangeValue=852.0)
    MechanicalRanges(21)=(Range=3800,RangeValue=917.0)

    // For this gunsight, the moving optical bar is just a visual range indicator on the side; it doesn't actually alter the aiming point
    bOpticalAiming=true
    OpticalRanges(0)=(Range=0,RangeValue=0.374)
    OpticalRanges(1)=(Range=400,RangeValue=0.3615)
    OpticalRanges(2)=(Range=500,RangeValue=0.354)
    OpticalRanges(3)=(Range=600,RangeValue=0.348)
    OpticalRanges(4)=(Range=700,RangeValue=0.341)
    OpticalRanges(5)=(Range=800,RangeValue=0.3345)
    OpticalRanges(6)=(Range=900,RangeValue=0.328)
    OpticalRanges(7)=(Range=1000,RangeValue=0.3215)
    OpticalRanges(8)=(Range=1200,RangeValue=0.308)
    OpticalRanges(9)=(Range=1400,RangeValue=0.296)
    OpticalRanges(10)=(Range=1600,RangeValue=0.283)
    OpticalRanges(11)=(Range=1800,RangeValue=0.270)
    OpticalRanges(12)=(Range=2000,RangeValue=0.257)
    OpticalRanges(13)=(Range=2200,RangeValue=0.244)
    OpticalRanges(14)=(Range=2400,RangeValue=0.231)
    OpticalRanges(15)=(Range=2600,RangeValue=0.218)
    OpticalRanges(16)=(Range=2800,RangeValue=0.205)
    OpticalRanges(17)=(Range=3000,RangeValue=0.192)
    OpticalRanges(18)=(Range=3200,RangeValue=0.179)
    OpticalRanges(19)=(Range=3400,RangeValue=0.166)
    OpticalRanges(20)=(Range=3600,RangeValue=0.153)
    OpticalRanges(21)=(Range=3800,RangeValue=0.140)
}

//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_PanzerIIINCannonShellHEAT extends DHCannonShellHEAT;

defaultproperties
{
    Speed=27158.0 //450m/s
    MaxSpeed=27158.0
    ShellDiameter=7.5
    BallisticCoefficient=2.0

    //Damage
    ImpactDamage=350   //~~600 gramms TNT
    Damage=300.0
    DamageRadius=700.0

    //Effects
    CoronaClass=class'DH_Effects.DHShellTracer_Orange'
    ShellTrailClass=class'DH_Effects.DHShellTrail_YellowOrange'

    bDebugInImperial=false

    //Penetration Gr.38 Hl/B (HEAT) December 1942
    DHPenetrationTable(0)=8.7
    DHPenetrationTable(1)=8.7
    DHPenetrationTable(2)=8.7
    DHPenetrationTable(3)=8.7
    DHPenetrationTable(4)=8.7
    DHPenetrationTable(5)=8.7
    DHPenetrationTable(6)=8.7
    DHPenetrationTable(7)=8.7
    DHPenetrationTable(8)=8.7
    DHPenetrationTable(9)=8.7
    DHPenetrationTable(10)=8.7

    MechanicalRanges(0)=(RangeValue=59.0)
    MechanicalRanges(1)=(Range=100,RangeValue=35.0)
    MechanicalRanges(2)=(Range=200,RangeValue=58.0)
    MechanicalRanges(3)=(Range=300,RangeValue=86.0)
    MechanicalRanges(4)=(Range=400,RangeValue=114.0)
    MechanicalRanges(5)=(Range=500,RangeValue=142.0)
    MechanicalRanges(6)=(Range=600,RangeValue=171.0)
    MechanicalRanges(7)=(Range=700,RangeValue=202.0)
    MechanicalRanges(8)=(Range=800,RangeValue=234.0)
    MechanicalRanges(9)=(Range=900,RangeValue=266.0)
    MechanicalRanges(10)=(Range=1000,RangeValue=299.0)
    MechanicalRanges(11)=(Range=1100,RangeValue=334.0)
    MechanicalRanges(12)=(Range=1200,RangeValue=370.0)
    MechanicalRanges(13)=(Range=1300,RangeValue=406.0)
    MechanicalRanges(14)=(Range=1400,RangeValue=443.0)
    MechanicalRanges(15)=(Range=1500,RangeValue=482.0)
    MechanicalRanges(16)=(Range=1600,RangeValue=521.0)
    MechanicalRanges(17)=(Range=1700,RangeValue=559.0)
    MechanicalRanges(18)=(Range=1800,RangeValue=602.0)
    MechanicalRanges(19)=(Range=1900,RangeValue=643.0)
    MechanicalRanges(20)=(Range=2000,RangeValue=687.0) //Maximum range of this gun is 2000 meters, you cannot zero above that value.
    MechanicalRanges(21)=(Range=2200,RangeValue=808.0)
    MechanicalRanges(22)=(Range=2400,RangeValue=852.0)
    MechanicalRanges(23)=(Range=2600,RangeValue=898.0)
    MechanicalRanges(24)=(Range=2800,RangeValue=938.0)
    MechanicalRanges(25)=(Range=3000,RangeValue=976.0)
    bMechanicalAiming=true
}

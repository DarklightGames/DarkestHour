//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_Cromwell95mmCannonShellHEAT extends DHCannonShellHEAT;

defaultproperties
{
    Speed=19916.0            // 330 m/s
    MaxSpeed=19916.0
    ShellDiameter=9.5
    BallisticCoefficient=2.6 // between 75mm (P3N) & 105mm howitzers

    //Damage
    ImpactDamage=365
    Damage=400.0          ///couldnt find anything about the filler weight; assumed 600 gramms TNT
    DamageRadius=700.0

    //Effects
    DrawScale=1.2

    //Penetration
    DHPenetrationTable(0)=11.0
    DHPenetrationTable(1)=11.0
    DHPenetrationTable(2)=11.0
    DHPenetrationTable(3)=11.0
    DHPenetrationTable(4)=11.0
    DHPenetrationTable(5)=11.0
    DHPenetrationTable(6)=11.0
    DHPenetrationTable(7)=11.0
    DHPenetrationTable(8)=11.0
    DHPenetrationTable(9)=11.0
    DHPenetrationTable(10)=11.0

    //Gunsight adjustment
    MechanicalRanges(0)=(RangeValue=45.0)
    MechanicalRanges(1)=(Range=200,RangeValue=103.0)
    MechanicalRanges(2)=(Range=400,RangeValue=215.0)
    MechanicalRanges(3)=(Range=600,RangeValue=328.0)
    MechanicalRanges(4)=(Range=800,RangeValue=440.0)
    MechanicalRanges(5)=(Range=1000,RangeValue=558.0)
    MechanicalRanges(6)=(Range=1200,RangeValue=680.0)
    MechanicalRanges(7)=(Range=1400,RangeValue=800.0)
    MechanicalRanges(8)=(Range=1600,RangeValue=890.0)
    bMechanicalAiming=true
}

//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_CromwellCannonShell extends DHCannonShell;

defaultproperties
{
    Speed=37342.0 // 2030 fps or 619 m/s
    MaxSpeed=37342.0
    ShellDiameter=7.5
    BallisticCoefficient=2.98 // Correct - verified on range at 1000 yards

    //Damage
    ImpactDamage=540  //solid shell
    ShellImpactDamage=class'DH_Vehicles.DH_ShermanCannonShellDamageAP'
    HullFireChance=0.27
    EngineFireChance=0.55

    //Penetration
    DHPenetrationTable(0)=8.8
    DHPenetrationTable(1)=8.5
    DHPenetrationTable(2)=8.1
    DHPenetrationTable(3)=7.7
    DHPenetrationTable(4)=7.3
    DHPenetrationTable(5)=6.9
    DHPenetrationTable(6)=6.5
    DHPenetrationTable(7)=6.2
    DHPenetrationTable(8)=5.9
    DHPenetrationTable(9)=5.3
    DHPenetrationTable(10)=4.7

    //Gunsight adjustment - TODO: Recalibrate to new B/C
    MechanicalRanges(0)=(RangeValue=16.0)
    MechanicalRanges(1)=(Range=200,RangeValue=36.0)
    MechanicalRanges(2)=(Range=400,RangeValue=68.0)
    MechanicalRanges(3)=(Range=600,RangeValue=96.0)
    MechanicalRanges(4)=(Range=800,RangeValue=136.0)
    MechanicalRanges(5)=(Range=1000,RangeValue=176.0)
    MechanicalRanges(6)=(Range=1200,RangeValue=228.0)
    MechanicalRanges(7)=(Range=1400,RangeValue=292.0)
    MechanicalRanges(8)=(Range=1600,RangeValue=352.0)
    MechanicalRanges(9)=(Range=1800,RangeValue=412.0)
    MechanicalRanges(10)=(Range=2000,RangeValue=476.0)
    MechanicalRanges(11)=(Range=2200,RangeValue=556.0)
    MechanicalRanges(12)=(Range=2400,RangeValue=640.0)
    MechanicalRanges(13)=(Range=2600,RangeValue=726.0)
    MechanicalRanges(14)=(Range=2800,RangeValue=828.0)
    MechanicalRanges(15)=(Range=3000,RangeValue=938.0)
    MechanicalRanges(16)=(Range=3200,RangeValue=1064.0)
    bMechanicalAiming=true
}

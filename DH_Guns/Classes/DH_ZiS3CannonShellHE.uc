//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DH_ZiS3CannonShellHE extends DHCannonShellHE;

defaultproperties
{
    Speed=39953.0 // 662 m/s TODO: fix this
    MaxSpeed=39953.0
    ShellDiameter=7.62
    BallisticCoefficient=1.55

    //Damage
    ImpactDamage=450
    ShellImpactDamage=class'DH_Engine.DHShellHEGunImpactDamageType'
    Damage=400.0
    DamageRadius=1140.0
    MyDamageType=class'DH_Engine.DHShellHE75mmATDamageType'
    PenetrationMag=780.0
    HullFireChance=0.33
    EngineFireChance=0.45

    bDebugInImperial=false

    //Penetration
    DHPenetrationTable(0)=3.3
    DHPenetrationTable(1)=3.1
    DHPenetrationTable(2)=2.8
    DHPenetrationTable(3)=2.4
    DHPenetrationTable(4)=2.0
    DHPenetrationTable(5)=1.7
    DHPenetrationTable(6)=1.3
    DHPenetrationTable(7)=1.1
    DHPenetrationTable(8)=0.9
    DHPenetrationTable(9)=0.5
    DHPenetrationTable(10)=0.3

    //Gunsight adjustments
    bMechanicalAiming=true
    MechanicalRanges(1)=(Range=200,RangeValue=47.0)
    MechanicalRanges(2)=(Range=400,RangeValue=63.0)
    MechanicalRanges(3)=(Range=600,RangeValue=87.0)
    MechanicalRanges(4)=(Range=800,RangeValue=115.0)
    MechanicalRanges(5)=(Range=1000,RangeValue=147.0)
    MechanicalRanges(6)=(Range=1200,RangeValue=183.0)
    MechanicalRanges(7)=(Range=1400,RangeValue=220.0)
    MechanicalRanges(8)=(Range=1600,RangeValue=260.0)
    MechanicalRanges(9)=(Range=1800,RangeValue=307.0)
    MechanicalRanges(10)=(Range=2000,RangeValue=355.0)
    MechanicalRanges(11)=(Range=2200,RangeValue=408.0)
    MechanicalRanges(12)=(Range=2400,RangeValue=467.0)
    MechanicalRanges(13)=(Range=2600,RangeValue=528.0)
    MechanicalRanges(14)=(Range=2800,RangeValue=589.0) // estimates from here on as these extreme ranges are largely theoretical
    MechanicalRanges(15)=(Range=3000,RangeValue=650.0)
    MechanicalRanges(16)=(Range=3200,RangeValue=711.0)
    MechanicalRanges(17)=(Range=3400,RangeValue=772.0)
    MechanicalRanges(18)=(Range=3600,RangeValue=833.0)
    MechanicalRanges(19)=(Range=3800,RangeValue=894.0)
    MechanicalRanges(20)=(Range=4000,RangeValue=955.0)
}

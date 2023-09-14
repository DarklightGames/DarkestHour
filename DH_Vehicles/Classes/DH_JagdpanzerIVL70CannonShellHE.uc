//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_JagdpanzerIVL70CannonShellHE extends DHCannonShellHE;

defaultproperties
{
    Speed=42245.0
    MaxSpeed=42245.0
    ShellDiameter=7.5
    BallisticCoefficient=2.0

    //Damage
    ImpactDamage=710
    ShellImpactDamage=class'DH_Engine.DHShellHEGunImpactDamageType'
    PenetrationMag=750.0
    Damage=350.0   //725 gramms TNT, but is known for being inferior to soviet 76mm, so i assume worse/lighter  fragmentation
    DamageRadius=950.0
    MyDamageType=class'DH_Engine.DHShellHE75mmATDamageType'
    HullFireChance=0.8
    EngineFireChance=0.8

    bDebugInImperial=false

    //Effects
    bHasTracer=false
    bHasShellTrail=false

    //Penetration
    DHPenetrationTable(0)=4.5
    DHPenetrationTable(1)=4.2
    DHPenetrationTable(2)=3.5
    DHPenetrationTable(3)=3.2
    DHPenetrationTable(4)=2.8
    DHPenetrationTable(5)=2.4
    DHPenetrationTable(6)=2.4
    DHPenetrationTable(7)=2.4
    DHPenetrationTable(8)=2.4
    DHPenetrationTable(9)=2.4
    DHPenetrationTable(10)=2.4

    MechanicalRanges(1)=(Range=100,RangeValue=8.0)
    MechanicalRanges(2)=(Range=200,RangeValue=20.0)
    MechanicalRanges(3)=(Range=300,RangeValue=33.0)
    MechanicalRanges(4)=(Range=400,RangeValue=45.0)
    MechanicalRanges(5)=(Range=500,RangeValue=56.0)
    MechanicalRanges(6)=(Range=600,RangeValue=70.0)
    MechanicalRanges(7)=(Range=700,RangeValue=83.0)
    MechanicalRanges(8)=(Range=800,RangeValue=96.0)
    MechanicalRanges(9)=(Range=900,RangeValue=110.0)
    MechanicalRanges(10)=(Range=1000,RangeValue=122.0)
    MechanicalRanges(11)=(Range=1100,RangeValue=136.0)
    MechanicalRanges(12)=(Range=1200,RangeValue=155.0)
    MechanicalRanges(13)=(Range=1300,RangeValue=165.0)
    MechanicalRanges(14)=(Range=1400,RangeValue=182.0)
    MechanicalRanges(15)=(Range=1500,RangeValue=198.0)
    MechanicalRanges(16)=(Range=1600,RangeValue=229.0)
    MechanicalRanges(17)=(Range=1700,RangeValue=235.0)
    MechanicalRanges(18)=(Range=1800,RangeValue=255.0)
    MechanicalRanges(19)=(Range=1900,RangeValue=278.0)
    MechanicalRanges(20)=(Range=2000,RangeValue=290.0)
    MechanicalRanges(21)=(Range=2200,RangeValue=333.0)
    MechanicalRanges(22)=(Range=2400,RangeValue=380.0)
    MechanicalRanges(23)=(Range=2600,RangeValue=428.0)
    MechanicalRanges(24)=(Range=2800,RangeValue=470.0)
    MechanicalRanges(25)=(Range=3000,RangeValue=524.0)
    bMechanicalAiming=true
}

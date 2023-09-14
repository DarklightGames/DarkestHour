//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_JagdtigerCannonShell extends DHGermanCannonShell;

defaultproperties
{
    Speed=53110.0
    MaxSpeed=53110.0
    ShellDiameter=12.8
    BallisticCoefficient=3.9

    //Damage
    ImpactDamage=3000  //787 gramms TNT filler
    Damage=1000 //Going to treat this like a powerful HE shell when it hits the ground
    DamageRadius=900
    HullFireChance=1.0
    EngineFireChance=1.0

    //Effects
    StaticMesh=StaticMesh'WeaponPickupSM.Ammo.122mm_Shell'

    //Penetration
    DHPenetrationTable(0)=26.7
    DHPenetrationTable(1)=26.2
    DHPenetrationTable(2)=25.3
    DHPenetrationTable(3)=24.5
    DHPenetrationTable(4)=23.7
    DHPenetrationTable(5)=23.0
    DHPenetrationTable(6)=22.2
    DHPenetrationTable(7)=21.5
    DHPenetrationTable(8)=20.8
    DHPenetrationTable(9)=19.5
    DHPenetrationTable(10)=18.2

    MechanicalRanges(1)=(Range=100,RangeValue=16.0)
    MechanicalRanges(2)=(Range=200,RangeValue=20.0)
    MechanicalRanges(3)=(Range=300,RangeValue=26.0)
    MechanicalRanges(4)=(Range=400,RangeValue=32.0)
    MechanicalRanges(5)=(Range=500,RangeValue=42.0)
    MechanicalRanges(6)=(Range=600,RangeValue=48.0)
    MechanicalRanges(7)=(Range=700,RangeValue=54.0)
    MechanicalRanges(8)=(Range=800,RangeValue=62.0)
    MechanicalRanges(9)=(Range=900,RangeValue=70.0)
    MechanicalRanges(10)=(Range=1000,RangeValue=74.0)
    MechanicalRanges(11)=(Range=1100,RangeValue=86.0)
    MechanicalRanges(12)=(Range=1200,RangeValue=90.0)
    MechanicalRanges(13)=(Range=1300,RangeValue=100.0)
    MechanicalRanges(14)=(Range=1400,RangeValue=110.0)
    MechanicalRanges(15)=(Range=1500,RangeValue=116.0)
    MechanicalRanges(16)=(Range=1600,RangeValue=124.0)
    MechanicalRanges(17)=(Range=1700,RangeValue=134.0)
    MechanicalRanges(18)=(Range=1800,RangeValue=136.0)
    MechanicalRanges(19)=(Range=1900,RangeValue=148.0)
    MechanicalRanges(20)=(Range=2000,RangeValue=154.0)
    MechanicalRanges(21)=(Range=2200,RangeValue=169.0)
    MechanicalRanges(22)=(Range=2400,RangeValue=183.0)
    MechanicalRanges(23)=(Range=2600,RangeValue=198.0)
    MechanicalRanges(24)=(Range=2800,RangeValue=212.0)
    MechanicalRanges(25)=(Range=3000,RangeValue=227.0)
    bMechanicalAiming=true
}

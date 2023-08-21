//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================
// [1] https://en.wikipedia.org/wiki/Cannone_da_90/53
// [2]https://tanks-encyclopedia.com/semovente-m41m-da-90-53/
//==============================================================================

class DH_Semovente9053CannonShell extends DHGermanCannonShell;

defaultproperties
{
    Speed=45746.816     //758m/s [2]
    MaxSpeed=45746.816 
    ShellDiameter=9.0   //90mm [1]
    BallisticCoefficient=3.2   // TODO: Find real value, currently using the flak88 as a basis 

    //Damage
    ImpactDamage=2456 //347 gramms TNT filler, citation needed
    ShellImpactDamage=class'DH_Engine.DHShellAPGunImpactDamageType'
    HullFireChance=0.7
    EngineFireChance=0.98

    //Penetration [2]https://tanks-encyclopedia.com/semovente-m41m-da-90-53/
    DHPenetrationTable(0)=13.0  //100
    DHPenetrationTable(1)=12.7  //250
    DHPenetrationTable(2)=12.3  //500
    DHPenetrationTable(3)=11.5  //750
    DHPenetrationTable(4)=11.0  //1000
    DHPenetrationTable(5)=10.6  //1250
    DHPenetrationTable(6)=10.2  //1500
    DHPenetrationTable(7)=9.7   //1750
    DHPenetrationTable(8)=9.3   //2000
    DHPenetrationTable(9)=8.5   //2500
    DHPenetrationTable(10)=7.3  //3000

    //Gunsight adjustments
    MechanicalRanges(1)=(Range=100,RangeValue=14.0)
    MechanicalRanges(2)=(Range=200,RangeValue=20.0)
    MechanicalRanges(3)=(Range=300,RangeValue=26.0)
    MechanicalRanges(4)=(Range=400,RangeValue=40.0)
    MechanicalRanges(5)=(Range=500,RangeValue=44.0)
    MechanicalRanges(6)=(Range=600,RangeValue=52.0)
    MechanicalRanges(7)=(Range=700,RangeValue=62.0)
    MechanicalRanges(8)=(Range=800,RangeValue=74.0)
    MechanicalRanges(9)=(Range=900,RangeValue=84.0)
    MechanicalRanges(10)=(Range=1000,RangeValue=90.0)
    MechanicalRanges(11)=(Range=1100,RangeValue=106.0)
    MechanicalRanges(12)=(Range=1200,RangeValue=112.0)
    MechanicalRanges(13)=(Range=1300,RangeValue=126.0)
    MechanicalRanges(14)=(Range=1400,RangeValue=132.0)
    MechanicalRanges(15)=(Range=1500,RangeValue=148.0)
    MechanicalRanges(16)=(Range=1600,RangeValue=154.0)
    MechanicalRanges(17)=(Range=1700,RangeValue=166.0)
    MechanicalRanges(18)=(Range=1800,RangeValue=180.0)
    MechanicalRanges(19)=(Range=1900,RangeValue=194.0)
    MechanicalRanges(20)=(Range=2000,RangeValue=200.0)
    MechanicalRanges(21)=(Range=2200,RangeValue=220.0)
    MechanicalRanges(22)=(Range=2400,RangeValue=240.0)
    MechanicalRanges(23)=(Range=2600,RangeValue=259.0)
    MechanicalRanges(24)=(Range=2800,RangeValue=278.0)
    MechanicalRanges(25)=(Range=3000,RangeValue=298.0)
    bMechanicalAiming=true
}

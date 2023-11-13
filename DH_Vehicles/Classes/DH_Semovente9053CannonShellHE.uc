//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================
// [1] https://en.wikipedia.org/wiki/Cannone_da_90/53
// [1]https://tanks-encyclopedia.com/semovente-m41m-da-90-53/
//==============================================================================

class DH_Semovente9053CannonShellHE extends DHCannonShellHE;

defaultproperties
{
    Speed=50092.0               // 830m/s [1]
    MaxSpeed=50092.0            
    ShellDiameter=9.0           // 90mm [1]
    BallisticCoefficient=2.5    // TODO: Find real value

    //Damage
    ImpactDamage=1000
    
    Damage=473.0   // 1000 gramms TNT, citation needed, references show exactly 1000 but that seems off
    DamageRadius=1530.0
    MyDamageType=class'DHShellHE88mmDamageType' // with 2mm off there really isnt much of a difference
    HullFireChance=0.8
    EngineFireChance=0.8

    ShellImpactDamage=class'DH_Engine.DHShellHEGunImpactDamageType'

    //Effects
    bHasTracer=false
    bHasShellTrail=false
    bDebugInImperial=false

    //Penetration
    DHPenetrationTable(0)=5.2
    DHPenetrationTable(1)=4.9
    DHPenetrationTable(2)=4.3
    DHPenetrationTable(3)=4.0
    DHPenetrationTable(4)=3.8
    DHPenetrationTable(5)=3.2
    DHPenetrationTable(6)=3.0
    DHPenetrationTable(7)=2.7
    DHPenetrationTable(8)=2.3
    DHPenetrationTable(9)=1.9
    DHPenetrationTable(10)=1.5

    bMechanicalAiming=true
    MechanicalRanges(0)=(Range=100,RangeValue=0)
    MechanicalRanges(1)=(Range=200,RangeValue=52)
    MechanicalRanges(2)=(Range=300,RangeValue=49)
    MechanicalRanges(3)=(Range=400,RangeValue=52)
    MechanicalRanges(4)=(Range=500,RangeValue=57)
    MechanicalRanges(5)=(Range=600,RangeValue=64)
    MechanicalRanges(6)=(Range=700,RangeValue=72)
    MechanicalRanges(7)=(Range=800,RangeValue=77)
    MechanicalRanges(8)=(Range=900,RangeValue=85)
    MechanicalRanges(9)=(Range=1000,RangeValue=96)
    MechanicalRanges(10)=(Range=1100,RangeValue=104)
    MechanicalRanges(11)=(Range=1200,RangeValue=112)
    MechanicalRanges(12)=(Range=1300,RangeValue=121)
    MechanicalRanges(13)=(Range=1400,RangeValue=132)
    MechanicalRanges(14)=(Range=1500,RangeValue=141)
    MechanicalRanges(15)=(Range=1600,RangeValue=152)
    MechanicalRanges(16)=(Range=1700,RangeValue=161)
    MechanicalRanges(17)=(Range=1800,RangeValue=172)
    MechanicalRanges(18)=(Range=1900,RangeValue=184)
    MechanicalRanges(19)=(Range=2000,RangeValue=193)

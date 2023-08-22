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

    bOpticalAiming=true
    OpticalRanges(0)=(Range=0,RangeValue=0.0)
    OpticalRanges(1)=(Range=200,RangeValue=0.478)
    OpticalRanges(2)=(Range=400,RangeValue=0.462)
    OpticalRanges(3)=(Range=600,RangeValue=0.447)
    OpticalRanges(4)=(Range=800,RangeValue=0.432)
    OpticalRanges(5)=(Range=1000,RangeValue=0.416)
    OpticalRanges(6)=(Range=1200,RangeValue=0.397)
    OpticalRanges(7)=(Range=1400,RangeValue=0.380)
    OpticalRanges(8)=(Range=1600,RangeValue=0.360)
    OpticalRanges(9)=(Range=1800,RangeValue=0.341)
    OpticalRanges(10)=(Range=2000,RangeValue=0.322)
}

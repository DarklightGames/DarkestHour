//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================
// [1] https://en.wikipedia.org/wiki/Cannone_da_90/53
// [2] https://tanks-encyclopedia.com/semovente-m41m-da-90-53/
//==============================================================================

class DH_Semovente9053CannonShell extends DHItalianCannonShell;

defaultproperties
{
    Speed=45746.816     // 758m/s [2]
    MaxSpeed=45746.816
    ShellDiameter=9.0   // 90mm [1]
    BallisticCoefficient=3.2   // TODO: Find real value, currently using the flak88 as a basis

    //Damage
    ImpactDamage=2456 //347 gramms TNT filler, citation needed
    ShellImpactDamage=Class'DHShellAPGunImpactDamageType'
    HullFireChance=0.7
    EngineFireChance=0.98

    //Penetration [2]
    DHPenetrationTable(0)=13.0  //100
    DHPenetrationTable(1)=12.5  //250
    DHPenetrationTable(2)=12.1  //500
    DHPenetrationTable(3)=11.5  //750
    DHPenetrationTable(4)=11.0  //1000
    DHPenetrationTable(5)=10.6  //1250
    DHPenetrationTable(6)=10.2  //1500
    DHPenetrationTable(7)=9.7   //1750
    DHPenetrationTable(8)=9.3   //2000
    DHPenetrationTable(9)=8.5   //2500
    DHPenetrationTable(10)=7.3  //3000

    bMechanicalAiming=true
    MechanicalRanges(0)=(Range=0,RangeValue=50)
    MechanicalRanges(1)=(Range=200,RangeValue=53)
    MechanicalRanges(2)=(Range=400,RangeValue=57)
    MechanicalRanges(3)=(Range=600,RangeValue=72)
    MechanicalRanges(4)=(Range=800,RangeValue=89)
    MechanicalRanges(5)=(Range=1000,RangeValue=109)
    MechanicalRanges(6)=(Range=1200,RangeValue=129)
    MechanicalRanges(7)=(Range=1400,RangeValue=153)
    MechanicalRanges(8)=(Range=1600,RangeValue=173)
    MechanicalRanges(9)=(Range=1800,RangeValue=197)
    MechanicalRanges(10)=(Range=2000,RangeValue=221)
}

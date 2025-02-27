//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_Pak40CannonShellAPCR extends DHGermanCannonShell;

defaultproperties
{
    Speed=55270.0  //estimate
    MaxSpeed=55270.0
    ShellDiameter=5.0 //sub-caliber round
    BallisticCoefficient=1.52 //TODO: pls, check
    SpeedFudgeScale=0.4

    //Damage
    ImpactDamage=490  //solid tungsten
    ShellImpactDamage=class'DH_Vehicles.DH_ShermanM4A176WCannonShellDamageHVAP'
    HullFireChance=0.3
    EngineFireChance=0.6

    //Penetration
    DHPenetrationTable(0)=17.3  //estimates
    DHPenetrationTable(1)=16.4
    DHPenetrationTable(2)=15.1
    DHPenetrationTable(3)=13.9
    DHPenetrationTable(4)=12.7
    DHPenetrationTable(5)=11.7
    DHPenetrationTable(6)=10.8
    DHPenetrationTable(7)=9.1
    DHPenetrationTable(8)=7.7
    DHPenetrationTable(9)=6.5
    DHPenetrationTable(10)=5.8

    //Gunsight adjustments
    MechanicalRanges(1)=(Range=100,RangeValue=14.0)
    MechanicalRanges(2)=(Range=200,RangeValue=17.0)
    MechanicalRanges(3)=(Range=300,RangeValue=22.0)
    MechanicalRanges(4)=(Range=400,RangeValue=29.0)
    MechanicalRanges(5)=(Range=500,RangeValue=34.0)
    MechanicalRanges(6)=(Range=600,RangeValue=42.0)
    MechanicalRanges(7)=(Range=700,RangeValue=49.0)
    MechanicalRanges(8)=(Range=800,RangeValue=57.0)
    MechanicalRanges(9)=(Range=900,RangeValue=65.0)
    MechanicalRanges(10)=(Range=1000,RangeValue=73.0)
    MechanicalRanges(11)=(Range=1100,RangeValue=81.0)
    MechanicalRanges(12)=(Range=1200,RangeValue=90.0)
    MechanicalRanges(13)=(Range=1300,RangeValue=101.0)
    MechanicalRanges(14)=(Range=1400,RangeValue=109.0)
    MechanicalRanges(15)=(Range=1500,RangeValue=118.0)
    MechanicalRanges(16)=(Range=1600,RangeValue=130.0)
    MechanicalRanges(17)=(Range=1700,RangeValue=141.0)
    MechanicalRanges(18)=(Range=1800,RangeValue=153.0)
    MechanicalRanges(19)=(Range=1900,RangeValue=165.0)
    MechanicalRanges(20)=(Range=2000,RangeValue=177.0)
    bMechanicalAiming=true
}

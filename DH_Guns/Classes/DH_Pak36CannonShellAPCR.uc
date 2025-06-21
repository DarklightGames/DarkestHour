//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================
// https://panzerworld.com/armor-penetration-table
// https://wwiitanks.co.uk/FORM-Gun_Data.php?I=94
//==============================================================================

class DH_Pak36CannonShellAPCR extends DHGermanCannonShell;

defaultproperties
{
    RoundType=RT_APDS
    Speed=61559.04
    MaxSpeed=61559.04
    ShellDiameter=3.7
    BallisticCoefficient=0.95   // TODO: coeff on this shell?
    SpeedFudgeScale=0.5

    //Damage
    bShatterProne=true
    ImpactDamage=310
    // TODO: custom damage type
    ShellImpactDamage=Class'DH_Vehicles.DH_PanzerIIILCannonShellDamageAPCR'
    HullFireChance=0.4
    EngineFireChance=0.6

    //Effects
    CoronaClass=Class'DH_Effects.DHShellTracer_Orange'
    ShellShatterEffectClass=Class'DH_Effects.DHShellShatterEffect_Small'

    //Penetration (https://wwiitanks.co.uk/FORM-Gun_Data.php?I=94)
    DHPenetrationTable(0)=6.7  // 100
    DHPenetrationTable(1)=5.7  // 250
    DHPenetrationTable(2)=4.8  // 500
    DHPenetrationTable(3)=4.0   // 750
    DHPenetrationTable(4)=3.3   // 1000
    DHPenetrationTable(5)=2.7   // 1250
    DHPenetrationTable(6)=2.1   // 1500
    DHPenetrationTable(7)=1.5   // 1750
    DHPenetrationTable(8)=1.0   // 2000
    DHPenetrationTable(9)=0.5   // 2500
    DHPenetrationTable(10)=0.0  // 3000
}

//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_WolverineCannonShell extends DHCannonShell;

defaultproperties
{
    Speed=47828.0 // 2600 fps or 792 m/s
    MaxSpeed=47828.0
    ShellDiameter=7.62
    BallisticCoefficient=2.85 // Correct - verified on range at 1000 yards - dfferent BC due to number of barrel twists vs. 76mm gun

    //Damage
    bShatterProne=true
    ImpactDamage=700  //64 gramms TNT filler
    ShellImpactDamage=class'DH_Vehicles.DH_ShermanM4A176WCannonShellDamageAP'
    HullFireChance=0.5
    EngineFireChance=0.88

    //Penetration
    DHPenetrationTable(0)=12.4
    DHPenetrationTable(1)=12.1
    DHPenetrationTable(2)=11.5
    DHPenetrationTable(3)=10.9
    DHPenetrationTable(4)=10.3
    DHPenetrationTable(5)=9.8
    DHPenetrationTable(6)=9.3
    DHPenetrationTable(7)=8.8
    DHPenetrationTable(8)=8.4
    DHPenetrationTable(9)=7.6
    DHPenetrationTable(10)=6.8
}

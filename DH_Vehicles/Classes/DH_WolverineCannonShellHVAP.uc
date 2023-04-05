//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_WolverineCannonShellHVAP extends DHCannonShellHVAP;

defaultproperties
{
    Speed=62544.0 // 3400 fps or 1036 m/s
    MaxSpeed=62544.0
    ShellDiameter=7.62 // full caliber with windshield (3.8 cm core)
    BallisticCoefficient=1.87 // Correct - verified on range at 1000 yards

    //Damage
    ImpactDamage=460
    ShellImpactDamage=class'DH_Vehicles.DH_ShermanM4A176WCannonShellDamageHVAP'
    HullFireChance=0.31
    EngineFireChance=0.61

    //Penetration
    DHPenetrationTable(0)=19.2
    DHPenetrationTable(1)=17.7
    DHPenetrationTable(2)=16.5
    DHPenetrationTable(3)=14.6
    DHPenetrationTable(4)=13.7
    DHPenetrationTable(5)=12.5
    DHPenetrationTable(6)=11.3
    DHPenetrationTable(7)=10.6
    DHPenetrationTable(8)=9.4
    DHPenetrationTable(9)=8.0
    DHPenetrationTable(10)=6.7
}

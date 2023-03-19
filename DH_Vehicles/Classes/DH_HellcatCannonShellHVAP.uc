//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_HellcatCannonShellHVAP extends DHCannonShellHVAP;

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
<<<<<<< Updated upstream
    DHPenetrationTable(0)=24.6
    DHPenetrationTable(1)=24.0
    DHPenetrationTable(2)=23.3
    DHPenetrationTable(3)=22.6
    DHPenetrationTable(4)=21.9
    DHPenetrationTable(5)=21.3
    DHPenetrationTable(6)=20.7
    DHPenetrationTable(7)=20.0
    DHPenetrationTable(8)=19.3
    DHPenetrationTable(9)=18.5
    DHPenetrationTable(10)=17.9 
=======
    DHPenetrationTable(0)=24.0
    DHPenetrationTable(1)=22.9
    DHPenetrationTable(2)=21.3
    DHPenetrationTable(3)=19.6
    DHPenetrationTable(4)=17.9
    DHPenetrationTable(5)=16.3
    DHPenetrationTable(6)=14.9
    DHPenetrationTable(7)=13.8
    DHPenetrationTable(8)=12.4
    DHPenetrationTable(9)=10.1
    DHPenetrationTable(10)=7.6
>>>>>>> Stashed changes
}


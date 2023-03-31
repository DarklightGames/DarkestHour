//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_T3485CannonShell extends DH_T3485CannonShell_Early;

defaultproperties
{
    RoundType=RT_APBC

    //Damage
    ImpactDamage=780  //82 gramms TNT filler
    ShellImpactDamage=class'DH_Vehicles.DH_ShermanM4A176WCannonShellDamageAP'
    HullFireChance=0.45
    EngineFireChance=0.94

    //Penetration
    DHPenetrationTable(0)=12.6 // 100m
    DHPenetrationTable(1)=12.3 // 250m
    DHPenetrationTable(2)=11.8 // 500m
    DHPenetrationTable(3)=11.1
    DHPenetrationTable(4)=10.7  // 1000m
    DHPenetrationTable(5)=10.2
    DHPenetrationTable(6)=9.8  // 1500m
    DHPenetrationTable(7)=9.4
    DHPenetrationTable(8)=9.0  // 2000m
    DHPenetrationTable(9)=8.3
    DHPenetrationTable(10)=7.6 // 3000m
}

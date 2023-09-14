//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_T3476CannonShellEarly extends DH_T3476CannonShell; //BR-350A

defaultproperties
{
    ImpactDamage=720  //155 gramms TNT filler
    ShellImpactDamage=class'DH_Vehicles.DH_ShermanCannonShellDamageAP'
    HullFireChance=0.65
    EngineFireChance=0.96

    bShatterProne=true

    //Penetration
    DHPenetrationTable(0)=7.9  // 100m (all penetration from Bird & Livingstone, for 662 m/s muzzle velocity, in between rolled homogenous and face hardened armor)
    DHPenetrationTable(1)=7.6  // 250m
    DHPenetrationTable(2)=7.1  // 500m
    DHPenetrationTable(3)=6.6
    DHPenetrationTable(4)=6.3  // 1000m
    DHPenetrationTable(5)=5.9
    DHPenetrationTable(6)=5.6  // 1500m
    DHPenetrationTable(7)=5.3
    DHPenetrationTable(8)=5.0  // 2000m
    DHPenetrationTable(9)=4.5
    DHPenetrationTable(10)=4.0 // 3000m
}

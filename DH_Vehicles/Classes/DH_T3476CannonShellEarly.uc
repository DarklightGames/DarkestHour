//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2020
//==============================================================================

class DH_T3476CannonShellEarly extends DH_T3476CannonShell;

defaultproperties
{
    ImpactDamage=550.0

    bShatterProne=true

    //Penetration
    DHPenetrationTable(0)=8.0  // 100m (all penetration from Bird & Livingstone, for 662 m/s muzzle velocity vs face hardened armor)
    DHPenetrationTable(1)=7.7  // 250m
    DHPenetrationTable(2)=7.2  // 500m
    DHPenetrationTable(3)=6.7
    DHPenetrationTable(4)=6.4  // 1000m
    DHPenetrationTable(5)=6.0
    DHPenetrationTable(6)=5.7  // 1500m
    DHPenetrationTable(7)=5.3
    DHPenetrationTable(8)=5.0  // 2000m
    DHPenetrationTable(9)=4.5
    DHPenetrationTable(10)=4.0 // 3000m
}

//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_IS2CannonShell_Late extends DH_IS2CannonShell;

defaultproperties
{
    RoundType=RT_APBC

    //Penetration - BR-471B (capped)
    DHPenetrationTable(0)=17.5  // 100m
    DHPenetrationTable(1)=17.2  // 250m
    DHPenetrationTable(2)=16.6  // 500m
    DHPenetrationTable(3)=16.0
    DHPenetrationTable(4)=15.5  // 1000m
    DHPenetrationTable(5)=15.0
    DHPenetrationTable(6)=14.4  // 1500m
    DHPenetrationTable(7)=13.9
    DHPenetrationTable(8)=13.5  // 2000m
    DHPenetrationTable(9)=12.6
    DHPenetrationTable(10)=11.7 // 3000m
}

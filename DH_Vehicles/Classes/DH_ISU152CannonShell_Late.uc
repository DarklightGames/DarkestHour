//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DH_ISU152CannonShell_Late extends DH_ISU152CannonShell;

defaultproperties
{
    RoundType=RT_APBC
    ImpactDamage=3600 // has explosive filler - so higher than solid AP round
    Tag="BR-540B" // APBC-HE round adopted in late 1944

    DHPenetrationTable(0)=13.5  // 100m
    DHPenetrationTable(1)=13.1  // 250m
    DHPenetrationTable(2)=12.8  // 500m
    DHPenetrationTable(3)=12.3
    DHPenetrationTable(4)=11.9  // 1000m
    DHPenetrationTable(5)=11.6
    DHPenetrationTable(6)=10.9  // 1500m
    DHPenetrationTable(7)=10.4
    DHPenetrationTable(8)=9.9  // 2000m
    DHPenetrationTable(9)=8.9
    DHPenetrationTable(10)=8.1  // 3000m
}

//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_ISU152CannonShell_Late extends DH_ISU152CannonShell;

defaultproperties
{
    RoundType=RT_APBC
    Tag="BR-540B" // APBC round adopted in late 1944

    DHPenetrationTable(0)=13.0  // 100m
    DHPenetrationTable(1)=13.0  // 250m
    DHPenetrationTable(2)=13.0  // 500m
    DHPenetrationTable(3)=12.5
    DHPenetrationTable(4)=12.0  // 1000m
    DHPenetrationTable(5)=11.75
    DHPenetrationTable(6)=11.5  // 1500m
    DHPenetrationTable(7)=11.0
    DHPenetrationTable(8)=10.5  // 2000m
    DHPenetrationTable(9)=9.5
    DHPenetrationTable(10)=8.5  // 3000m
}

//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_IS2CannonShell_Late extends DH_IS2CannonShell;

defaultproperties
{
    RoundType=RT_APBC
    Tag="BR-471B" // APBC round available from early 1945

    DHPenetrationTable(0)=16.5  // 100m
    DHPenetrationTable(1)=16.0  // 250m
    DHPenetrationTable(2)=15.5  // 500m
    DHPenetrationTable(3)=15.0
    DHPenetrationTable(4)=14.5  // 1000m
    DHPenetrationTable(5)=14.0
    DHPenetrationTable(6)=13.5  // 1500m
    DHPenetrationTable(7)=13.0
    DHPenetrationTable(8)=12.5  // 2000m
    DHPenetrationTable(9)=11.5
    DHPenetrationTable(10)=10.5 // 3000m
}

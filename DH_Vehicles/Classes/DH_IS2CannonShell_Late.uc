//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DH_IS2CannonShell_Late extends DH_IS2CannonShell;

defaultproperties
{
    RoundType=RT_APBC
    Tag="BR-471B" // APBC round available from late '44

    DHPenetrationTable(0)=20.1  // 100m
    DHPenetrationTable(1)=19.4  // 250m
    DHPenetrationTable(2)=18.3  // 500m
    DHPenetrationTable(3)=17.2
    DHPenetrationTable(4)=16.2  // 1000m
    DHPenetrationTable(5)=15.2
    DHPenetrationTable(6)=14.4  // 1500m
    DHPenetrationTable(7)=13.6
    DHPenetrationTable(8)=12.9  // 2000m
    DHPenetrationTable(9)=11.8
    DHPenetrationTable(10)=10.8 // 3000m
}

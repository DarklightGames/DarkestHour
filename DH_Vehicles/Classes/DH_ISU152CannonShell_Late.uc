//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_ISU152CannonShell_Late extends DH_ISU152CannonShell;

defaultproperties
{
    RoundType=RT_APBC

    //Damage

    //Penetration - BR540b
    DHPenetrationTable(0)=14.8  // 100m
    DHPenetrationTable(1)=14.6  // 250m
    DHPenetrationTable(2)=14.2  // 500m
    DHPenetrationTable(3)=13.8
    DHPenetrationTable(4)=13.5 // 1000m
    DHPenetrationTable(5)=13.2
    DHPenetrationTable(6)=12.8  // 1500m
    DHPenetrationTable(7)=12.4
    DHPenetrationTable(8)=12.2  // 2000m
    DHPenetrationTable(9)=11.6
    DHPenetrationTable(10)=11.0  // 3000m
}

//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_T3476CannonShellEarly extends DH_T3476CannonShell; // TODO: this is not being used anywhere

defaultproperties
{
    Speed=39832 // 660 m/s
    MaxSpeed=39832.0
    ImpactDamage=550.0
    Tag="BR-350A" // early war APBC round

    DHPenetrationTable(0)=8.4
    DHPenetrationTable(1)=7.7
    DHPenetrationTable(2)=7.0
    DHPenetrationTable(3)=6.4
    DHPenetrationTable(4)=5.6
    DHPenetrationTable(5)=4.9
    DHPenetrationTable(6)=4.5
    DHPenetrationTable(7)=4.1
    DHPenetrationTable(8)=3.6
    DHPenetrationTable(9)=3.0
    DHPenetrationTable(10)=2.3
}

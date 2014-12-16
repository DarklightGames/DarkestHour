//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_BazookaRocket extends DH_RocketProj;

defaultproperties
{
    StraightFlightTime=0.500000
    DHPenetrationTable(0)=9.800000
    DHPenetrationTable(1)=9.800000
    DHPenetrationTable(2)=9.800000
    DHPenetrationTable(3)=9.800000
    DHPenetrationTable(4)=9.800000
    DHPenetrationTable(5)=9.800000
    DHPenetrationTable(6)=9.800000
    ShellImpactDamage=class'DH_ATWeapons.DH_BazookaImpactDamType'
    ImpactDamage=575
    Speed=6337.000000
    MaxSpeed=6337.000000
    MyDamageType=class'DH_ATWeapons.DH_BazookaDamType'
    StaticMesh=StaticMesh'DH_WeaponPickups.Ammo.Bazooka_shell'
}

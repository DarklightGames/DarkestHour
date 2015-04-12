//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_BazookaRocket extends DHRocketProjectile;

defaultproperties
{
    StraightFlightTime=0.5
    DHPenetrationTable(0)=9.8
    DHPenetrationTable(1)=9.8
    DHPenetrationTable(2)=9.8
    DHPenetrationTable(3)=9.8
    DHPenetrationTable(4)=9.8
    DHPenetrationTable(5)=9.8
    DHPenetrationTable(6)=9.8
    ShellImpactDamage=class'DH_ATWeapons.DH_BazookaImpactDamType'
    ImpactDamage=575
    Speed=6337.0
    MaxSpeed=6337.0
    MyDamageType=class'DH_ATWeapons.DH_BazookaDamType'
    StaticMesh=StaticMesh'DH_WeaponPickups.Ammo.Bazooka_shell'
}

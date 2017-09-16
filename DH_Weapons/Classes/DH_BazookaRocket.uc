//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
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
    ShellImpactDamage=class'DH_Weapons.DH_BazookaImpactDamType'
    ImpactDamage=350
    BallisticCoefficient=0.0475
    Speed=4967.0
    MaxSpeed=4967.0
    MyDamageType=class'DH_Weapons.DH_BazookaDamType'
    StaticMesh=StaticMesh'DH_WeaponPickups.Ammo.Bazooka_shell'
}

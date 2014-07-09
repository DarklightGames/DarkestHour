//==============================================================================
// DH_BazookaRocket
//
// Darkest Hour Source - (c) Darkest Hour Team 2010
// Red Orchestra Source - (c) Tripwire Interactive 2006
//
// American M1A1 Bazooka M6A1 rocket
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
     bIsHEATRound=True
     ShellImpactDamage=Class'DH_ATWeapons.DH_BazookaImpactDamType'
     ImpactDamage=575
     Speed=6337.000000
     MaxSpeed=6337.000000
     MyDamageType=Class'DH_ATWeapons.DH_BazookaDamType'
     StaticMesh=StaticMesh'DH_WeaponPickups.Ammo.Bazooka_shell'
}

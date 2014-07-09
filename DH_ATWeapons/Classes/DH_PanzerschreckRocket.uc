//==============================================================================
// DH_PanzerschreckRocket
//
// Darkest Hour Source - (c) Darkest Hour Team 2010
// Red Orchestra Source - (c) Tripwire Interactive 2006
//
// German Panzerschreck 54 RPzB.Gr.4992 rocket
//==============================================================================
class DH_PanzerschreckRocket extends DH_RocketProj; //PanzerFaustRocket;

defaultproperties
{
     StraightFlightTime=0.500000
     DHPenetrationTable(0)=17.500000
     DHPenetrationTable(1)=17.500000
     DHPenetrationTable(2)=17.500000
     DHPenetrationTable(3)=17.500000
     DHPenetrationTable(4)=17.500000
     DHPenetrationTable(5)=17.500000
     DHPenetrationTable(6)=17.500000
     bIsHEATRound=True
     bIsAlliedShell=False
     ShellImpactDamage=Class'DH_ATWeapons.DH_PanzerschreckImpactDamType'
     ImpactDamage=625
     Speed=6337.000000
     MaxSpeed=6337.000000
     MyDamageType=Class'DH_ATWeapons.DH_PanzerschreckDamType'
     StaticMesh=StaticMesh'DH_WeaponPickups.Ammo.Panzerschreck_shell'
}

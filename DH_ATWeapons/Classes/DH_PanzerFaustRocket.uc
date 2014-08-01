//==============================================================================
// DH_PanzerFaustRocket
//
// Darkest Hour Source - (c) Darkest Hour Team 2010
// Red Orchestra Source - (c) Tripwire Interactive 2006
//
// Panzerfaust 60 anti-tank weapon
//==============================================================================
class DH_PanzerFaustRocket extends DH_RocketProj; //PanzerFaustRocket;

#exec OBJ LOAD FILE=..\Staticmeshes\DH_Military_Axis.usx

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();

	if (SmokeTrail != none)
	{
		SmokeTrail.HandleOwnerDestroyed();
	}

	if (Corona != none)
	{
		Corona.Destroyed();
	}
}

defaultproperties
{
     StraightFlightTime=0.250000
     DHPenetrationTable(0)=21.500000
     DHPenetrationTable(1)=21.500000
     DHPenetrationTable(2)=21.500000
     DHPenetrationTable(3)=21.500000
     DHPenetrationTable(4)=21.500000
     DHPenetrationTable(5)=21.500000
     DHPenetrationTable(6)=21.500000
     bIsHEATRound=true
     bIsAlliedShell=false
     bHasTracer=false
     ShellImpactDamage=Class'DH_ATWeapons.DH_PanzerFaustImpactDamType'
     ImpactDamage=650
     BallisticCoefficient=0.075000
     Speed=2716.000000
     MaxSpeed=2716.000000
     MyDamageType=Class'DH_ATWeapons.DH_PanzerFaustDamType'
     StaticMesh=StaticMesh'DH_Military_Axis.Weapons.Panzerfaust_warhead'
}

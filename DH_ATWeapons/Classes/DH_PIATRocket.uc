//===================================================================
// DH_PIATRocket
//
// Copyright (C) 2004 John "Ramm-Jaeger"  Gibson
//
// British PIAT Bomb MkII
//===================================================================
class DH_PIATRocket extends DH_RocketProj;



simulated function PostBeginPlay()
{
	Super.PostBeginPlay();

	if ( SmokeTrail != None )
	{
		SmokeTrail.HandleOwnerDestroyed();
	}

	if ( Corona != None )
	{
		Corona.Destroyed();
	}
}

defaultproperties
{
     StraightFlightTime=0.500000
     DHPenetrationTable(0)=9.100000
     DHPenetrationTable(1)=9.100000
     DHPenetrationTable(2)=9.100000
     DHPenetrationTable(3)=9.100000
     DHPenetrationTable(4)=9.100000
     DHPenetrationTable(5)=9.100000
     DHPenetrationTable(6)=9.100000
     bIsHEATRound=True
     bHasTracer=False
     ShellImpactDamage=Class'DH_ATWeapons.DH_PIATImpactDamType'
     ImpactDamage=650
     Speed=4526.000000
     MaxSpeed=4526.000000
     MyDamageType=Class'DH_ATWeapons.DH_PIATDamType'
     StaticMesh=StaticMesh'DH_WeaponPickups.Ammo.PIATBomb_1st'
}

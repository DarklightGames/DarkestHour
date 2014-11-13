//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_PIATRocket extends DH_RocketProj;



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
     StraightFlightTime=0.500000
     DHPenetrationTable(0)=9.100000
     DHPenetrationTable(1)=9.100000
     DHPenetrationTable(2)=9.100000
     DHPenetrationTable(3)=9.100000
     DHPenetrationTable(4)=9.100000
     DHPenetrationTable(5)=9.100000
     DHPenetrationTable(6)=9.100000
     bIsHEATRound=true
     bHasTracer=false
     ShellImpactDamage=Class'DH_ATWeapons.DH_PIATImpactDamType'
     ImpactDamage=650
     Speed=4526.000000
     MaxSpeed=4526.000000
     MyDamageType=Class'DH_ATWeapons.DH_PIATDamType'
     StaticMesh=StaticMesh'DH_WeaponPickups.Ammo.PIATBomb_1st'
}

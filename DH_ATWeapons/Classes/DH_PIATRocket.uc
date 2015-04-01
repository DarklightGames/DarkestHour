//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_PIATRocket extends DH_RocketProj;

defaultproperties
{
    StraightFlightTime=0.5
    DHPenetrationTable(0)=9.1
    DHPenetrationTable(1)=9.1
    DHPenetrationTable(2)=9.1
    DHPenetrationTable(3)=9.1
    DHPenetrationTable(4)=9.1
    DHPenetrationTable(5)=9.1
    DHPenetrationTable(6)=9.1
    bHasTracer=false
    ShellImpactDamage=class'DH_ATWeapons.DH_PIATImpactDamType'
    ImpactDamage=650
    Speed=4526.0
    MaxSpeed=4526.0
    MyDamageType=class'DH_ATWeapons.DH_PIATDamType'
    StaticMesh=StaticMesh'DH_WeaponPickups.Ammo.PIATBomb_1st'
}

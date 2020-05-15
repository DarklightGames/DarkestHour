//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2020
//==============================================================================

class DH_PIATRocket extends DHRocketProjectile;

defaultproperties
{
    Speed=4587.0   //~76 m/s or 250 ft/s
    MaxSpeed=4587.0
    StraightFlightTime=0.5

    //Damage
    ImpactDamage=650
    DamageRadius=300
    ShellImpactDamage=class'DH_Weapons.DH_PIATImpactDamType'
    MyDamageType=class'DH_Weapons.DH_PIATDamType'

    //Effects
    bHasTracer=false
    bHasSmokeTrail=false
    StaticMesh=StaticMesh'DH_WeaponPickups.Ammo.PIATBomb_1st'
    DrawScale=0.6 // reduced size, the mesh is huge!

    //Penetration
    DHPenetrationTable(0)=9.1
    DHPenetrationTable(1)=9.1
    DHPenetrationTable(2)=9.1
    DHPenetrationTable(3)=9.1
    DHPenetrationTable(4)=9.1
    DHPenetrationTable(5)=9.1
    DHPenetrationTable(6)=9.1
}

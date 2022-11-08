//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DH_PIATRocket extends DHRocketProjectile;

defaultproperties
{
    Speed=4587.0   //~76 m/s or 250 ft/s
    MaxSpeed=4587.0
    StraightFlightTime=0.5

    //Damage
	Damage=800
	DamageRadius=600  //1.1 KG
    ShellImpactDamage=class'DH_Weapons.DH_PIATImpactDamType'
    MyDamageType=class'DH_Weapons.DH_PIATDamType'

    //Effects
    bHasTracer=false
    bHasSmokeTrail=false
    StaticMesh=StaticMesh'DH_WeaponPickups.Ammo.PIATBomb'

    //Penetration
    DHPenetrationTable(0)=9.1
    DHPenetrationTable(1)=9.1
    DHPenetrationTable(2)=9.1
    DHPenetrationTable(3)=9.1
    DHPenetrationTable(4)=9.1
    DHPenetrationTable(5)=9.1
    DHPenetrationTable(6)=9.1

    VehicleHitSound=Sound'DH_WeaponSounds.faust.faust_explode011'
    DirtHitSound=Sound'DH_WeaponSounds.faust.faust_explode031'
    RockHitSound=Sound'DH_WeaponSounds.faust.faust_explode011'
    WoodHitSound=Sound'DH_WeaponSounds.faust.faust_explode021'
    WaterHitSound=Sound'ProjectileSounds.cannon_rounds.AP_Impact_Water'
    VehicleDeflectSound=Sound'Vehicle_Weapons.Hits.HE_deflect01'

    ExplosionSound(0)=Sound'DH_WeaponSounds.faust.faust_explode011'
    ExplosionSound(1)=Sound'DH_WeaponSounds.faust.faust_explode021'
    ExplosionSound(2)=Sound'DH_WeaponSounds.faust.faust_explode031'

    bDeflectAOI=true
    DeflectAOI=30.0
    bExplodesOnArmor=false
}

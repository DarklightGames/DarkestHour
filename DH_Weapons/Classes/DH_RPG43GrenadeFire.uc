//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DH_RPG43GrenadeFire extends DHThrownExplosiveFire;

defaultproperties
{
    ProjectileClass=class'DH_Weapons.DH_RPG43GrenadeProjectile'
    AmmoClass=class'DH_Weapons.DH_RPG43GrenadeAmmo'
    MaxHoldTime=60.0 // why hold a grenade for more than a minute?
    bSplashDamage=false
    bRecommendSplashDamage=false
    AddedFuseTime=9.0  // should be enough for the grenade to fly and land somewhere, so if it doesnt explode for some reason it will few seconds after
}

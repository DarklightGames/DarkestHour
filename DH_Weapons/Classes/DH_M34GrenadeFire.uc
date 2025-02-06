//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_M34GrenadeFire extends DHThrownExplosiveFire;

defaultproperties
{
    ProjectileClass=class'DH_Weapons.DH_M34GrenadeProjectile'
    AmmoClass=class'DH_Weapons.DH_M34GrenadeAmmo'
    bSplashDamage=false
    bRecommendSplashDamage=false
    AddedFuseTime=9.0  // should be enough for the grenade to fly and land somewhere, so if it doesnt explode for some reason it will few seconds after
}

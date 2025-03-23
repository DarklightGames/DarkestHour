//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_RPG43GrenadeFire extends DHThrownExplosiveFire;

defaultproperties
{
    ProjectileClass=class'DH_Weapons.DH_RPG43GrenadeProjectile'
    AmmoClass=class'DH_Weapons.DH_RPG43GrenadeAmmo'
    MinHoldTime=0.5
    bSplashDamage=false
    bRecommendSplashDamage=false
    AddedFuseTime=9.0  // should be enough for the grenade to fly and land somewhere, so if it doesnt explode for some reason it will few seconds after
    MinimumThrowSpeed=600.0
    MaximumThrowSpeed=780.0
    SpeedFromHoldingPerSec=600.0
}

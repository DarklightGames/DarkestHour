//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_LTypeGrenadeFire extends DHThrownExplosiveFire;

defaultproperties
{
    ProjectileClass=Class'DH_LTypeGrenadeProjectile'
    AmmoClass=Class'DH_LTypeGrenadeAmmo'
    MinHoldTime=0.4
    bSplashDamage=false
    bRecommendSplashDamage=false
    AddedFuseTime=9.0  // should be enough for the grenade to fly and land somewhere, so if it doesnt explode for some reason it will few seconds after
    MinimumThrowSpeed=500
    MaximumThrowSpeed=750
    SpeedFromHoldingPerSec=400.0
}

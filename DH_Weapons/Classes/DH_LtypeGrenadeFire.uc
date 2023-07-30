//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_LTypeGrenadeFire extends DHThrownExplosiveFire;

defaultproperties
{
    ProjectileClass=class'DH_Weapons.DH_LTypeGrenadeProjectile'
    AmmoClass=class'DH_Weapons.DH_LTypeGrenadeAmmo'
    MaxHoldTime=160.0
    MinHoldTime=1.0
    bSplashDamage=false
    bRecommendSplashDamage=false
    AddedFuseTime=9.0  // should be enough for the grenade to fly and land somewhere, so if it doesnt explode for some reason it will few seconds after
    MinimumThrowSpeed=500
    MaximumThrowSpeed=750
    SpeedFromHoldingPerSec=400.0
}

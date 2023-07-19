//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_LtypeGrenadeFire extends DHThrownExplosiveFire;

defaultproperties
{
    ProjectileClass=class'DH_Weapons.DH_LtypeGrenadeProjectile'
    AmmoClass=class'DH_Weapons.DH_LtypeGrenadeAmmo'
    MaxHoldTime=160.0
    MinHoldTime=0.5
    bSplashDamage=false
    bRecommendSplashDamage=false
    AddedFuseTime=9.0  // should be enough for the grenade to fly and land somewhere, so if it doesnt explode for some reason it will few seconds after
    MinimumThrowSpeed=500.0
    MaximumThrowSpeed=700.0
    SpeedFromHoldingPerSec=300.0
}

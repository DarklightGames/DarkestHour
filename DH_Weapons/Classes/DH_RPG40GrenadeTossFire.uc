//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2020
//==============================================================================

class DH_RPG40GrenadeTossFire extends DHThrownExplosiveFire;

defaultproperties
{
    ProjectileClass=class'DH_Weapons.DH_RPG40GrenadeProjectile'
    AmmoClass=class'DH_Weapons.DH_RPG40GrenadeAmmo'

    AddedPitch=0
    MinimumThrowSpeed=100.0
    MaximumThrowSpeed=500.0
    SpeedFromHoldingPerSec=800.0

    // TODO: Add toss animation.
    // FireAnim="Toss"

    bSplashDamage=false
    bRecommendSplashDamage=false
}

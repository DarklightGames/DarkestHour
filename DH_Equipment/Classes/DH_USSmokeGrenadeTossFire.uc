//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_USSmokeGrenadeTossFire extends DH_M1GrenadeTossFire;

defaultproperties
{
    AmmoClass=class'DH_Equipment.DH_USSmokeGrenadeAmmo'
    ProjectileClass=class'DH_Equipment.DH_USSmokeGrenadeProjectile'

    bIsSmokeGrenade=true
    MaxHoldTime=4.95
    bSplashDamage=false
    bRecommendSplashDamage=false
}

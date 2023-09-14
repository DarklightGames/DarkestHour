//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_USSmokeGrenadeTossFire extends DH_M1GrenadeTossFire;

defaultproperties
{
    ProjectileClass=class'DH_Equipment.DH_USSmokeGrenadeProjectile'
    AmmoClass=class'DH_Equipment.DH_USSmokeGrenadeAmmo'
    bIsSmokeGrenade=true
    MaxHoldTime=4.95
    bSplashDamage=false
    bRecommendSplashDamage=false
}

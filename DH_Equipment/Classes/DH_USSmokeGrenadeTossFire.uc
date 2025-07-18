//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_USSmokeGrenadeTossFire extends DH_M1GrenadeTossFire;

defaultproperties
{
    ProjectileClass=Class'DH_USSmokeGrenadeProjectile'
    AmmoClass=Class'DH_USSmokeGrenadeAmmo'
    bIsSmokeGrenade=true
    bSplashDamage=false
    bRecommendSplashDamage=false
}

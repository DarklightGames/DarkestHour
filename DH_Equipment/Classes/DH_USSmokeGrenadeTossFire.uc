//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_USSmokeGrenadeTossFire extends DH_M1GrenadeTossFire;

defaultproperties
{
    ProjectileClass=class'DH_Equipment.DH_USSmokeGrenadeProjectile'
    AmmoClass=class'DH_Equipment.DH_USSmokeGrenadeAmmo'
    bIsSmokeGrenade=true
    bSplashDamage=false
    bRecommendSplashDamage=false
}

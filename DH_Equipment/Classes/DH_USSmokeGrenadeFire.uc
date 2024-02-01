//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_USSmokeGrenadeFire extends DHThrownExplosiveFire;

defaultproperties
{
    ProjectileClass=class'DH_Equipment.DH_USSmokeGrenadeProjectile'
    AmmoClass=class'DH_Equipment.DH_USSmokeGrenadeAmmo'
    bIsSmokeGrenade=true
    bPullAnimCompensation=true
    AddedFuseTime=0.38
    bSplashDamage=false
    bRecommendSplashDamage=false
}

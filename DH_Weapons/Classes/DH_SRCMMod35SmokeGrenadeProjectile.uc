//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_SRCMMod35SmokeGrenadeProjectile extends DHGrenadeProjectile_Smoke;

defaultproperties
{
    StaticMesh=StaticMesh'WeaponPickupSM.Projectile.F1grenade-throw'    // TODO: replace
    LifeSpan=600.0  // 5 minutes, since they can lay active on the ground if the impact doesn't detonate them.
    bProjTarget=true    // Projectiles can shoot this thing (needed so PLT will work!)
    Speed=1300.0    // Slighly faster than the standard grenade since it's smaller and lighter.
    FuzeType=FT_Impact
    SmokeType=ST_WhitePhosphorus
}

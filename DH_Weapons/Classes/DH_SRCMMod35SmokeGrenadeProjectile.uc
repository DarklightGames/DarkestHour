//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_SRCMMod35SmokeGrenadeProjectile extends DHGrenadeProjectile_Smoke;

defaultproperties
{
    SmokeAttachmentClass=class'DH_Effects.DHSmokeEffectAttachment_WP'
    StaticMesh=StaticMesh'DH_SRCMMod35_stc.srcm_smoke_projectile'
    LifeSpan=600.0  // 5 minutes, since they can lay active on the ground if the impact doesn't detonate them.
    bProjTarget=true    // Projectiles can shoot this thing (needed so PLT will work!)
    Speed=1300.0    // Slighly faster than the standard grenade since it's smaller and lighter.
    FuzeType=FT_Impact
    SmokeType=ST_WhitePhosphorus
    SpoonProjectileClass=class'DH_Weapons.DH_SRCMMod35SpoonProjectile'
    Damage=100.0
    DamageRadius=120.0
    MyDamageType=class'DH_Engine.DHShellSmokeWPDamageType'
    ExplosionSound(0)=SoundGroup'DH_WeaponSounds.WPGrenade.WPGrenade_Explosions'
    ExplosionSound(1)=SoundGroup'DH_WeaponSounds.WPGrenade.WPGrenade_Explosions'
    ExplosionSound(2)=SoundGroup'DH_WeaponSounds.WPGrenade.WPGrenade_Explosions'
}

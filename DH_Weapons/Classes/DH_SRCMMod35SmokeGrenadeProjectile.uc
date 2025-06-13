//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_SRCMMod35SmokeGrenadeProjectile extends DHGrenadeProjectile_Smoke;

defaultproperties
{
    SmokeAttachmentClass=Class'DHSmokeEffectAttachment_WP'
    StaticMesh=StaticMesh'DH_SRCMMod35_stc.srcm_smoke_projectile'
    LifeSpan=600.0  // 5 minutes, since they can lay active on the ground if the impact doesn't detonate them.
    bProjTarget=true    // Projectiles can shoot this thing (needed so PLT will work!)
    Speed=1300.0    // Slighly faster than the standard grenade since it's smaller and lighter.
    FuzeType=FT_Impact
    SmokeType=ST_WhitePhosphorus
    SpoonProjectileClass=Class'DH_SRCMMod35SpoonProjectile'
    Damage=100.0
    DamageRadius=120.0
    MyDamageType=Class'DHShellSmokeWPDamageType'
    ExplosionSound(0)=SoundGroup'DH_WeaponSounds.WPGrenade_Explosions'
    ExplosionSound(1)=SoundGroup'DH_WeaponSounds.WPGrenade_Explosions'
    ExplosionSound(2)=SoundGroup'DH_WeaponSounds.WPGrenade_Explosions'
}

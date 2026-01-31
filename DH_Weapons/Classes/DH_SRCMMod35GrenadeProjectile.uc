//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_SRCMMod35GrenadeProjectile extends DHGrenadeProjectile;

defaultproperties
{
    Damage=120.0 //43 grams
    DamageRadius=603.0
    MyDamageType=Class'DH_SRCMMod35GrenadeDamageType'
    StaticMesh=StaticMesh'DH_SRCMMod35_stc.srcm_frag_projectile'
    ExplosionSound(0)=SoundGroup'Inf_Weapons.f1_explode01'
    ExplosionSound(1)=SoundGroup'Inf_Weapons.f1_explode02'
    ExplosionSound(2)=SoundGroup'Inf_Weapons.f1_explode03'
    FuzeType=FT_Impact
    LifeSpan=600.0  // 5 minutes, since they can lay active on the ground if the impact doesn't detonate them.
    bProjTarget=true    // Projectiles can shoot this thing (needed so PLT will work!)
    Speed=1300.0    // Slighly faster than the standard grenade since it's smaller and lighter, throw distance roughly 25m.
    SpoonProjectileClass=Class'DH_SRCMMod35SpoonProjectile'
}

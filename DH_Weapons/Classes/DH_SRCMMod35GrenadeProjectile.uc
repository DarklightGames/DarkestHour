//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_SRCMMod35GrenadeProjectile extends DHGrenadeProjectile;

defaultproperties
{
    // TODO: this is a tiny boy, so the damage probably needs to be reduced
    Damage=150.0
    DamageRadius=700.0
    MyDamageType=class'DH_Weapons.DH_SRCMMod35GrenadeDamageType'
    StaticMesh=StaticMesh'DH_SRCMMod35_stc.srcm_frag_projectile'
    ExplosionSound(0)=SoundGroup'Inf_Weapons.F1.f1_explode01'
    ExplosionSound(1)=SoundGroup'Inf_Weapons.F1.f1_explode02'
    ExplosionSound(2)=SoundGroup'Inf_Weapons.F1.f1_explode03'
    FuzeType=FT_Impact
    LifeSpan=600.0  // 5 minutes, since they can lay active on the ground if the impact doesn't detonate them.
    bProjTarget=true    // Projectiles can shoot this thing (needed so PLT will work!)
    Speed=1300.0    // Slighly faster than the standard grenade since it's smaller and lighter.
}

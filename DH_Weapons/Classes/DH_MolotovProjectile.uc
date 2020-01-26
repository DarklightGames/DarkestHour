//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DH_MolotovProjectile extends DHGrenadeProjectile;

defaultproperties
{
    MyDamageType = class'DH_Weapons.DHBurningDamageType'
    
    StaticMesh = StaticMesh'WeaponPickupSM.Projectile.Stielhandgranate_throw'
    ExplosionSound(0) = SoundGroup'Inf_Weapons.stielhandgranate24.stielhandgranate24_explode01'
    ExplosionSound(1) = SoundGroup'Inf_Weapons.stielhandgranate24.stielhandgranate24_explode02'
    ExplosionSound(2) = SoundGroup'Inf_Weapons.stielhandgranate24.stielhandgranate24_explode03'
    
    Damage = 180.0
    DamageRadius = 639.0
    bIsStickGrenade = true
    Bounces = 0

    FuzeLengthTimer = 4.5
    Speed = 800.0
    ExplodeDirtEffectClass = class'GrenadeExplosion'
    ExplodeSnowEffectClass = class'GrenadeExplosionSnow'
    ExplodeMidAirEffectClass = class'GrenadeExplosion_midair'
}

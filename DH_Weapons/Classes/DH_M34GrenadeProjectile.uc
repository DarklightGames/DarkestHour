//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_M34GrenadeProjectile extends DHGrenadeProjectile;

// Extends a HEAT projectile to make use of the impact fuze.
// This is NOT an anti-tank grenade, so penetration values are small.

defaultproperties
{
    StaticMesh=StaticMesh'DH_WeaponPickups.Ammo.m34_throw'
    Speed=1100.0
    MaxSpeed=2000.0

    FuzeType=FT_Impact
    LifeSpan=600.0  // 5 minutes, since they can lay active on the ground if the impact doesn't detonate them.
    bProjTarget=true    // Projectiles can shoot this thing (needed so PLT will work!)

    // Damage
    Damage=160.0  //100 gramms tnt
    DamageRadius=450
    MomentumTransfer=8000.0
    MyDamageType=class'DH_Weapons.DH_m34GrenadeDamType'

    // Sounds
    ExplosionSoundVolume=3.0
    ImpactSound=Sound'Inf_Weapons_Foley.grenadeland'
    WaterHitSound=SoundGroup'ProjectileSounds.Bullets.Impact_Water'
    ExplosionSound(0)=SoundGroup'Inf_Weapons.stielhandgranate24.stielhandgranate24_explode01'
    ExplosionSound(1)=SoundGroup'Inf_Weapons.stielhandgranate24.stielhandgranate24_explode02'
    ExplosionSound(2)=SoundGroup'Inf_Weapons.stielhandgranate24.stielhandgranate24_explode03'
}

//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_F1GrenadeProjectile extends DHGrenadeProjectile;

defaultproperties
{
    Damage=150.0
    DamageRadius=700.0
    MyDamageType=class'DH_Weapons.DH_F1GrenadeDamType'
    StaticMesh=StaticMesh'WeaponPickupSM.Projectile.F1grenade-throw'
    ExplosionSound(0)=SoundGroup'Inf_Weapons.F1.f1_explode01'
    ExplosionSound(1)=SoundGroup'Inf_Weapons.F1.f1_explode02'
    ExplosionSound(2)=SoundGroup'Inf_Weapons.F1.f1_explode03'
    SpoonProjectileClass=class'DH_Weapons.DH_F1GrenadeSpoonProjectile'
}

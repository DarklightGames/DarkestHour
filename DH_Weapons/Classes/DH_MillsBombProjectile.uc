//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_MillsBombProjectile extends DHGrenadeProjectile;

defaultproperties
{
    MyDamageType=Class'DH_MillsBombDamType'
    StaticMesh=StaticMesh'DH_WeaponPickups.MillsBomb'
    ExplosionSound(0)=SoundGroup'Inf_Weapons.f1_explode01'
    ExplosionSound(1)=SoundGroup'Inf_Weapons.f1_explode02'
    ExplosionSound(2)=SoundGroup'Inf_Weapons.f1_explode03'
    Damage=140.0
    DamageRadius=785.0
    Speed=1000.0
}

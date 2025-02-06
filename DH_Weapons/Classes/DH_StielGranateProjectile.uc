//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_StielGranateProjectile extends DHGrenadeProjectile;

defaultproperties
{
    MyDamageType=class'DH_Weapons.DH_StielGranateDamType'
    StaticMesh=StaticMesh'WeaponPickupSM.Projectile.Stielhandgranate_throw'
    ExplosionSound(0)=SoundGroup'Inf_Weapons.stielhandgranate24.stielhandgranate24_explode01'
    ExplosionSound(1)=SoundGroup'Inf_Weapons.stielhandgranate24.stielhandgranate24_explode02'
    ExplosionSound(2)=SoundGroup'Inf_Weapons.stielhandgranate24.stielhandgranate24_explode03'
    Damage=180.0
    DamageRadius=639.0
    SpinType=ST_Tumble
}

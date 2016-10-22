//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_F1GrenadeProjectile extends DHGrenadeProjectile;

defaultproperties
{
    ExplosionSound(0)=SoundGroup'Inf_Weapons.F1.f1_explode01'
    ExplosionSound(1)=SoundGroup'Inf_Weapons.F1.f1_explode02'
    ExplosionSound(2)=SoundGroup'Inf_Weapons.F1.f1_explode03'
    Damage=150.0
    DamageRadius=700.0
    MyDamageType=class'DH_Weapons.DH_F1GrenadeDamType'
    StaticMesh=StaticMesh'WeaponPickupSM.Projectile.F1grenade-throw'
}

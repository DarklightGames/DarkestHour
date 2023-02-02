//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_M1GrenadeProjectile extends DHGrenadeProjectile;

defaultproperties
{
    MyDamageType=class'DH_Weapons.DH_M1GrenadeDamType'
    StaticMesh=StaticMesh'DH_WeaponPickups.Ammo.M1Grenade_throw'
    ExplosionSound(0)=SoundGroup'Inf_Weapons.F1.f1_explode01'
    ExplosionSound(1)=SoundGroup'Inf_Weapons.F1.f1_explode02'
    ExplosionSound(2)=SoundGroup'Inf_Weapons.F1.f1_explode03'
    Damage=140.0
    DamageRadius=785.0
    Speed=1000.0
}

//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_MkIIIGrenadeProjectile extends DHGrenadeProjectile;

defaultproperties
{
    Damage=150.0
    DamageRadius=700.0
    MyDamageType=class'DH_Weapons.DH_MkIIIGrenadeDamType'
    StaticMesh=StaticMesh'DH_WeaponPickups.Ammo.Mk3Grenade_throw'
    ExplosionSound(0)=SoundGroup'Inf_Weapons.stielhandgranate24.stielhandgranate24_explode01'  //adjust the volume
    ExplosionSound(1)=SoundGroup'Inf_Weapons.stielhandgranate24.stielhandgranate24_explode02'
    ExplosionSound(2)=SoundGroup'Inf_Weapons.stielhandgranate24.stielhandgranate24_explode03'
}

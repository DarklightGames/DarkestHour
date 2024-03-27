//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_RG42GrenadeProjectile extends DHGrenadeProjectile;

defaultproperties
{
    Damage=150.0
    DamageRadius=700.0
    MyDamageType=class'DH_Weapons.DH_RG42GrenadeDamType'
    //StaticMesh=StaticMesh'WeaponPickupSM.Projectile.F1grenade-throw'  CHANGE THIS
    ExplosionSound(0)=SoundGroup'Inf_Weapons.stielhandgranate24.stielhandgranate24_explode01'  //this should have a slightly lowered volume, but i couldnt find the value responsible for this
    ExplosionSound(1)=SoundGroup'Inf_Weapons.stielhandgranate24.stielhandgranate24_explode02'
    ExplosionSound(2)=SoundGroup'Inf_Weapons.stielhandgranate24.stielhandgranate24_explode03'
}

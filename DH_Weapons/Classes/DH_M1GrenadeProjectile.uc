//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_M1GrenadeProjectile extends DH_GrenadeProjectile;

defaultproperties
{
    FuzeLengthTimer=4.0 // Matt: added as default is now 4.5 instead of 4.0
    ExplosionSound(0)=SoundGroup'Inf_Weapons.F1.f1_explode01'
    ExplosionSound(1)=SoundGroup'Inf_Weapons.F1.f1_explode02'
    ExplosionSound(2)=SoundGroup'Inf_Weapons.F1.f1_explode03'
    Damage=140.000000
    DamageRadius=785.000000
    MyDamageType=class'DH_Weapons.DH_M1GrenadeDamType'
    Speed=1000.0 // Matt: added as default is now 1100 instead of 1000
    StaticMesh=StaticMesh'DH_WeaponPickups.Ammo.M1Grenade_throw'
}

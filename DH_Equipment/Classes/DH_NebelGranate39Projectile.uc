//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_NebelGranate39Projectile extends DHGrenadeProjectile_Smoke;

defaultproperties
{
    StaticMesh=StaticMesh'WeaponPickupSM.Projectile.gersmokenade_throw'
    SpinType=ST_Tumble
    MyDamageType=class'DH_Equipment.DH_NebelGranate39DamType'
}

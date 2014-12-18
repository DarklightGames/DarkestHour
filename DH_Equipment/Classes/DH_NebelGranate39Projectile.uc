//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//
// Grenade projectile for the German NebelHandGranate 39 smoke grenade
//==============================================================================

class DH_NebelGranate39Projectile extends DH_GrenadeProjectile_Smoke;

defaultproperties
{
    bIsStickGrenade=true
    MyDamageType=class'DH_Equipment.DH_NebelGranate39DamType'
    StaticMesh=StaticMesh'WeaponPickupSM.Projectile.gersmokenade_throw'
}

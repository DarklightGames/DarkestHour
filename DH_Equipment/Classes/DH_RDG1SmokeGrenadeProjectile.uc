//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_RDG1SmokeGrenadeProjectile extends DHGrenadeProjectile_Smoke;

defaultproperties
{
    StaticMesh=StaticMesh'WeaponPickupSM.Projectile.RGD1_throw'
    bIsStickGrenade=true
    MyDamageType=class'DH_Equipment.DH_RDG1SmokeGrenadeDamType'
}

//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_RedSmokeProjectile extends DH_GrenadeProjectile_Smoke;

defaultproperties
{
    MyDamageType=class'DH_Equipment.DH_RedSmokeDamType'
    StaticMesh=StaticMesh'DH_WeaponPickups.Ammo.US_RedSmokeGrenade_throw'
    SmokeEmitterClass=class'DH_Effects.DH_RedSmokeEffect'
}

//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_RedSmokeProjectile extends DHGrenadeProjectile_Smoke;

defaultproperties
{
    StaticMesh=StaticMesh'DH_WeaponPickups.Ammo.US_RedSmokeGrenade_throw'
    SmokeEmitterClass=class'DH_Effects.DHSmokeEffect_Red'
    MyDamageType=class'DH_Equipment.DH_RedSmokeDamType'
}

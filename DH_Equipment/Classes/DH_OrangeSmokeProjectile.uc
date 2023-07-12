//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_OrangeSmokeProjectile extends DHGrenadeProjectile_Smoke;

defaultproperties
{
    StaticMesh=StaticMesh'DH_WeaponPickups.Ammo.Ger_OrangeSmokeGrenade_throw'
    SmokeEmitterClass=class'DH_Effects.DHSmokeEffect_Orange'
    MyDamageType=class'DH_Equipment.DH_OrangeSmokeDamType'
}

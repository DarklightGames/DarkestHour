//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_OrangeSmokeProjectile extends DHGrenadeProjectile_Smoke;

defaultproperties
{
    MyDamageType=class'DH_Equipment.DH_OrangeSmokeDamType'
    StaticMesh=StaticMesh'DH_WeaponPickups.Ammo.Ger_OrangeSmokeGrenade_throw'
    SmokeEmitterClass=class'DH_Effects.DH_OrangeSmokeEffect'
}

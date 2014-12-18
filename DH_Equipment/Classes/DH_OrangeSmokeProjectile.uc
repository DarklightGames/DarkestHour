//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_OrangeSmokeProjectile extends DH_GrenadeProjectile_Smoke;

defaultproperties
{
    LifeSpan=50.000000
    DestroyTimer=50.000000
    ExplodeDirtEffectClass=class'DH_Effects.DH_OrangeSmokeEffect'
    MyDamageType=class'DH_Equipment.DH_OrangeSmokeDamType'
    StaticMesh=StaticMesh'DH_WeaponPickups.Ammo.Ger_OrangeSmokeGrenade_throw'
    SoundRadius=300.000000
}

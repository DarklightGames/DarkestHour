//=============================================================================
// DH_RedSmokeProjectile
//=============================================================================

class DH_RedSmokeProjectile extends DH_GrenadeProjectile_Smoke;

defaultproperties
{
    LifeSpan=50.000000
    DestroyTimer=50.000000
    ExplodeDirtEffectClass=Class'DH_Effects.DH_RedSmokeEffect'
    MyDamageType=Class'DH_Equipment.DH_RedSmokeDamType'
    StaticMesh=StaticMesh'DH_WeaponPickups.Ammo.US_RedSmokeGrenade_throw'
    SoundRadius=300.000000
}

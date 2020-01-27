//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DH_MolotovProjectile extends DHGrenadeProjectile;

defaultproperties
{
    MyDamageType = class'DHBurningDamageType'
    
    StaticMesh = StaticMesh'DH_WeaponPickups.Projectile.MolotovCocktail_throw'
    
    Damage = 180.0
    DamageRadius = 639.0
    bIsStickGrenade = true
    Bounces = 0

    FuzeLengthTimer = 4.5
    Speed = 800.0
    ExplodeDirtEffectClass = class'GrenadeExplosion'
    ExplodeSnowEffectClass = class'GrenadeExplosionSnow'
    ExplodeMidAirEffectClass = class'GrenadeExplosion_midair'
}

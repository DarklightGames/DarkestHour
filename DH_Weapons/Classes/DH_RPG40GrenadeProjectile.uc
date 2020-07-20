//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2020
//==============================================================================
// TODO:
//  * Add satchel anti-tank functionality.
//  * Add a pickup class (requires implementaion in the superclass)
//  * Replace explosion effects and sounds.

class DH_RPG40GrenadeProjectile extends DHThrowableExplosiveProjectile;

defaultproperties
{
    StaticMesh=StaticMesh'DH_RPG40Grenade_stc.Weapon.RPG40Grenade'

    // Impact
    bExplodeOnImpact=true
    MaxImpactAOIToExplode=90.0
    MinImpactSpeedToExplode=0.0

    // Damage
    Damage=760.0 // 760 grams of TNT
    DamageRadius=700.0

    MyDamageType=class'DH_Weapons.DH_RPG40GrenadeDamType'

    // Effects
    ExplosionDecal=class'ROEffects.GrenadeMark'
    ExplosionDecalSnow=class'ROEffects.GrenadeMarkSnow'
    ExplodeDirtEffectClass=class'GrenadeExplosion'
    ExplodeSnowEffectClass=class'GrenadeExplosion'
    ExplodeMidAirEffectClass=class'GrenadeExplosion'

    // Sounds
    ExplosionSound(0)=SoundGroup'DH_WeaponSounds.RPG43.RPG43_explode01'
    ExplosionSound(1)=SoundGroup'DH_WeaponSounds.RPG43.RPG43_explode02'
    ExplosionSound(2)=SoundGroup'DH_WeaponSounds.RPG43.RPG43_explode03'
    ImpactSound=Sound'Inf_Weapons_Foley.grenadeland'
}

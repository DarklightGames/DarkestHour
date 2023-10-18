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
    StaticMesh=StaticMesh'DH_WeaponPickups.Ammo.RPG40'

    // Impact
    bExplodeOnImpact=true
    MaxImpactAOIToExplode=90.0
    MinImpactSpeedToExplode=0.0

    // Damage
    Damage=760.0 // 760 grams of TNT
    DamageRadius=780.0

    MyDamageType=class'DH_Weapons.DH_RPG40GrenadeDamType'

    // Effects
    ExplosionDecal=class'ROEffects.GrenadeMark'
    ExplosionDecalSnow=class'ROEffects.GrenadeMarkSnow'
    ExplodeDirtEffectClass=class'GrenadeExplosion'
    ExplodeSnowEffectClass=class'GrenadeExplosion'
    ExplodeMidAirEffectClass=class'GrenadeExplosion'

    // Sounds
    ExplosionSound(0)=SoundGroup'DH_MN_InfantryWeapons_sound.PIAT.PiatExp01'
    ExplosionSound(1)=SoundGroup'DH_MN_InfantryWeapons_sound.PIAT.PiatExp01'
    ExplosionSound(2)=SoundGroup'DH_MN_InfantryWeapons_sound.PIAT.PiatExp01'
    ImpactSound=Sound'Inf_Weapons_Foley.grenadeland'
    //ExplosionSoundVolume=10.0

    //EngineDamageMassThreshold=15.1
    //EngineDamageRadius=220.0
    //EngineDamageMax=800.0

    //TreadDamageMassThreshold=10.0
    //TreadDamageRadius=60.0
    //TreadDamageMax=100.0

    BlurTime=3.0
    ShakeRotTime=1.0
    ShakeScale=1.0
}

//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_LTypeGrenadeProjectile extends DHThrowableHEATProjectile;

// Extends a HEAT projectile to make use of the impact fuze.
// This is NOT a HEAT grenade, so penetration values are small.

defaultproperties
{
    Speed=750.0  // reduced from 1100 as it was a VERY heavy grenade
    MaxSpeed=780.0
    ShellDiameter=10.5
    LifeSpan=10.0       // used in case the grenade fails to detonate on impact (will lie around for a bit for effect, then disappear)
    PickupClass=Class'DH_LTypeGrenadePickup'
    bIsStickGrenade=true

    // Impact fuze
    bExplodesOnHittingWater=false
    MaxImpactAOIToExplode=90.0
    MinImpactSpeedToExplode=1.0
    MaxVerticalAOIForTopArmor=3.0

    // Armour penetration
    //Not a HEAT grenade but still an AT grenade
    DHPenetrationTable(0)=1.0
    DHPenetrationTable(1)=1.0
    DHPenetrationTable(2)=1.0
    DHPenetrationTable(3)=1.0
    DHPenetrationTable(4)=1.0
    DHPenetrationTable(5)=1.0
    DHPenetrationTable(6)=1.0
    DHPenetrationTable(7)=1.0
    DHPenetrationTable(8)=1.0
    DHPenetrationTable(9)=1.0
    DHPenetrationTable(10)=1.0

    // Damage
    ImpactDamage=600
    Damage=600.0
    DamageRadius=910 //This thing is absolutely huge, 1.5kg of explosive charg, however HE effect only
                     //calculated that the lethal effective radius is around 15 meters give or take
    EngineFireChance=0.9
    ShellImpactDamage=Class'DH_LTypeGrenadeImpactDamType'
    MyDamageType=Class'DH_LTypeGrenadeDamType'

    // Effects
    StaticMesh=StaticMesh'DH_LType_stc.ltype_throw'
    ShellHitDirtEffectClass=Class'ROSatchelExplosion'
    ShellHitWoodEffectClass=Class'ROSatchelExplosion'
    ShellHitRockEffectClass=Class'ROSatchelExplosion'
    ShellHitSnowEffectClass=Class'ROSatchelExplosion'
    ShellHitWaterEffectClass=Class'ROBulletHitWaterEffect'
    ShellHitVehicleEffectClass=Class'DHPanzerfaustHitTank'
    ShellDeflectEffectClass=Class'GrenadeExplosion'

    ExplosionDecal=Class'GrenadeMark'
    ExplosionDecalSnow=Class'GrenadeMarkSnow'

    // Sounds
    ExplosionSoundVolume=8.0 // seems high but TransientSoundVolume is only 0.3, compared to 1.0 for a shell
    VehicleHitSound=SoundGroup'DH_MN_InfantryWeapons_sound.GeballteLadungExp01'
    VehicleDeflectSound=Sound'DH_WeaponSounds.faust_explode021'
    ImpactSound=Sound'DH_WeaponSounds.faust_explode021'
    DirtHitSound=Sound'DH_WeaponSounds.faust_explode021'
    RockHitSound=Sound'DH_WeaponSounds.faust_explode021'
    WoodHitSound=Sound'DH_WeaponSounds.faust_explode021'
    WaterHitSound=SoundGroup'ProjectileSounds.Impact_Water'
    ExplosionSound(0)=SoundGroup'DH_MN_InfantryWeapons_sound.GeballteLadungExp01'
    ExplosionSound(1)=SoundGroup'DH_MN_InfantryWeapons_sound.GeballteLadungExp01'
    ExplosionSound(2)=SoundGroup'DH_MN_InfantryWeapons_sound.GeballteLadungExp01'
}

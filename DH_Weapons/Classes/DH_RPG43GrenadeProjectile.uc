//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DH_RPG43GrenadeProjectile extends DHThrowableHEATProjectile;

defaultproperties
{
    Speed=700.0  // reduced from 1100 as it was heavy grenade
    MaxSpeed=700.0
    ShellDiameter=9.5
    bOrientToVelocity=true // so grenade doesn't spin & faces the way it's travelling, as was stablised by trailing crude 'minute chute'
    LifeSpan=10.0          // used in case the grenade fails to detonate on impact (will lie around for a bit for effect, then disappear)
    PickupClass=class'DH_Weapons.DH_RPG43GrenadePickup'

    // Impact fuze
    bExplodesOnHittingWater=false
    MaxImpactAOIToExplode=70.0
    MinImpactSpeedToExplode=1.0
    MaxVerticalAOIForTopArmor=33.0

    // Armour penetration
    DHPenetrationTable(0)=7.6  //7.5, but set to 7.6 so it will penetrate 75 mm with slight angle imperfection
    DHPenetrationTable(1)=7.6
    DHPenetrationTable(2)=7.6
    DHPenetrationTable(3)=7.6
    DHPenetrationTable(4)=7.6
    DHPenetrationTable(5)=7.5
    DHPenetrationTable(6)=7.5
    DHPenetrationTable(7)=7.5
    DHPenetrationTable(8)=7.5
    DHPenetrationTable(9)=7.5
    DHPenetrationTable(10)=7.5

    // Damage
    ImpactDamage=300
    Damage=300.0
    DamageRadius=700.0  //significantly increased as grenade was powerful, 600-650 gramms of TNT
    EngineFireChance=0.7  //weaker HEAT round
    ShellImpactDamage=class'DH_Weapons.DH_RPG43GrenadeImpactDamType'
    MyDamageType=class'DH_Weapons.DH_RPG43GrenadeDamType'

    // Effects
    StaticMesh=StaticMesh'DH_WeaponPickups.Ammo.RPG43Grenade_throw'
    ShellHitDirtEffectClass=class'GrenadeExplosion'
    ShellHitWoodEffectClass=class'GrenadeExplosion'
    ShellHitRockEffectClass=class'GrenadeExplosion'
    ShellHitSnowEffectClass=class'GrenadeExplosionSnow'
    ShellHitWaterEffectClass=class'ROEffects.ROBulletHitWaterEffect'
    ShellHitVehicleEffectClass=class'DH_Effects.DHPanzerfaustHitTank'
    ShellDeflectEffectClass=class'GrenadeExplosion'

    ExplosionDecal=class'ROEffects.GrenadeMark'
    ExplosionDecalSnow=class'ROEffects.GrenadeMarkSnow'

    // Sounds
    ExplosionSoundVolume=8.0 // seems high but TransientSoundVolume is only 0.3, compared to 1.0 for a shell
    VehicleHitSound=SoundGroup'DH_MN_InfantryWeapons_sound.PIAT.PiatExp01'
    VehicleDeflectSound=Sound'Inf_Weapons_Foley.grenadeland'
    ImpactSound=Sound'Inf_Weapons_Foley.grenadeland'
    DirtHitSound=Sound'Inf_Weapons_Foley.grenadeland'
    RockHitSound=Sound'Inf_Weapons_Foley.grenadeland'
    WoodHitSound=Sound'Inf_Weapons_Foley.grenadeland'
    WaterHitSound=SoundGroup'ProjectileSounds.Bullets.Impact_Water'
    ExplosionSound(0)=SoundGroup'DH_MN_InfantryWeapons_sound.PIAT.PiatExp02'
    ExplosionSound(1)=SoundGroup'DH_MN_InfantryWeapons_sound.PIAT.PiatExp03'
    ExplosionSound(2)=SoundGroup'DH_MN_InfantryWeapons_sound.PIAT.PiatExp01'
}

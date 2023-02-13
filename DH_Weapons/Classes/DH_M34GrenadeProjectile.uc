//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_M34GrenadeProjectile extends DHThrowableHEATProjectile;

// Extends a HEAT projectile to make use of the impact fuze.
// This is NOT an anti-tank grenade, so penetration values are small.

defaultproperties
{
    StaticMesh=StaticMesh'DH_WeaponPickups.Ammo.m34_throw'
    Speed=1100.0
    MaxSpeed=2000.0
    LifeSpan=10.0 // used in case the grenade fails to detonate on impact (will lie around for a bit for effect, then disappear)
    PickupClass=class'DH_Weapons.DH_M34GrenadePickup'

    // Impact fuze
    bExplodesOnHittingWater=false
    MaxImpactAOIToExplode=90.0
    MinImpactSpeedToExplode=1.0
    MaxVerticalAOIForTopArmor=3.0

    // Armour penetration
    // not an anti-tank grenade
    ShellDiameter=7.5
    DHPenetrationTable(0)=0.5
    DHPenetrationTable(1)=0.5
    DHPenetrationTable(2)=0.5
    DHPenetrationTable(3)=0.5
    DHPenetrationTable(4)=0.5
    DHPenetrationTable(5)=0.5
    DHPenetrationTable(6)=0.5
    DHPenetrationTable(7)=0.5
    DHPenetrationTable(8)=0.5
    DHPenetrationTable(9)=0.5
    DHPenetrationTable(10)=0.5

    // Damage
    ImpactDamage=50
    Damage=160.0  //100 gramms tnt
    DamageRadius=450
    MomentumTransfer=8000.0
    ShellImpactDamage=class'DH_Weapons.DH_m34grenadeImpactDamType'
    MyDamageType=class'DH_Weapons.DH_m34GrenadeDamType'

    // Effects
    ShellHitDirtEffectClass=class'GrenadeExplosion'
    ShellHitWoodEffectClass=class'GrenadeExplosion'
    ShellHitRockEffectClass=class'GrenadeExplosion'
    ShellHitSnowEffectClass=class'GrenadeExplosionSnow'
    ShellHitWaterEffectClass=class'ROEffects.ROBulletHitWaterEffect'
    ShellHitVehicleEffectClass=class'ROEffects.PanzerfaustHitTank'
    ShellDeflectEffectClass=class'GrenadeExplosion'
    ExplosionDecal=class'ROEffects.GrenadeMark'
    ExplosionDecalSnow=class'ROEffects.GrenadeMarkSnow'

    // Sounds
    ExplosionSoundVolume=3.0
    VehicleHitSound=SoundGroup'Inf_Weapons.stielhandgranate24.stielhandgranate24_explode03'
    VehicleDeflectSound=Sound'Inf_Weapons_Foley.grenadeland'
    ImpactSound=Sound'Inf_Weapons_Foley.grenadeland'
    DirtHitSound=Sound'Inf_Weapons_Foley.grenadeland'
    RockHitSound=Sound'Inf_Weapons_Foley.grenadeland'
    WoodHitSound=Sound'Inf_Weapons_Foley.grenadeland'
    WaterHitSound=SoundGroup'ProjectileSounds.Bullets.Impact_Water'
    ExplosionSound(0)=SoundGroup'Inf_Weapons.stielhandgranate24.stielhandgranate24_explode01'
    ExplosionSound(1)=SoundGroup'Inf_Weapons.stielhandgranate24.stielhandgranate24_explode02'
    ExplosionSound(2)=SoundGroup'Inf_Weapons.stielhandgranate24.stielhandgranate24_explode03'
}

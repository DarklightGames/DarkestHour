//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_Model35MortarProjectileHEBig extends DH_Model35MortarProjectileHE;

defaultproperties
{
    Speed=6500
    MaxSpeed=6500
    StaticMesh=StaticMesh'DH_Model35Mortar_stc.projectiles.IT_SMOKE_M110_A' // TODO: the name is incorrect here
    Damage=500.0
    DamageRadius=1350.0 // ~23 meters

    GroundExplosionSounds(0)=SoundGroup'Artillery.explosions.explo01'
    GroundExplosionSounds(1)=SoundGroup'Artillery.explosions.explo02'
    GroundExplosionSounds(2)=SoundGroup'Artillery.explosions.explo03'
    GroundExplosionSounds(3)=SoundGroup'Artillery.explosions.explo04'
    SnowExplosionSounds(0)=SoundGroup'Artillery.explosions.explo01'
    SnowExplosionSounds(1)=SoundGroup'Artillery.explosions.explo02'
    SnowExplosionSounds(2)=SoundGroup'Artillery.explosions.explo03'
    SnowExplosionSounds(3)=SoundGroup'Artillery.explosions.explo04'
    WaterExplosionSounds(0)=SoundGroup'Artillery.explosions.explo01'
    WaterExplosionSounds(1)=SoundGroup'Artillery.explosions.explo02'
    WaterExplosionSounds(2)=SoundGroup'Artillery.explosions.explo03'
    WaterExplosionSounds(3)=SoundGroup'Artillery.explosions.explo04'

    GroundExplosionEmitterClass=class'ROEffects.ROArtilleryDirtEmitter'
    SnowExplosionEmitterClass=class'ROEffects.ROArtillerySnowEmitter'
    WaterExplosionEmitterClass=class'ROEffects.ROArtilleryWaterEmitter'
}

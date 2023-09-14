//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_Kz8cmGrW42ProjectileHE extends DHMortarProjectileHE;

defaultproperties
{
    Speed=3936.0
    MaxSpeed=3936.0
    Damage=300.0
    DamageRadius=720.0
    Tag="8cm Spgr."
    BlurTime=6.0
    BlurEffectScalar=4.0

    GroundExplosionSounds(0)=SoundGroup'ProjectileSounds.cannon_rounds.OUT_HE_explode01'
    GroundExplosionSounds(1)=SoundGroup'ProjectileSounds.cannon_rounds.OUT_HE_explode02'
    GroundExplosionSounds(2)=SoundGroup'ProjectileSounds.cannon_rounds.OUT_HE_explode03'
    GroundExplosionSounds(3)=SoundGroup'ProjectileSounds.cannon_rounds.OUT_HE_explode04'
    SnowExplosionSounds(0)=SoundGroup'ProjectileSounds.cannon_rounds.OUT_HE_explode01'
    SnowExplosionSounds(1)=SoundGroup'ProjectileSounds.cannon_rounds.OUT_HE_explode02'
    SnowExplosionSounds(2)=SoundGroup'ProjectileSounds.cannon_rounds.OUT_HE_explode03'
    SnowExplosionSounds(3)=SoundGroup'ProjectileSounds.cannon_rounds.OUT_HE_explode04'
    WaterExplosionSounds(0)=SoundGroup'ProjectileSounds.cannon_rounds.OUT_HE_explode01'
    WaterExplosionSounds(1)=SoundGroup'ProjectileSounds.cannon_rounds.OUT_HE_explode02'
    WaterExplosionSounds(2)=SoundGroup'ProjectileSounds.cannon_rounds.OUT_HE_explode03'
    WaterExplosionSounds(3)=SoundGroup'ProjectileSounds.cannon_rounds.OUT_HE_explode04'
}

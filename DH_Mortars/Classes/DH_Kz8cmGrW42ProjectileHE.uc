//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_Kz8cmGrW42ProjectileHE extends DH_MortarProjectileHE;

#exec OBJ LOAD FILE=..\StaticMeshes\DH_Mortars_stc.usx
#exec OBJ LOAD FILE=..\Textures\DH_Mortars_tex.utx

defaultproperties
{
    GroundExplosionSounds(0)=SoundGroup'ProjectileSounds.cannon_rounds.OUT_HE_explode01'
    GroundExplosionSounds(1)=SoundGroup'ProjectileSounds.cannon_rounds.OUT_HE_explode02'
    GroundExplosionSounds(2)=SoundGroup'ProjectileSounds.cannon_rounds.OUT_HE_explode03'
    GroundExplosionSounds(3)=SoundGroup'ProjectileSounds.cannon_rounds.OUT_HE_explode04'
    WaterExplosionSounds(0)=SoundGroup'ProjectileSounds.cannon_rounds.OUT_HE_explode01'
    WaterExplosionSounds(1)=SoundGroup'ProjectileSounds.cannon_rounds.OUT_HE_explode02'
    WaterExplosionSounds(2)=SoundGroup'ProjectileSounds.cannon_rounds.OUT_HE_explode03'
    WaterExplosionSounds(3)=SoundGroup'ProjectileSounds.cannon_rounds.OUT_HE_explode04'
    SnowExplosionSounds(0)=SoundGroup'ProjectileSounds.cannon_rounds.OUT_HE_explode01'
    SnowExplosionSounds(1)=SoundGroup'ProjectileSounds.cannon_rounds.OUT_HE_explode02'
    SnowExplosionSounds(2)=SoundGroup'ProjectileSounds.cannon_rounds.OUT_HE_explode03'
    SnowExplosionSounds(3)=SoundGroup'ProjectileSounds.cannon_rounds.OUT_HE_explode04'
    ShakeRotMag=(Z=100.000000)
    ShakeRotRate=(Z=2500.000000)
    ShakeRotTime=3.000000
    ShakeOffsetMag=(Z=5.000000)
    ShakeOffsetRate=(Z=200.000000)
    ShakeOffsetTime=5.000000
    BlurTime=6.000000
    BlurEffectScalar=4.000000
    BallisticCoefficient=1.000000
    MaxSpeed=3936.000000
    Damage=300.000000
    DamageRadius=720.000000
    MyDamageType=class'DH_Mortars.DH_Kz8cmGrW42DamageType'
    ExplosionDecal=class'ROEffects.ArtilleryMarkDirt'
    ExplosionDecalSnow=class'ROEffects.ArtilleryMarkSnow'
    Tag="8cm Spgr."
}

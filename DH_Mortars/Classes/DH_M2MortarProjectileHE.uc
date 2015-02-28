//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_M2MortarProjectileHE extends DH_MortarProjectileHE;

#exec OBJ LOAD FILE=..\StaticMeshes\DH_Mortars_stc.usx

defaultproperties
{
    GroundExplosionSounds(0)=SoundGroup'Inf_Weapons.F1.f1_explode01'
    GroundExplosionSounds(1)=SoundGroup'Inf_Weapons.F1.f1_explode02'
    GroundExplosionSounds(2)=SoundGroup'Inf_Weapons.F1.f1_explode03'
    WaterExplosionSounds(0)=SoundGroup'Inf_Weapons.F1.f1_explode01'
    WaterExplosionSounds(1)=SoundGroup'Inf_Weapons.F1.f1_explode02'
    WaterExplosionSounds(2)=SoundGroup'Inf_Weapons.F1.f1_explode03'
    SnowExplosionSounds(0)=SoundGroup'Inf_Weapons.F1.f1_explode01'
    SnowExplosionSounds(1)=SoundGroup'Inf_Weapons.F1.f1_explode02'
    SnowExplosionSounds(2)=SoundGroup'Inf_Weapons.F1.f1_explode03'
    GroundExplosionEmitterClass=class'DH_Effects.DH_M2MortarHEExplosion'
    SnowExplosionEmitterClass=class'DH_Effects.DH_M2MortarHEExplosion'
    WaterExplosionEmitterClass=class'DH_Effects.DH_M2MortarHEExplosion'
    ShakeRotMag=(Z=100.0)
    ShakeRotRate=(Z=2500.0)
    ShakeRotTime=3.0
    ShakeOffsetMag=(Z=5.0)
    ShakeOffsetRate=(Z=200.0)
    ShakeOffsetTime=5.0
    BlurTime=4.0
    BlurEffectScalar=2.0
    BallisticCoefficient=1.0
    MaxSpeed=4800.0
    Damage=233.332993
    DamageRadius=640.0
    MomentumTransfer=75000.0
    MyDamageType=class'DH_Mortars.DH_M2MortarDamageType'
    ExplosionDecal=class'ROEffects.ArtilleryMarkDirt'
    ExplosionDecalSnow=class'ROEffects.ArtilleryMarkSnow'
    Tag="M49A2 HE"
}

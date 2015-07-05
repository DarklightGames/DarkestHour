//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_M2MortarProjectileHE extends DHMortarProjectileHE;

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
    BlurTime=4.0
    BlurEffectScalar=2.0
    MaxSpeed=4800.0
    Damage=233.33
    DamageRadius=640.0
    Tag="M49A2 HE"
}

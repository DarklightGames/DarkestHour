//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_M2MortarProjectileHE extends DHMortarProjectileHE;

defaultproperties
{
    Speed=4800.0
    MaxSpeed=4800.0
    Damage=233.33
    DamageRadius=640.0
    Tag="M49A2 HE"
    BlurTime=4.0
    BlurEffectScalar=2.0

    GroundExplosionEmitterClass=class'DH_Effects.DHMortarExplosion60mm'
    SnowExplosionEmitterClass=class'DH_Effects.DHMortarExplosion60mm'
    GroundExplosionSounds(0)=SoundGroup'Inf_Weapons.F1.f1_explode01'
    GroundExplosionSounds(1)=SoundGroup'Inf_Weapons.F1.f1_explode02'
    GroundExplosionSounds(2)=SoundGroup'Inf_Weapons.F1.f1_explode03'
    SnowExplosionSounds(0)=SoundGroup'Inf_Weapons.F1.f1_explode01'
    SnowExplosionSounds(1)=SoundGroup'Inf_Weapons.F1.f1_explode02'
    SnowExplosionSounds(2)=SoundGroup'Inf_Weapons.F1.f1_explode03'
    WaterExplosionSounds(0)=SoundGroup'Inf_Weapons.F1.f1_explode01'
    WaterExplosionSounds(1)=SoundGroup'Inf_Weapons.F1.f1_explode02'
    WaterExplosionSounds(2)=SoundGroup'Inf_Weapons.F1.f1_explode03'
}

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
     GroundExplosionEmitterClass=Class'DH_Effects.DH_M2MortarHEExplosion'
     SnowExplosionEmitterClass=Class'DH_Effects.DH_M2MortarHEExplosion'
     WaterExplosionEmitterClass=Class'DH_Effects.DH_M2MortarHEExplosion'
     ShakeRotMag=(Z=100.000000)
     ShakeRotRate=(Z=2500.000000)
     ShakeRotTime=3.000000
     ShakeOffsetMag=(Z=5.000000)
     ShakeOffsetRate=(Z=200.000000)
     ShakeOffsetTime=5.000000
     BlurTime=4.000000
     BlurEffectScalar=2.000000
     BallisticCoefficient=1.000000
     MaxSpeed=4800.000000
     Damage=233.332993
     DamageRadius=640.000000
     MomentumTransfer=75000.000000
     MyDamageType=Class'DH_Mortars.DH_M2MortarDamageType'
     ExplosionDecal=Class'ROEffects.ArtilleryMarkDirt'
     ExplosionDecalSnow=Class'ROEffects.ArtilleryMarkSnow'
     Tag="M49A2 HE"
}

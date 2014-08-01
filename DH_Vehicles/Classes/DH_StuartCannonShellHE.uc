//==============================================================================
// DH_StuartCannonShellHE
//
// Darkest Hour Source - (c) Darkest Hour Team 2010
// Red Orchestra Source - (c) Tripwire Interactive 2006
//
// American M5 Stuart tank - 37mm M63 HE
//==============================================================================
class DH_StuartCannonShellHE extends DH_ROTankCannonShellHE;

defaultproperties
{
     MechanicalRanges(1)=(Range=400)
     MechanicalRanges(2)=(Range=800)
     MechanicalRanges(3)=(Range=1200)
     MechanicalRanges(4)=(Range=1600)
     bMechanicalAiming=true
     DHPenetrationTable(0)=1.200000
     DHPenetrationTable(1)=1.100000
     DHPenetrationTable(2)=1.000000
     DHPenetrationTable(3)=1.000000
     DHPenetrationTable(4)=1.000000
     ShellDiameter=3.700000
     ShellImpactDamage=Class'DH_Vehicles.DH_StuartCannonShellDamageAP'
     ImpactDamage=185
     VehicleDeflectSound=SoundGroup'ProjectileSounds.Bullets.PTRD_deflect'
     VehicleHitSound=SoundGroup'ProjectileSounds.Bullets.PTRD_penetrate'
     ShellHitVehicleEffectClass=Class'ROEffects.TankAPHitPenetrateSmall'
     ShellHitDirtEffectClass=Class'ROEffects.GrenadeExplosion'
     ShellHitSnowEffectClass=Class'ROEffects.GrenadeExplosion'
     ShellHitWoodEffectClass=Class'ROEffects.GrenadeExplosion'
     ShellHitRockEffectClass=Class'ROEffects.GrenadeExplosion'
     ShellHitWaterEffectClass=Class'ROEffects.GrenadeExplosion'
     BallisticCoefficient=0.984000
     Speed=53291.000000
     MaxSpeed=53291.000000
     Damage=150.000000
     DamageRadius=800.000000
     MyDamageType=Class'DH_Vehicles.DH_StuartCannonShellDamageHE'
     Tag="M63 HE"
}

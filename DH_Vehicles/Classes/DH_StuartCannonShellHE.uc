//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_StuartCannonShellHE extends DHCannonShellHE;

defaultproperties
{
    DHPenetrationTable(0)=1.2
    DHPenetrationTable(1)=1.1
    DHPenetrationTable(2)=1.0
    DHPenetrationTable(3)=1.0
    DHPenetrationTable(4)=1.0
    ShellDiameter=3.7
    ShellImpactDamage=class'DH_Vehicles.DH_StuartCannonShellDamageAP'
    ImpactDamage=185
    VehicleDeflectSound=SoundGroup'ProjectileSounds.Bullets.PTRD_deflect'
    VehicleHitSound=SoundGroup'ProjectileSounds.Bullets.PTRD_penetrate'
    ShellHitVehicleEffectClass=class'ROEffects.TankAPHitPenetrateSmall'
    ShellHitDirtEffectClass=class'ROEffects.GrenadeExplosion'
    ShellHitSnowEffectClass=class'ROEffects.GrenadeExplosionSnow'
    ShellHitWoodEffectClass=class'ROEffects.GrenadeExplosion'
    ShellHitRockEffectClass=class'ROEffects.GrenadeExplosion'
    ShellHitWaterEffectClass=class'ROEffects.GrenadeExplosion'
    BallisticCoefficient=0.984
    Speed=53291.0
    MaxSpeed=53291.0
    Damage=150.0
    DamageRadius=800.0
    MyDamageType=class'DH_Engine.DHShellHE37mmDamageType'
    Tag="M63 HE"
}

//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_GreyhoundCannonShellHE extends DH_ROTankCannonShellHE;

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
    ShellImpactDamage=class'DH_Vehicles.DH_GreyhoundCannonShellDamageAP'
    ImpactDamage=185
    VehicleDeflectSound=SoundGroup'ProjectileSounds.Bullets.PTRD_deflect'
    VehicleHitSound=SoundGroup'ProjectileSounds.Bullets.PTRD_penetrate'
    ShellHitVehicleEffectClass=class'ROEffects.TankAPHitPenetrateSmall'
    ShellHitDirtEffectClass=class'ROEffects.GrenadeExplosion'
    ShellHitSnowEffectClass=class'ROEffects.GrenadeExplosion'
    ShellHitWoodEffectClass=class'ROEffects.GrenadeExplosion'
    ShellHitRockEffectClass=class'ROEffects.GrenadeExplosion'
    ShellHitWaterEffectClass=class'ROEffects.GrenadeExplosion'
    BallisticCoefficient=0.984000
    Speed=53291.000000
    MaxSpeed=53291.000000
    Damage=150.000000
    DamageRadius=800.000000
    MyDamageType=class'DH_Vehicles.DH_GreyhoundCannonShellDamageHE'
    Tag="M63 HE"
}

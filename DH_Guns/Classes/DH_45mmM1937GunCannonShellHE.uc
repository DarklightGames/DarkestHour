//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_45mmM1937GunCannonShellHE extends DHCannonShellHE;

defaultproperties
{
    Speed=20218.0 // 335 m/s
    MaxSpeed=20218.0
    ShellDiameter=4.5
    BallisticCoefficient=0.6 // TODO: try to find an accurate BC (this is from AHZ)

    //Damage
    ImpactDamage=425
    ShellImpactDamage=class'DH_Engine.DHShellHEGunImpactDamageType'
    Damage=190.0  //118 gramms TNT
    DamageRadius=590.0
    MyDamageType=class'DH_Engine.DHShellHE50mmATDamageType'
    HullFireChance=0.50
    EngineFireChance=0.5

    bDebugInImperial=false

    //Effects
    CoronaClass=class'DH_Effects.DHShellTracer_Green'
    BlurTime=4.0
    BlurEffectScalar=1.5
    ShellHitDirtEffectClass=class'ROEffects.GrenadeExplosion'
    ShellHitSnowEffectClass=class'ROEffects.GrenadeExplosionSnow'
    ShellHitWoodEffectClass=class'ROEffects.GrenadeExplosion'
    ShellHitRockEffectClass=class'ROEffects.GrenadeExplosion'
    ShellHitWaterEffectClass=class'ROEffects.GrenadeExplosion'
    ShellHitVehicleEffectClass=class'ROEffects.TankAPHitPenetrateSmall'

    //Penetration
    DHPenetrationTable(0)=1.3 // penetration same as Bofors 40mm HE, slightly better than US 37mm HE
    DHPenetrationTable(1)=1.2
    DHPenetrationTable(2)=1.1
    DHPenetrationTable(3)=1.0
    DHPenetrationTable(4)=1.0

    //Gunsight adjustments
    bOpticalAiming=true
    OpticalRanges(0)=(Range=0,RangeValue=0.471)
    OpticalRanges(1)=(Range=500,RangeValue=0.505)
    OpticalRanges(2)=(Range=1000,RangeValue=0.543)
    OpticalRanges(3)=(Range=1500,RangeValue=0.597)
    OpticalRanges(4)=(Range=2000,RangeValue=0.661)
    OpticalRanges(5)=(Range=2500,RangeValue=0.733)

    bMechanicalAiming=true // this cannon doesn't actually have mechanical aiming, but this is a fudge to adjust for sight markings that are 'out'
    MechanicalRanges(0)=(Range=0,RangeValue=50.0)
    MechanicalRanges(1)=(Range=500,RangeValue=170.0)
    MechanicalRanges(2)=(Range=1000,RangeValue=390.0)
    MechanicalRanges(3)=(Range=1500,RangeValue=635.0) // can only set up to here
    MechanicalRanges(4)=(Range=2000,RangeValue=880.0)
    MechanicalRanges(5)=(Range=2500,RangeValue=1125.0)
}

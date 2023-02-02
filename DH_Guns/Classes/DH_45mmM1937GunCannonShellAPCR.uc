//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_45mmM1937GunCannonShellAPCR extends DHCannonShellAPDS;

defaultproperties
{
    RoundType=RT_APDS //RT_APDS since APCR uses the same pen calcs
    Speed=45868.0 // 760 m/s
    MaxSpeed=45868.0
    ShellDiameter=3.7 //sub-caliber round
    BallisticCoefficient=0.7 // TODO: pls check accurate BC (this is from AHZ)

    //Damage
    ImpactDamage=220 // just a tungsten slug; no explosive filler
    Damage=790.0 //"regular" damage is only changed so that AT guns are one-shot killed reliably, so the radius is small
    DamageRadius=100.0
    ShellImpactDamage=class'DH_Engine.DHShellSubCalibreImpactDamageType'
    HullFireChance=0.22
    EngineFireChance=0.45

    bShatterProne=true

    //Effects
    ShellShatterEffectClass=class'DH_Effects.DHShellShatterEffect_Small'
    CoronaClass=class'DH_Effects.DHShellTracer_Green'
    ShellTrailClass=class'DH_Effects.DHShellTrail_Green'

    //Sound
    VehicleDeflectSound=SoundGroup'ProjectileSounds.Bullets.PTRD_deflect'
    VehicleHitSound=SoundGroup'ProjectileSounds.Bullets.PTRD_penetrate'
    ShellHitVehicleEffectClass=class'ROEffects.TankAPHitPenetrateSmall'

    //Penetration
    DHPenetrationTable(0)=9.4  // 100m
    DHPenetrationTable(1)=8.1  // 250m
    DHPenetrationTable(2)=6.4  // 500m
    DHPenetrationTable(3)=5.0
    DHPenetrationTable(4)=4.0  // 1000m
    DHPenetrationTable(5)=3.2
    DHPenetrationTable(6)=2.7  // 1500m
    DHPenetrationTable(7)=1.6
    DHPenetrationTable(8)=1.3  // 2000m
    DHPenetrationTable(9)=0.9
    DHPenetrationTable(10)=0.5 // 3000m

    //Gunsight adjustments
    bOpticalAiming=true
    OpticalRanges(0)=(Range=0,RangeValue=0.471)
    OpticalRanges(1)=(Range=500,RangeValue=0.505)
    OpticalRanges(2)=(Range=1000,RangeValue=0.543)
    OpticalRanges(3)=(Range=1500,RangeValue=0.597)
    OpticalRanges(4)=(Range=2000,RangeValue=0.661)
    OpticalRanges(5)=(Range=2500,RangeValue=0.733)

    bMechanicalAiming=true // this cannon doesn't actually have mechanical aiming, but this is a fudge to adjust for sight markings that are 'out'
    MechanicalRanges(1)=(Range=500,RangeValue=-30.0)
    MechanicalRanges(2)=(Range=1000,RangeValue=-65.0)
    MechanicalRanges(3)=(Range=1500,RangeValue=-85.0) // can only set up to here
    MechanicalRanges(4)=(Range=2000,RangeValue=-105.0)
    MechanicalRanges(5)=(Range=2500,RangeValue=-125.0)
}

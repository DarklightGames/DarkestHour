//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_45mmM1937GunCannonShell extends DHSovietCannonShell;

defaultproperties
{
    RoundType=RT_APBC
    Speed=45868.0 // 760 m/s
    MaxSpeed=45868.0
    ShellDiameter=4.5
    BallisticCoefficient=0.7 // TODO: try to find an accurate BC (this is from AHZ)

    //Damage
    ImpactDamage=295 //30 gramms TNT filler
    Damage=700.0 //"regular" damage is only changed so that AT guns are one-shot killed reliably, so the radius is small
    DamageRadius=150.0
    ShellImpactDamage=class'DH_Engine.DHShellAPGunImpactDamageType'
    HullFireChance=0.30
    EngineFireChance=0.55

    //Effects
    CoronaClass=class'DH_Effects.DHShellTracer_Green'
    ShellShatterEffectClass=class'DH_Effects.DHShellShatterEffect_Small'

    //Sound
    ShellHitVehicleEffectClass=class'ROEffects.TankAPHitPenetrateSmall'

    //Penetration
    DHPenetrationTable(0)=6.1  // 100m // TODO: confirm penetration
    DHPenetrationTable(1)=5.4  // 250m
    DHPenetrationTable(2)=4.6  // 500m
    DHPenetrationTable(3)=3.9
    DHPenetrationTable(4)=3.2  // 1000m
    DHPenetrationTable(5)=2.7
    DHPenetrationTable(6)=2.2  // 1500m
    DHPenetrationTable(7)=1.8
    DHPenetrationTable(8)=1.5  // 2000m
    DHPenetrationTable(9)=1.0
    DHPenetrationTable(10)=0.6 // 3000m

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

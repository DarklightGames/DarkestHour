//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_Bofors40mmCannonShell extends DHCannonShell;

defaultproperties
{
    bNetTemporary=true

    Speed=53170.0
    MaxSpeed=53170.0
    ShellDiameter=4.0
    BallisticCoefficient=0.984 // TODO: try to find an accurate BC (this is same as US 37mm)

    //Damage
    ImpactDamage=180 //solid shell, i assume because didnt find any info
    ShellImpactDamage=class'DH_Engine.DHShellAPGunImpactDamageType'
    HullFireChance=0.14
    EngineFireChance=0.23

    bShatterProne=true

    //Effects
    CoronaClass=class'DH_Effects.DHShellTracer_RedLarge'
    ShellTrailClass=class'DH_Effects.DH20mmShellTrail_Red'
    ShellShatterEffectClass=class'DH_Effects.DHShellShatterEffect_Small'
    ShellHitVehicleEffectClass=class'DH_Effects.DH20mmAPHitPenetrate'
    ShellHitDirtEffectClass=class'DH_Effects.DH20mmAPHitDirtEffect'
    ShellHitSnowEffectClass=class'DH_Effects.DH20mmAPHitSnowEffect'
    ShellHitWoodEffectClass=class'DH_Effects.DH20mmAPHitWoodEffect'
    ShellHitRockEffectClass=class'DH_Effects.DH20mmAPHitConcreteEffect'
    ShellHitWaterEffectClass=class'DH_Effects.DHShellSplashEffect'

    //Sound
    VehicleDeflectSound=SoundGroup'ProjectileSounds.Bullets.PTRD_deflect'
    VehicleHitSound=SoundGroup'ProjectileSounds.Bullets.PTRD_penetrate'

    //Penetration
    DHPenetrationTable(0)=6.0  // 100m // TODO: try to get some accurate penetration data (this uses reported penetration at 100, 500, 1k & 2k ranges, with the gaps then estimated)
    DHPenetrationTable(1)=5.5  // 250m
    DHPenetrationTable(2)=4.9  // 500m
    DHPenetrationTable(3)=4.4
    DHPenetrationTable(4)=4.0  // 1000m
    DHPenetrationTable(5)=3.6
    DHPenetrationTable(6)=3.3  // 1500m
    DHPenetrationTable(7)=3.0
    DHPenetrationTable(8)=2.7  // 2000m
    DHPenetrationTable(9)=2.2
    DHPenetrationTable(10)=1.7 // 3000m
}

//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2018
//==============================================================================

class DH_Bofors40mmCannonShell extends DHCannonShell;

defaultproperties
{
    ShellDiameter=4.0
    bShatterProne=true
    ShellShatterEffectClass=class'DH_Effects.DHShellShatterEffect_Small'
    CoronaClass=class'DH_Effects.DHShellTracer_Red'
    ShellImpactDamage=class'DH_Engine.DHShellAPGunImpactDamageType'
    ImpactDamage=265
    VehicleDeflectSound=SoundGroup'ProjectileSounds.Bullets.PTRD_deflect'
    VehicleHitSound=SoundGroup'ProjectileSounds.Bullets.PTRD_penetrate'
    ShellHitVehicleEffectClass=class'ROEffects.TankAPHitPenetrateSmall'
    BallisticCoefficient=0.984 // TODO: try to find an accurate BC (this is same as US 37mm)
    Speed=53170.0
    MaxSpeed=53170.0
    Tag="AP-T" // TODO: add shell designation (although tbh it isn't used anywhere)

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

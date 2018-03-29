//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2018
//==============================================================================

class DH_GreyhoundCannonShell extends DHCannonShell;

defaultproperties
{
    DHPenetrationTable(0)=6.5
    DHPenetrationTable(1)=6.1
    DHPenetrationTable(2)=5.7
    DHPenetrationTable(3)=5.3
    DHPenetrationTable(4)=5.0
    DHPenetrationTable(5)=4.6
    DHPenetrationTable(6)=4.3
    DHPenetrationTable(7)=3.9
    DHPenetrationTable(8)=3.6
    DHPenetrationTable(9)=3.3
    DHPenetrationTable(10)=3.0
    ShellDiameter=3.7
    bShatterProne=true
    ShellShatterEffectClass=class'DH_Effects.DHShellShatterEffect_Small'
    CoronaClass=class'DH_Effects.DHShellTracer_Red'
    ShellImpactDamage=class'DH_Vehicles.DH_StuartCannonShellDamageAP'
    ImpactDamage=250
    VehicleDeflectSound=SoundGroup'ProjectileSounds.Bullets.PTRD_deflect'
    VehicleHitSound=SoundGroup'ProjectileSounds.Bullets.PTRD_penetrate'
    ShellHitVehicleEffectClass=class'ROEffects.TankAPHitPenetrateSmall'
    BallisticCoefficient=0.984
    Speed=53291.0
    MaxSpeed=53291.0
    Tag="M51B1 APC"
}

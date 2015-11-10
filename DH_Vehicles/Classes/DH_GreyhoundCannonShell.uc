//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_GreyhoundCannonShell extends DHCannonShell;

defaultproperties
{
    DHPenetrationTable(0)=7.1
    DHPenetrationTable(1)=6.7
    DHPenetrationTable(2)=6.3
    DHPenetrationTable(3)=6.1
    DHPenetrationTable(4)=5.7
    DHPenetrationTable(5)=5.2
    DHPenetrationTable(6)=4.8
    DHPenetrationTable(7)=4.5
    DHPenetrationTable(8)=4.1
    DHPenetrationTable(9)=3.5
    DHPenetrationTable(10)=3.0
    ShellDiameter=3.7
    bShatterProne=true
    ShellShatterEffectClass=class'DH_Effects.DH_TankAPShellShatterSmall'
    CoronaClass=class'DH_Effects.DH_RedTankShellTracer'
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

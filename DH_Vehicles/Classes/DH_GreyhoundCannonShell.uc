//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DH_GreyhoundCannonShell extends DHCannonShell;

defaultproperties
{
    Speed=53291.0
    MaxSpeed=53291.0
    ShellDiameter=3.7
    BallisticCoefficient=0.984 //TODO: find correct BC

    //Damage
    ImpactDamage=250
    ShellImpactDamage=class'DH_Vehicles.DH_StuartCannonShellDamageAP'
    HullFireChance=0.2
    EngineFireChance=0.45

    //Effects
    bShatterProne=true
    ShellShatterEffectClass=class'DH_Effects.DHShellShatterEffect_Small'
    CoronaClass=class'DH_Effects.DHShellTracer_Red'
    VehicleDeflectSound=SoundGroup'ProjectileSounds.Bullets.PTRD_deflect'
    VehicleHitSound=SoundGroup'ProjectileSounds.Bullets.PTRD_penetrate'
    ShellHitVehicleEffectClass=class'ROEffects.TankAPHitPenetrateSmall'

    //Penetration
    DHPenetrationTable(0)=7.1
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
}

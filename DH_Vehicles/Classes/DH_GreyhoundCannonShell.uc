//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_GreyhoundCannonShell extends DHCannonShell;

defaultproperties
{
    Speed=53346.0 //2900 fps or 884 m/s
    MaxSpeed=53346.0
    ShellDiameter=3.7
    BallisticCoefficient=1.52 //Correct - verified on range at 1000 yards

    //Damage
    ImpactDamage=215  //solid shell
    ShellImpactDamage=class'DH_Vehicles.DH_StuartCannonShellDamageAP'
    HullFireChance=0.17
    EngineFireChance=0.3

    //Effects
    bShatterProne=true
    CoronaClass=class'DH_Effects.DHShellTracer_Red'
    ShellShatterEffectClass=class'DH_Effects.DHShellShatterEffect_Small'
    ShellHitVehicleEffectClass=class'ROEffects.TankAPHitPenetrateSmall'

    //Sound
    VehicleDeflectSound=SoundGroup'ProjectileSounds.Bullets.PTRD_deflect'
    VehicleHitSound=SoundGroup'ProjectileSounds.Bullets.PTRD_penetrate'

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

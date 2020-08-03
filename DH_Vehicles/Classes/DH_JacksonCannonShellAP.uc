//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2020
//==============================================================================

class DH_JacksonCannonShellAP extends DHCannonShellAP;

defaultproperties
{
    Speed=49667.0 //2700 fps or 823 m/s
    MaxSpeed=49667.0
    ShellDiameter=9.0
    BallisticCoefficient=1.564 //Correct - verified on range at 1000 yards

    //Damage
    ImpactDamage=625
    ShellImpactDamage=class'DH_Vehicles.DH_JacksonCannonShellDamageAPShot'
    HullFireChance=0.42
    EngineFireChance=0.85

    //Penetration
    DHPenetrationTable(0)=18.8
    DHPenetrationTable(1)=17.9
    DHPenetrationTable(2)=16.3
    DHPenetrationTable(3)=15.0
    DHPenetrationTable(4)=13.7
    DHPenetrationTable(5)=12.5
    DHPenetrationTable(6)=11.5
    DHPenetrationTable(7)=10.5
    DHPenetrationTable(8)=9.6
    DHPenetrationTable(9)=8.1
    DHPenetrationTable(10)=6.8
}

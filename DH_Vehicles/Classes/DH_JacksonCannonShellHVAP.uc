//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DH_JacksonCannonShellHVAP extends DHCannonShellHVAP;

defaultproperties
{
    Speed=61619.0 // 3350 fps or 1021 m/s
    MaxSpeed=61619.0
    SpeedFudgeScale=0.4
    ShellDiameter=9.0 //full caliber
    BallisticCoefficient=2.55 // Correct - verified on range at 1000 yards

    //Damage
    ImpactDamage=525
    HullFireChance=0.38
    EngineFireChance=0.73

    //Penetration
    DHPenetrationTable(0)=30.6
    DHPenetrationTable(1)=29.5
    DHPenetrationTable(2)=27.8
    DHPenetrationTable(3)=26.2
    DHPenetrationTable(4)=24.6
    DHPenetrationTable(5)=23.2
    DHPenetrationTable(6)=21.8
    DHPenetrationTable(7)=17.9
    DHPenetrationTable(8)=14.7
    DHPenetrationTable(9)=13.1
    DHPenetrationTable(10)=11.8
}

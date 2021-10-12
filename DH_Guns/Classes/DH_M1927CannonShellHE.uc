//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2021
//==============================================================================
// OF-350 HE shell (identical to the one used on the T34/76)
//==============================================================================

class DH_M1927CannonShellHE extends DHCannonShellHE;

defaultproperties
{
    Speed=9988.0 // 662 m/s
    MaxSpeed=9988.0
    ShellDiameter=7.62
    BallisticCoefficient=1.55

    SpeedFudgeScale=1.0
    LifeSpan=30.0
    bHasTracer=false
    HitMapMarkerClass=class'DH_Engine.DHMapMarker_ArtilleryHit_HE'

    //Damage
    ImpactDamage=750
    ShellImpactDamage=class'DH_Engine.DHArtilleryKillDamageType'
    PenetrationMag=800.0
    Damage=400.0   //710 gramms TNT
    DamageRadius=1000.0
    MyDamageType=class'DH_Engine.DHShellHE75mmATDamageType_Artillery'
    HullFireChance=0.8
    EngineFireChance=0.8

    //Effects
//    CoronaClass=class'DH_Effects.DHShellTracer_GreenLarge'
//    ShellTrailClass=class'DH_Effects.DHShellTrail_Green'

    //Penetration
    DHPenetrationTable(0)=3.3
    DHPenetrationTable(1)=3.1
    DHPenetrationTable(2)=2.8
    DHPenetrationTable(3)=2.4
    DHPenetrationTable(4)=2.4
    DHPenetrationTable(5)=2.4
    DHPenetrationTable(6)=2.4
    DHPenetrationTable(7)=2.4
    DHPenetrationTable(8)=2.4
    DHPenetrationTable(9)=2.4
    DHPenetrationTable(10)=2.4
}

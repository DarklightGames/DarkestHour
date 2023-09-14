//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================
// Just a copy-paste from the Sherman 75's HE with some modifications
//==============================================================================

class DH_M116CannonShellHE extends DHCannonShellHE;

defaultproperties
{
    Speed=8192.0 // TODO: arbitrary
    MaxSpeed=8192.0
    ShellDiameter=7.5
    BallisticCoefficient=2.8 //TODO: pls check - this is the APC shell's BC
    SpeedFudgeScale=1.0
    LifeSpan=30.0
    bHasTracer=false
    HitMapMarkerClass=class'DH_Engine.DHMapMarker_ArtilleryHit_HE'

    //Damage
    ImpactDamage=710
    ShellImpactDamage=class'DH_Engine.DHArtilleryKillDamageType'
    PenetrationMag=750.0
    Damage=350.0   //680 gramms TNT
    DamageRadius=950.0
    MyDamageType=class'DH_Engine.DHShellHE75mmATDamageType_Artillery'
    HullFireChance=0.8
    EngineFireChance=0.8

    //Penetration
    DHPenetrationTable(0)=3.3
    DHPenetrationTable(1)=3.1
    DHPenetrationTable(2)=2.8
    DHPenetrationTable(3)=2.4
    DHPenetrationTable(4)=2.0
    DHPenetrationTable(5)=2.0
    DHPenetrationTable(6)=2.0
    DHPenetrationTable(7)=2.0
    DHPenetrationTable(8)=2.0
    DHPenetrationTable(9)=2.0
    DHPenetrationTable(10)=2.0
}

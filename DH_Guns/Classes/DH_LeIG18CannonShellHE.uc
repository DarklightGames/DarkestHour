//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_LeIG18CannonShellHE extends DHCannonShellHE;

defaultproperties
{
    Speed=6962.0        // arbitrary value
    MaxSpeed=6962.0     // arbitrary value
    SpeedFudgeScale=1.0
    ShellDiameter=7.5
    BallisticCoefficient=2.96 //TODO: pls find correct BC
    LifeSpan=30.0

    //Damage
    ImpactDamage=700
    ShellImpactDamage=class'DH_Engine.DHShellImpactDamageType_Artillery'
    PenetrationMag=800.0
    Damage=380.0   //700 gramms TNT
    DamageRadius=1050.0
    MyDamageType=class'DH_Engine.DHShellHE75mmATDamageType_Artillery'
    HullFireChance=0.8
    EngineFireChance=0.8

    HitMapMarkerClass=class'DH_Engine.DHMapMarker_ArtilleryHit_HE'

    bDebugInImperial=false

    //Effects
    bHasTracer=false
    bHasShellTrail=false

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
    bMechanicalAiming=true
}

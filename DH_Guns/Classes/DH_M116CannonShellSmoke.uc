//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_M116CannonShellSmoke extends DHCannonShellSmokeWP;

defaultproperties
{
    Speed=8192.0 // TODO: arbitrary
    MaxSpeed=8192.0
    ShellDiameter=7.5
    BallisticCoefficient=2.8 //TODO: pls check - this is the APC shell's BC
    SpeedFudgeScale=1.0
    LifeSpan=15
    bHasTracer=false
    HitMapMarkerClass=class'DH_Engine.DHMapMarker_ArtilleryHit_HE'
    
    GasEffectDuration=15.0

    SmokeEmitterClass=class'DH_Effects.DHSmokeEffect_MediumShellWP'

    Damage=100.0
    DamageRadius=480.0
    MyDamageType=class'DH_Engine.DHShellSmokeWPDamageType' // new dam type that sets nearby players on fire upon "explosion"
    GasDamageClass=class'DH_Engine.DHShellSmokeWPGasDamageType'
    GasDamage=10.0
    GasRadius=600.0
    SmokeSoundDuration=15


    //Penetration
    DHPenetrationTable(0)=0.2
    DHPenetrationTable(1)=0.2
    DHPenetrationTable(2)=0.2
    DHPenetrationTable(3)=0.2
    DHPenetrationTable(4)=0.1
}

//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DH_GeratPIIBullet extends DHBullet_ArmorPiercing; 

defaultproperties
{
    Speed=60352.0 // 1000 m/s
    MaxSpeed=60352.0
    ShellDiameter=0.9
    BallisticCoefficient=0.675 
    
    ImpactDamage=120
    Damage=200.0 

    HullFireChance=0.12  
    EngineFireChance=0.2

    MyDamageType=class'DH_Weapons.DH_GeratPDamType'
    
    bHasTracer=true
    TracerEffectClass=class'DH_Effects.DHBulletTracer_YellowOrange'
    StaticMesh=StaticMesh'DH_Tracers.Ger_Tracer_Ball'
    DeflectedMesh=StaticMesh'DH_Tracers.Ger_Tracer_Ball'
    SpeedFudgeScale=0.50
    TracerHue=40
}

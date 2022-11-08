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
    Damage=230.0 

    HullFireChance=0.12  
    EngineFireChance=0.2

    MyDamageType=class'DH_Weapons.DH_GeratPIIDamType'
    
    bHasTracer=true
    TracerEffectClass=class'DH_Effects.DHBulletTracer_YellowOrange'
    StaticMesh=StaticMesh'DH_Tracers.Ger_Tracer_Ball'
    DeflectedMesh=StaticMesh'DH_Tracers.Ger_Tracer_Ball'
    SpeedFudgeScale=0.50
    TracerHue=40
    
    //Penetration
    DHPenetrationTable(0)=3.9  // 100
    DHPenetrationTable(1)=3.4  // 250
    DHPenetrationTable(2)=2.8  // 500
    DHPenetrationTable(3)=2.2  // 750
    DHPenetrationTable(4)=1.5  // 1000
    DHPenetrationTable(5)=1.0  // 1250
    DHPenetrationTable(6)=0.5  // 1500
    DHPenetrationTable(7)=0.4  // 1750
    DHPenetrationTable(8)=0.3  // 2000
    DHPenetrationTable(9)=0.2  // 2500
    DHPenetrationTable(10)=0.1 // 3000
}

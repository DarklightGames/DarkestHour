//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================
// [1] https://en.wikipedia.org/wiki/Cannone_da_90/53
// [1]https://tanks-encyclopedia.com/semovente-m41m-da-90-53/
//==============================================================================

class DH_Semovente9053CannonShellHE extends DHCannonShellHE;

defaultproperties
{
    Speed=50092.0               // 830m/s [1]
    MaxSpeed=50092.0            
    ShellDiameter=9.0           // 90mm [1]
    BallisticCoefficient=2.5    // TODO: Find real value

    //Damage
    ImpactDamage=1000
    
    Damage=473.0   // 1000 gramms TNT, citation needed, references show exactly 1000 but that seems off
    DamageRadius=1530.0
    MyDamageType=class'DHShellHE88mmDamageType' // with 2mm off there really isnt much of a difference
    HullFireChance=0.8
    EngineFireChance=0.8

    ShellImpactDamage=class'DH_Engine.DHShellHEGunImpactDamageType'

    //Effects
    bHasTracer=false
    bHasShellTrail=false
    bDebugInImperial=false

    //Penetration
    DHPenetrationTable(0)=5.2
    DHPenetrationTable(1)=4.9
    DHPenetrationTable(2)=4.3
    DHPenetrationTable(3)=4.0
    DHPenetrationTable(4)=3.8
    DHPenetrationTable(5)=3.2
    DHPenetrationTable(6)=3.0
    DHPenetrationTable(7)=2.7
    DHPenetrationTable(8)=2.3
    DHPenetrationTable(9)=1.9
    DHPenetrationTable(10)=1.5
    
    bMechanicalAiming=false
}

//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2020
//==============================================================================

class DH_SdKfz251_9DCannonShellSmoke extends DHCannonShellSmoke;

defaultproperties
{
    Speed=41016.0            // 330 m/s
    MaxSpeed=45016.0
    ShellDiameter=9.5
    BallisticCoefficient=2.5 // between 75mm (P3N) & 105mm howitzers
    ImpactDamage=100         // between 75mm (P3N) & 105mm howitzers

    //Effects
    DrawScale=1.9
    SmokeEmitterClass=class'DH_Effects.DHSmokeEffect_LargeShell'

    //Penetration
    DHPenetrationTable(0)=0.1
    DHPenetrationTable(1)=0.1
    DHPenetrationTable(2)=0.1
    DHPenetrationTable(3)=0.1
    DHPenetrationTable(4)=0.05


    bMechanicalAiming=true
}

//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_Cromwell95mmCannonShellSmoke extends DHCannonShellSmoke;

defaultproperties
{
    Speed=19916.0            // 330 m/s
    MaxSpeed=19916.0
    ShellDiameter=9.5
    BallisticCoefficient=2.5 // between 75mm (P3N) & 105mm howitzers
    ImpactDamage=160         // between 75mm (P3N) & 105mm howitzers

    //Effects
    DrawScale=1.2
    SmokeEmitterClass=class'DH_Effects.DHSmokeEffect_LargeShell'

    //Penetration
    DHPenetrationTable(0)=0.3
    DHPenetrationTable(1)=0.3
    DHPenetrationTable(2)=0.3
    DHPenetrationTable(3)=0.3
    DHPenetrationTable(4)=0.15

    //Gunsight adjustment
    MechanicalRanges(0)=(RangeValue=45.0)
    MechanicalRanges(1)=(Range=200,RangeValue=103.0)
    MechanicalRanges(2)=(Range=400,RangeValue=215.0)
    MechanicalRanges(3)=(Range=600,RangeValue=328.0)
    MechanicalRanges(4)=(Range=800,RangeValue=440.0)
    MechanicalRanges(5)=(Range=1000,RangeValue=558.0)
    MechanicalRanges(6)=(Range=1200,RangeValue=680.0)
    MechanicalRanges(7)=(Range=1400,RangeValue=800.0)
    MechanicalRanges(8)=(Range=1600,RangeValue=890.0)
    bMechanicalAiming=true
}

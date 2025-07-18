//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_LeFH18CannonShellSmoke extends DHCannonShellSmokeWP;

defaultproperties
{
    Speed=8962.5         // 198m/s x 75%
    MaxSpeed=8962.5
    LifeSpan=20.0
    SpeedFudgeScale=1.0
    
    HitMapMarkerClass=Class'DHMapMarker_ArtilleryHit_Smoke'
    GasDamageClass=Class'DHShellSmokeWPGasDamageType_Artillery'

    ShellDiameter=10.5
    BallisticCoefficient=2.96

    ImpactDamage=175 // 75mm smoke shells are 125, so increased as this is a larger, heavier shell
    SmokeEmitterClass=Class'DHSmokeEffect_LargeShellWP'
    GasRadius=1100.0

    //Penetration
    DHPenetrationTable(0)=0.2
    DHPenetrationTable(1)=0.2
    DHPenetrationTable(2)=0.2
    DHPenetrationTable(3)=0.2
    DHPenetrationTable(4)=0.1
}

//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2020
//==============================================================================

class DH_Sdkfz2341CannonShellDamageAP extends DHShellAPImpactDamageType
    abstract;

defaultproperties
{
    TankDamageModifier=0.15
    APCDamageModifier=0.35
    VehicleDamageModifier=0.75
    TreadDamageModifier=0.5

    VehicleMomentumScaling=0.05 //minimal movement on vehicles from hits

    HumanObliterationThreshhold=200
    DamageKick= (X=-10.0,Y=10.0,Z=100.0)
    KDeathVel=500.000000 //350.0
    KDeathUpKick=150 //50
    bAlwaysSevers=true
    PawnDamageEmitter=class'DH_Effects.DHBloodPuffLargeCaliber'
}

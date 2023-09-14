//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_Sdkfz2341CannonShellDamageAP extends DHShellAPImpactDamageType
    abstract;

defaultproperties
{
    TankDamageModifier=0.2
    APCDamageModifier=0.3
    VehicleDamageModifier=0.4
    TreadDamageModifier=0.25

    VehicleMomentumScaling=0.05 //minimal movement on vehicles from hits

    HumanObliterationThreshhold=180

    DamageKick= (X=-10.0,Y=10.0,Z=100.0)
    KDeathVel=500.000000 //350.0
    KDeathUpKick=150 //50
    bAlwaysSevers=true
    PawnDamageEmitter=class'DH_Effects.DHBloodPuffLargeCaliber'
}

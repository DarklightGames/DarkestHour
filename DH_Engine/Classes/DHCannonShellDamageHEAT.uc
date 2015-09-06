//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHCannonShellDamageHEAT extends ROTankShellExplosionDamage
    abstract;

defaultproperties
{
    TankDamageModifier=0.02
    APCDamageModifier=0.4
    VehicleDamageModifier=0.85
    TreadDamageModifier=0.2
    DeathString="%o was burnt up by %k's HEAT shell."
    MaleSuicide="%o was burnt up his own HEAT shell."
    FemaleSuicide="%o was burnt up by her own HEAT shell."
    bExtraMomentumZ=false
    KDeathVel=150.0
    HumanObliterationThreshhold=400
}

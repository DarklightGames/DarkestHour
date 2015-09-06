//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHCannonShellDamageHE extends ROTankShellExplosionDamage
    abstract;

defaultproperties
{
    TankDamageModifier=0.03
    APCDamageModifier=1.0
    VehicleDamageModifier=1.0
    TreadDamageModifier=0.85
    DeathString="%o was blown apart by %k's HE shell."
    MaleSuicide="%o was blown apart his own HE shell."
    FemaleSuicide="%o was blown apart by her own HE shell."
    KDeathVel=300.0
    KDeathUpKick=60.0
    KDeadLinZVelScale=0.002
    KDeadAngVelScale=0.003
    HumanObliterationThreshhold=265
}

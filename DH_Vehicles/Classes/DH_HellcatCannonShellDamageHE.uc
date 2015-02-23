//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_HellcatCannonShellDamageHE extends ROTankShellExplosionDamage
    abstract;

defaultproperties
{
    TankDamageModifier=0.04
    APCDamageModifier=0.5
    VehicleDamageModifier=1.0
    TreadDamageModifier=0.95
    DeathString="%o was ripped by shrapnel from %k's Hellcat HE shell."
    bArmorStops=true
    KDeathVel=300.0
    KDeathUpKick=60.0
    KDeadLinZVelScale=0.002
    KDeadAngVelScale=0.003
    HumanObliterationThreshhold=325
}

//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_JacksonCannonShellDamageHE extends ROTankShellExplosionDamage
    abstract;

defaultproperties
{
    TankDamageModifier=0.08
    APCDamageModifier=0.5
    VehicleDamageModifier=1.5
    TreadDamageModifier=1.0
    DeathString="%o was ripped by shrapnel from %k's Jackson HE shell."
    KDamageImpulse=6000.0
    KDeathVel=300.0
    KDeathUpKick=60.0
    HumanObliterationThreshhold=450
}

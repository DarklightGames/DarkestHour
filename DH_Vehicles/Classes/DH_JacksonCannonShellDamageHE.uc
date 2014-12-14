//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_JacksonCannonShellDamageHE extends ROTankShellExplosionDamage
      abstract;

defaultproperties
{
    TankDamageModifier=0.080000
    APCDamageModifier=0.500000
    VehicleDamageModifier=1.500000
    TreadDamageModifier=1.000000
    DeathString="%o was ripped by shrapnel from %k's Jackson HE shell."
    KDamageImpulse=6000.000000
    KDeathVel=300.000000
    KDeathUpKick=60.000000
    HumanObliterationThreshhold=450
}

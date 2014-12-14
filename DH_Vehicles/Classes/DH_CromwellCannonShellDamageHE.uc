//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_CromwellCannonShellDamageHE extends ROTankShellExplosionDamage
      abstract;

defaultproperties
{
    TankDamageModifier=0.040000
    APCDamageModifier=0.500000
    VehicleDamageModifier=1.000000
    TreadDamageModifier=1.000000
    DeathString="%o was ripped by shrapnel from %k's Cromwell HE shell."
    bArmorStops=true
    KDeathVel=300.000000
    KDeathUpKick=60.000000
    KDeadLinZVelScale=0.002000
    KDeadAngVelScale=0.003000
    HumanObliterationThreshhold=350
}

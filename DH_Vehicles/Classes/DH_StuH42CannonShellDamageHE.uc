//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_StuH42CannonShellDamageHE extends ROTankShellExplosionDamage
      abstract;

defaultproperties
{
     TankDamageModifier=0.150000
     APCDamageModifier=0.500000
     VehicleDamageModifier=1.000000
     TreadDamageModifier=1.000000
     DeathString="%o was ripped by shrapnel from %k's StuH42 HE shell."
     KDeathVel=300.000000
     KDeathUpKick=60.000000
     KDeadLinZVelScale=0.002000
     KDeadAngVelScale=0.003000
     HumanObliterationThreshhold=400
}

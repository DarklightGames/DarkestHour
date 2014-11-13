//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_ShermanFireFlyCannonShellDamageHE extends ROTankShellExplosionDamage
      abstract;

defaultproperties
{
     TankDamageModifier=0.040000
     APCDamageModifier=0.500000
     VehicleDamageModifier=1.000000
     TreadDamageModifier=0.850000
     DeathString="%o was ripped by shrapnel from %k's Sherman Firefly HE shell."
//   bArmorStops=true // Matt: removed as inconsistent with other relatively high power HE rounds, including Achilles that uses same gun & round
     KDeathVel=300.000000
     KDeathUpKick=60.000000
     KDeadLinZVelScale=0.002000
     KDeadAngVelScale=0.003000
     VehicleMomentumScaling=1.400000
     HumanObliterationThreshhold=325
}

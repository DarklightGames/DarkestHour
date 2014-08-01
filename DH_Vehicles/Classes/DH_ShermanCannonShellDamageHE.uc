//==============================================================================
// DH_ShermanCannonShellDamageHE
//
// Darkest Hour Source - (c) Darkest Hour Team 2010
// Red Orchestra Source - (c) Tripwire Interactive 2006
//
// M4 American Sherman tank - 75mm HE M48 - DamageType
//==============================================================================
class DH_ShermanCannonShellDamageHE extends ROTankShellExplosionDamage
      abstract;

defaultproperties
{
     APCDamageModifier=0.500000
     VehicleDamageModifier=1.000000
     TreadDamageModifier=0.950000
     DeathString="%o was ripped by shrapnel from %k's Sherman 75mm HE shell."
     bArmorStops=true
     KDeathVel=300.000000
     KDeathUpKick=60.000000
     KDeadLinZVelScale=0.002000
     KDeadAngVelScale=0.003000
     HumanObliterationThreshhold=350
}

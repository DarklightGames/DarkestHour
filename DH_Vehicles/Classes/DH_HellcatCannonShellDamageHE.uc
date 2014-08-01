//==============================================================================
// DH_HellcatCannonShellDamageHE
//
// Darkest Hour Source - (c) Darkest Hour Team 2010
// Red Orchestra Source - (c) Tripwire Interactive 2006
//
// M18 American tank destroyed "Hellcat" - 76mm M42A1 HE- DamageType
//==============================================================================
class DH_HellcatCannonShellDamageHE extends ROTankShellExplosionDamage
      abstract;

defaultproperties
{
     TankDamageModifier=0.040000
     APCDamageModifier=0.500000
     VehicleDamageModifier=1.000000
     TreadDamageModifier=0.950000
     DeathString="%o was ripped by shrapnel from %k's Hellcat HE shell."
     bArmorStops=true
     KDeathVel=300.000000
     KDeathUpKick=60.000000
     KDeadLinZVelScale=0.002000
     KDeadAngVelScale=0.003000
     HumanObliterationThreshhold=325
}

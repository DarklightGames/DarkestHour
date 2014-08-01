//==============================================================================
// DH_Stug3GCannonShellDamageHE
//
// Darkest Hour Source - (c) Darkest Hour Team 2010
// Red Orchestra Source - (c) Tripwire Interactive 2006
//
// German 75mm Sprgr.Patr.34 - DamageType
//==============================================================================
class DH_Stug3GCannonShellDamageHE extends ROTankShellExplosionDamage;

defaultproperties
{
     TankDamageModifier=0.040000
     APCDamageModifier=0.500000
     VehicleDamageModifier=1.000000
     TreadDamageModifier=0.850000
     DeathString="%o was ripped by shrapnel from %k's Stug III HE shell."
     bArmorStops=true
     KDeathVel=300.000000
     KDeathUpKick=60.000000
     KDeadLinZVelScale=0.002000
     KDeadAngVelScale=0.003000
     VehicleMomentumScaling=1.400000
     HumanObliterationThreshhold=265
}

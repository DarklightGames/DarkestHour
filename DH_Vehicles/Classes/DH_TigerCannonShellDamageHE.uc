//==============================================================================
// DH_TigerCannonShellDamageHE
//
// Darkest Hour Source - (c) Darkest Hour Team 2010
// Red Orchestra Source - (c) Tripwire Interactive 2006
//
// German 88mm Schw.Sprgr.Patr.L/4.5 - DamageType
//==============================================================================
class DH_TigerCannonShellDamageHE extends ROTankShellExplosionDamage;

defaultproperties
{
     TankDamageModifier=0.080000
     APCDamageModifier=0.500000
     VehicleDamageModifier=1.500000
     TreadDamageModifier=1.000000
     DeathString="%o was ripped by shrapnel from %k's Tiger I HE shell."
     KDamageImpulse=6000.000000
     KDeathVel=300.000000
     KDeathUpKick=60.000000
     VehicleMomentumScaling=1.600000
     HumanObliterationThreshhold=425
}

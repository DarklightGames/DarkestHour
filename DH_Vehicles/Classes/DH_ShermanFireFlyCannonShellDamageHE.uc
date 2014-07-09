//==============================================================================
// DH_ShermanFireFlyCannonShellDamageHE
//
// Darkest Hour Source - (c) Darkest Hour Team 2010
// Red Orchestra Source - (c) Tripwire Interactive 2006
//
// British M4 Sherman Mk.VC - HE Mk.I-T- Damage Type
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
     bArmorStops=True
     KDeathVel=300.000000
     KDeathUpKick=60.000000
     KDeadLinZVelScale=0.002000
     KDeadAngVelScale=0.003000
     VehicleMomentumScaling=1.400000
     HumanObliterationThreshhold=325
}

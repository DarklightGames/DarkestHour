//==============================================================================
// DH_Sherman105CannonShellDamageHEAT
//
// Darkest Hour Source - (c) Darkest Hour Team 2010
// Red Orchestra Source - (c) Tripwire Interactive 2006
//
// American M4A3(105) 105mm tank - M67 HEAT - DamageType
//==============================================================================
class DH_Sherman105CannonShellDamageHEAT extends ROTankShellExplosionDamage
      abstract;

defaultproperties
{
     TankDamageModifier=0.020000
     APCDamageModifier=0.650000
     VehicleDamageModifier=0.850000
     TreadDamageModifier=0.200000
     DeathString="%o was burnt up by %k's Sherman(105) HEAT shell."
     bArmorStops=true
     bExtraMomentumZ=false
     KDeathVel=150.000000
     HumanObliterationThreshhold=400
}

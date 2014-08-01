//==============================================================================
// DH_StuH42CannonShellDamageHEAT
//
// Darkest Hour Source - (c) Darkest Hour Team 2010
// Red Orchestra Source - (c) Tripwire Interactive 2006
//
// German SturmHaubitze 42 - Gr.38 Hl/C HEAT - DamageType
//==============================================================================
class DH_StuH42CannonShellDamageHEAT extends ROTankShellExplosionDamage
      abstract;

defaultproperties
{
     TankDamageModifier=0.020000
     APCDamageModifier=0.400000
     VehicleDamageModifier=0.850000
     TreadDamageModifier=0.200000
     DeathString="%o was burnt up by %k's StuH42 HEAT shell."
     bArmorStops=true
     bExtraMomentumZ=false
     KDeathVel=150.000000
     HumanObliterationThreshhold=400
}

//==============================================================================
// DH_PanzerIVCannonShellDamageHEAT
//
// Darkest Hour Source - (c) Darkest Hour Team 2010
// Red Orchestra Source - (c) Tripwire Interactive 2006
//
// Panzer IV - Gr.38 Hl/C HEAT - DamageType
//==============================================================================
class DH_PanzerIVCannonShellDamageHEAT extends ROTankShellExplosionDamage
      abstract;

defaultproperties
{
     TankDamageModifier=0.020000
     APCDamageModifier=0.400000
     VehicleDamageModifier=0.850000
     TreadDamageModifier=0.150000
     DeathString="%o was burnt up by %k's Panzer IV HEAT shell."
     bArmorStops=true
     bExtraMomentumZ=false
     KDeathVel=150.000000
     HumanObliterationThreshhold=325
}

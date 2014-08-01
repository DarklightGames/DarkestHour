//==============================================================================
// DH_PanzerIIINCannonShellHEAT
//
// Darkest Hour Source - (c) Darkest Hour Team 2010
// Red Orchestra Source - (c) Tripwire Interactive 2006
//
// Panzer III Ausf. N - Gr.38 Hl/C HEAT - DamageType
//==============================================================================
class DH_PanzerIIINCannonShellDamageHEAT extends ROTankShellExplosionDamage
      abstract;

defaultproperties
{
     TankDamageModifier=0.020000
     APCDamageModifier=0.650000
     VehicleDamageModifier=0.850000
     TreadDamageModifier=0.200000
     DeathString="%o was burnt up by %k's Panzer III HEAT shell."
     bArmorStops=true
     bExtraMomentumZ=false
     KDeathVel=150.000000
     HumanObliterationThreshhold=400
}

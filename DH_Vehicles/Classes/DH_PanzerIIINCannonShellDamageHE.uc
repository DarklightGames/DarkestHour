//==============================================================================
// DH_PanzerIIINCannonShellHE
//
// Darkest Hour Source - (c) Darkest Hour Team 2010
// Red Orchestra Source - (c) Tripwire Interactive 2006
//
// Panzer III Ausf. N - Sprgr.Kw.K.(34)HE - DamageType
//==============================================================================
class DH_PanzerIIINCannonShellDamageHE extends ROTankShellExplosionDamage
      abstract;

defaultproperties
{
     APCDamageModifier=0.500000
     VehicleDamageModifier=1.000000
     TreadDamageModifier=0.850000
     DeathString="%o was ripped by shrapnel from %k's Panzer III HE shell."
     bArmorStops=true // Matt: added to be consistent with all other relatively low power HE shells
     KDeathVel=300.000000
     KDeathUpKick=60.000000
     KDeadLinZVelScale=0.002000
     KDeadAngVelScale=0.003000
     HumanObliterationThreshhold=265
}

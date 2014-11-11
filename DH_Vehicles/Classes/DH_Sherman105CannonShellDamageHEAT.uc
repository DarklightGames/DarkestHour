//==============================================================================
// DH_Sherman105CannonShellDamageHEAT
//
// Darkest Hour Source - (c) Darkest Hour Team 2010
// Red Orchestra Source - (c) Tripwire Interactive 2006
//
// American M4A3(105) 105mm tank - M67 HEAT - DamageType
//==============================================================================
class DH_Sherman105CannonShellDamageHEAT extends DH_HEATCannonShellDamage // Matt: changed class extended
      abstract;

defaultproperties
{
    APCDamageModifier=0.650000 // Matt: P4 & Stuh have 0.4, why different to Stuh (but same as P3)?
    DeathString="%o was burnt up by %k's Sherman(105) HEAT shell."
}

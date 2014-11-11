//==============================================================================
// DH_PanzerIIINCannonShellDamageHEAT
//
// Darkest Hour Source - (c) Darkest Hour Team 2010
// Red Orchestra Source - (c) Tripwire Interactive 2006
//
// Panzer III Ausf. N - Gr.38 Hl/C HEAT - DamageType
//==============================================================================
class DH_PanzerIIINCannonShellDamageHEAT extends DH_HEATCannonShellDamage // Matt: changed class extended
      abstract;

defaultproperties
{
    APCDamageModifier=0.650000 // Matt: P4 & Stuh have 0.4, why different (but same as S105)?
    DeathString="%o was burnt up by %k's Panzer III HEAT shell."
}

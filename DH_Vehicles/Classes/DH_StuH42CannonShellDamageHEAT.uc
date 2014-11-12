//==============================================================================
// DH_StuH42CannonShellDamageHEAT
//
// Darkest Hour Source - (c) Darkest Hour Team 2010
// Red Orchestra Source - (c) Tripwire Interactive 2006
//
// German SturmHaubitze 42 - Gr.38 Hl/C HEAT - DamageType
//==============================================================================
class DH_StuH42CannonShellDamageHEAT extends DH_HEATCannonShellDamage
      abstract;

defaultproperties
{
    APCDamageModifier=0.650000 // Matt: add this to match Sherman 105, instead of default 0.4
    DeathString="%o was burnt up by %k's StuH42 HEAT shell."
}

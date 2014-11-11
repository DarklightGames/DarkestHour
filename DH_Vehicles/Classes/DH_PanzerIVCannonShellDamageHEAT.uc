//==============================================================================
// DH_PanzerIVCannonShellDamageHEAT
//
// Darkest Hour Source - (c) Darkest Hour Team 2010
// Red Orchestra Source - (c) Tripwire Interactive 2006
//
// Panzer IV - Gr.38 Hl/C HEAT - DamageType
//==============================================================================
class DH_PanzerIVCannonShellDamageHEAT extends DH_HEATCannonShellDamage // Matt: changed class extended
      abstract;

defaultproperties
{
    TreadDamageModifier=0.150000 // Matt: all other HEAT damage classes have 0.2, why different?
    DeathString="%o was burnt up by %k's Panzer IV HEAT shell."
    HumanObliterationThreshhold=325 // Matt: all other HEAT damage classes have 400, why different?
}

//==============================================================================
// DH_PanzerIVCannonShellDamageHEAT
//
// Darkest Hour Source - (c) Darkest Hour Team 2010
// Red Orchestra Source - (c) Tripwire Interactive 2006
//
// Panzer IV - Gr.38 Hl/C HEAT - DamageType
//==============================================================================
class DH_PanzerIVCannonShellDamageHEAT extends DH_HEATCannonShellDamage
      abstract;

defaultproperties
{
//  TreadDamageModifier=0.150000    // Matt: removed so uses default 0.2, same as all other HEAT damage classes
    DeathString="%o was burnt up by %k's Panzer IV HEAT shell."
//  HumanObliterationThreshhold=325 // Matt: removed so uses default 400, same as all other HEAT damage classes
}

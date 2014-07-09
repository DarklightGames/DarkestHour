//==============================================================================
// DH_HellcatCannonShellDamageHVAP
//
// Darkest Hour Source - (c) Darkest Hour Team 2010
// Red Orchestra Source - (c) Tripwire Interactive 2006
//
// M18 American tank destroyer "Hellcat" - 76mm HVAP M93 - DamageType
//==============================================================================
class DH_HellcatCannonShellDamageHVAP extends ROTankShellImpactDamage
      abstract;

defaultproperties
{
     APCDamageModifier=0.500000
     TreadDamageModifier=0.950000
     DeathString="%o was killed by %k's Hellcat HVAP shell."
}

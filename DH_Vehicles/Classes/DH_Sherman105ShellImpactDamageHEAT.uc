//==============================================================================
// DH_Sherman105ShellImpactDamageHEAT
//
// Darkest Hour Source - (c) Darkest Hour Team 2010
// Red Orchestra Source - (c) Tripwire Interactive 2006
//
// American M4A3(105) 105mm tank - M67 HEAT - ImpactDamageType
//==============================================================================
class DH_Sherman105ShellImpactDamageHEAT extends ROTankShellImpactDamage
      abstract;

defaultproperties
{
     APCDamageModifier=0.750000
     DeathString="%o was killed by %k's Sherman(105) HEAT shell."
     bArmorStops=True
}

//==============================================================================
// DH_HellcatCannonShellDamageAP
//
// Darkest Hour Source - (c) Darkest Hour Team 2010
// Red Orchestra Source - (c) Tripwire Interactive 2006
//
// M18 American tank destroyer "Hellcat" - 76mm APC M62 - DamageType
//==============================================================================
class DH_HellcatCannonShellDamageAP extends ROTankShellImpactDamage
      abstract;

defaultproperties
{
     APCDamageModifier=0.750000
     VehicleDamageModifier=1.500000
     TreadDamageModifier=0.950000
     DeathString="%o was killed by %k's Hellcat APC shell."
}

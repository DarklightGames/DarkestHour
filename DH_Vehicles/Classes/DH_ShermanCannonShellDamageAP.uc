//==============================================================================
// DH_ShermanCannonShellDamageAP
//
// Darkest Hour Source - (c) Darkest Hour Team 2010
// Red Orchestra Source - (c) Tripwire Interactive 2006
//
// M4 American Sherman tank - 75mm APC M61 - DamageType
//==============================================================================
class DH_ShermanCannonShellDamageAP extends ROTankShellImpactDamage
      abstract;

defaultproperties
{
     APCDamageModifier=0.750000
     VehicleDamageModifier=1.500000
     TreadDamageModifier=0.850000
     DeathString="%o was killed by %k's Sherman 75mm APC shell."
}

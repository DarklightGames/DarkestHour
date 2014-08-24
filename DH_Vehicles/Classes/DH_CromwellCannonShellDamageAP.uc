//==============================================================================
// DH_CromwellCannonShellDamageAP
//
// Darkest Hour Source - (c) Darkest Hour Team 2010
// Red Orchestra Source - (c) Tripwire Interactive 2006
//
// British Cromwell Mk.IV tank - 75mm APC M61 - DamageType
//==============================================================================
class DH_CromwellCannonShellDamageAP extends ROTankShellImpactDamage
      abstract;

defaultproperties
{
     APCDamageModifier=0.750000
     VehicleDamageModifier=1.500000
     TreadDamageModifier=0.850000
     DeathString="%o was killed by %k's Cromwell APC shell."
}

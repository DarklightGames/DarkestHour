//==============================================================================
// DH_AchillesCannonShellDamageAP
//
// Darkest Hour Source - (c) Darkest Hour Team 2010
// Red Orchestra Source - (c) Tripwire Interactive 2006
//
// M10 British tank destroyer "Achilles IC" - 76.2mm APC Shot - Damage Type
//==============================================================================
class DH_AchillesCannonShellDamageAP extends ROTankShellImpactDamage //ROWeaponDamageType
	  abstract;

defaultproperties
{
     APCDamageModifier=0.750000
     VehicleDamageModifier=1.500000
     DeathString="%o was killed by %k's Achilles APC shell."
}

//==============================================================================
// DH_AchillesCannonShellDamageAPDS
//
// Darkest Hour Source - (c) Darkest Hour Team 2010
// Red Orchestra Source - (c) Tripwire Interactive 2006
//
// M10 British tank destroyer "Achilles IC" - APDS Mk.I - DamageType
//==============================================================================
class DH_AchillesCannonShellDamageAPDS extends ROTankShellImpactDamage //ROWeaponDamageType
	  abstract;

defaultproperties
{
     APCDamageModifier=0.500000
     TreadDamageModifier=0.850000
     DeathString="%o was killed by %k's Achilles APDS shell."
}

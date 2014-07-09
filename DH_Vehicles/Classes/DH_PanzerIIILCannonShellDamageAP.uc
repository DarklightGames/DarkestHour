//==============================================================================
// DH_PanzerIIILCannonShellDamageAP
//
// Darkest Hour Source - (c) Darkest Hour Team 2010
// Red Orchestra Source - (c) Tripwire Interactive 2006
//
// Panzer III Ausf. L - 50mm Pzgr.39 APC - DamageType
//==============================================================================
class DH_PanzerIIILCannonShellDamageAP extends ROTankShellImpactDamage
      abstract;

//Damage class for shells in the 37mm to 50mm calibers

defaultproperties
{
     APCDamageModifier=0.750000
     VehicleDamageModifier=0.850000
     TreadDamageModifier=0.750000
     DeathString="%o was killed by %k's Panzer III Ausf.L APC shell."
}

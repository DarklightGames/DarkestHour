//==============================================================================
// DH_Sdkfz2342CannonShellDamageAP
//
// Darkest Hour Source - (c) Darkest Hour Team 2010
// Red Orchestra Source - (c) Tripwire Interactive 2006
//
// Sdkfz 234/2 - 50mm Pzgr.39 APC - DamageType
//==============================================================================
class DH_Sdkfz2342CannonShellDamageAP extends ROTankShellImpactDamage
      abstract;

//Damage class for shells in the 37mm to 50mm calibers

defaultproperties
{
     APCDamageModifier=0.750000
     VehicleDamageModifier=0.850000
     TreadDamageModifier=0.750000
     DeathString="%o was killed by %k's Sdkfz 234/2 APC shell."
}

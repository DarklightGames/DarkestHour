//==============================================================================
// DH_Sdkfz2342CannonShellDamageHE
//
// Darkest Hour Source - (c) Darkest Hour Team 2010
// Red Orchestra Source - (c) Tripwire Interactive 2006
//
// Sdkfz 234/2 - 50mm Sprgr.Patr.38 HE - DamageType
//==============================================================================
class DH_Sdkfz2342CannonShellDamageHE extends ROTankShellExplosionDamage;

defaultproperties
{
     TankDamageModifier=0.000000
     APCDamageModifier=0.500000
     VehicleDamageModifier=1.000000
     TreadDamageModifier=0.500000
     DeathString="%o was ripped by shrapnel from %k's Sdkfz 234/2 HE shell."
     bArmorStops=True
     KDamageImpulse=3000.000000
     VehicleMomentumScaling=1.100000
     HumanObliterationThreshhold=180
}

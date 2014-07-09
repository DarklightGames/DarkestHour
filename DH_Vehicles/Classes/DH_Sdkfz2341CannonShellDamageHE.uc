//==============================================================================
// DH_Sdkfz2341CannonShellDamageHE
//
// Darkest Hour Source - (c) Darkest Hour Team 2010
// Red Orchestra Source - (c) Tripwire Interactive 2006
//
// German 20mm 2cm Br Sprgr. Patr. Vk L'spur (High Explosive Incendiary Tracer)
//==============================================================================
class DH_Sdkfz2341CannonShellDamageHE extends ROTankShellExplosionDamage;

defaultproperties
{
     TankDamageModifier=0.000000
     APCDamageModifier=0.150000
     VehicleDamageModifier=1.000000
     TreadDamageModifier=0.150000
     DeathString="%o was ripped by shrapnel from %k's Sdkfz 234/2 HE shell."
     bArmorStops=True
     VehicleMomentumScaling=0.050000
     HumanObliterationThreshhold=100
}

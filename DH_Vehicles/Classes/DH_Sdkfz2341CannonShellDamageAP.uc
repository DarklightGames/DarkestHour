//==============================================================================
// DH_Sdkfz2341CannonShellDamageAP
//
// Darkest Hour Source - (c) Darkest Hour Team 2010
// Red Orchestra Source - (c) Tripwire Interactive 2006
//
// German 20mm Pz.Gr.AP - DamageType
//==============================================================================
class DH_Sdkfz2341CannonShellDamageAP extends ROTankShellImpactDamage
      abstract;

defaultproperties
{
     TankDamageModifier=0.150000
     APCDamageModifier=0.350000
     VehicleDamageModifier=0.750000
     TreadDamageModifier=0.500000
     DeathString="%o was killed by %k's Sdkfz 234/1 AP shell."
     VehicleMomentumScaling=0.300000
     HumanObliterationThreshhold=75
}

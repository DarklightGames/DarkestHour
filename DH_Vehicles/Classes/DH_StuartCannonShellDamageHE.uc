//==============================================================================
// DH_StuartCannonShellDamageHE
//
// Darkest Hour Source - (c) Darkest Hour Team 2010
// Red Orchestra Source - (c) Tripwire Interactive 2006
//
// American tank shell - 37mm HE M63
//==============================================================================
class DH_StuartCannonShellDamageHE extends ROTankShellExplosionDamage;

defaultproperties
{
     TankDamageModifier=0.000000
     APCDamageModifier=0.450000
     VehicleDamageModifier=1.000000
     TreadDamageModifier=0.500000
     DeathString="%o was ripped by shrapnel from %k's Stuart HE shell."
     bArmorStops=True
     KDamageImpulse=3000.000000
     VehicleMomentumScaling=1.100000
     HumanObliterationThreshhold=180
}

//==============================================================================
// DH_ShermanM4A176WCannonShellDamageHE
//
// Darkest Hour Source - (c) Darkest Hour Team 2010
// Red Orchestra Source - (c) Tripwire Interactive 2006
//
// M4 American Sherman Tank - 76mm M42A1 HE
//==============================================================================
class DH_ShermanM4A176WCannonShellDamageHE extends ROTankShellExplosionDamage;

defaultproperties
{
     TankDamageModifier=0.040000
     APCDamageModifier=0.500000
     VehicleDamageModifier=1.000000
     TreadDamageModifier=0.950000
     DeathString="%o was ripped by shrapnel from %k's Sherman 76mm HE shell."
     bArmorStops=true
     KDeathVel=300.000000
     KDeathUpKick=60.000000
     KDeadLinZVelScale=0.002000
     KDeadAngVelScale=0.003000
     HumanObliterationThreshhold=225
}

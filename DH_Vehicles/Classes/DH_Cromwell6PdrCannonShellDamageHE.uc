//==============================================================================
// DH_Cromwell6PdrCannonShellDamageHE
//
// Darkest Hour Source - (c) Darkest Hour Team 2010
// Red Orchestra Source - (c) Tripwire Interactive 2006
//
// Cromwell Mk.I tank - Mk.X-T HE - DamageType
//==============================================================================
class DH_Cromwell6PdrCannonShellDamageHE extends ROTankShellExplosionDamage;

defaultproperties
{
     TankDamageModifier=0.000000
     APCDamageModifier=0.500000
     VehicleDamageModifier=1.000000
     TreadDamageModifier=0.750000
     DeathString="%o was ripped by shrapnel from %k's Cromwell 6 Pounder HE shell."
     FemaleSuicide="%o fired her Cromwell 6 Pounder HE shell prematurely."
     MaleSuicide="%o fired his Cromwell 6 Pounder HE shell prematurely."
     bArmorStops=true
     KDeathVel=300.000000
     KDeathUpKick=60.000000
     KDeadLinZVelScale=0.002000
     KDeadAngVelScale=0.003000
     HumanObliterationThreshhold=200
}

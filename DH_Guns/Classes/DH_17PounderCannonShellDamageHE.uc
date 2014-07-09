//==============================================================================
// DH_17PounderCannonShellDamageHE
//
// Darkest Hour Source - (c) Darkest Hour Team 2010
// Red Orchestra Source - (c) Tripwire Interactive 2006
// AHZ AT Gun Source -(c) William "Teufelhund" Miller
//
// 17 Pounder Mk. I AT Gun - Mk.I HE-T- DamageType
//==============================================================================
class DH_17PounderCannonShellDamageHE extends ROTankShellExplosionDamage
      abstract;

defaultproperties
{
     HUDIcon=Texture'DH_InterfaceArt_tex.deathicons.ATGunKill'
     TankDamageModifier=0.040000
     APCDamageModifier=0.500000
     VehicleDamageModifier=1.000000
     TreadDamageModifier=0.850000
     DeathString="%o was ripped by shrapnel from %k's 17 Pounder AT-Gun HE shell."
     FemaleSuicide="%o fired her 17 Pounder AT-Gun HE shell prematurely."
     MaleSuicide="%o fired his 17 Pounder AT-Gun HE shell prematurely."
     KDeathVel=300.000000
     KDeathUpKick=60.000000
     KDeadLinZVelScale=0.002000
     KDeadAngVelScale=0.003000
     VehicleMomentumScaling=1.400000
     HumanObliterationThreshhold=325
}

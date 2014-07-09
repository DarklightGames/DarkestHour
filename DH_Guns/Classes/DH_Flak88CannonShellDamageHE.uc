//==============================================================================
// DH_Flak88CannonShellDamageHE
//
// Darkest Hour Source - (c) Darkest Hour Team 2010
// Red Orchestra Source - (c) Tripwire Interactive 2006
// AHZ AT Gun Source -(c) William "Teufelhund" Miller
//
// German 88mm Schw.Sprgr.Patr.L/4.5 - DamageType
//==============================================================================
class DH_Flak88CannonShellDamageHE extends ROTankShellExplosionDamage;

defaultproperties
{
     HUDIcon=Texture'DH_InterfaceArt_tex.deathicons.ATGunKill'
     TankDamageModifier=0.080000
     APCDamageModifier=0.500000
     VehicleDamageModifier=1.500000
     TreadDamageModifier=1.000000
     DeathString="%o was ripped by shrapnel from %k's Flak 36 HE shell."
     FemaleSuicide="%o fired her Flak 36 HE shell prematurely."
     MaleSuicide="%o fired his Flak 36 HE shell prematurely."
     KDamageImpulse=6000.000000
     KDeathVel=300.000000
     KDeathUpKick=60.000000
     VehicleMomentumScaling=1.600000
     HumanObliterationThreshhold=450
}

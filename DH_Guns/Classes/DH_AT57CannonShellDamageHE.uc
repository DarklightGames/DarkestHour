//==============================================================================
// DH_AT57CannonShellDamageHE
//
// Darkest Hour Source - (c) Darkest Hour Team 2010
// Red Orchestra Source - (c) Tripwire Interactive 2006
// AHZ AT Gun Source -(c) William "Teufelhund" Miller
//
// American 57mm HE shell M303 - DamageType
//==============================================================================
class DH_AT57CannonShellDamageHE extends ROTankShellExplosionDamage;

defaultproperties
{
     HUDIcon=Texture'DH_InterfaceArt_tex.deathicons.ATGunKill'
     TankDamageModifier=0.000000
     APCDamageModifier=0.500000
     VehicleDamageModifier=1.000000
     TreadDamageModifier=0.750000
     DeathString="%o was ripped by shrapnel from %k's 57mm HE shell."
     FemaleSuicide="%o fired her 57mm AT-Gun HE shell prematurely."
     MaleSuicide="%o fired his 57mm AT-Gun HE shell prematurely."
     bArmorStops=True
     KDeathVel=300.000000
     KDeathUpKick=60.000000
     KDeadLinZVelScale=0.002000
     KDeadAngVelScale=0.003000
     HumanObliterationThreshhold=200
}

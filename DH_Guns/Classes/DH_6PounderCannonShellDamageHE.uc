//==============================================================================
// DH_6PounderCannonShellDamageHE
//
// Darkest Hour Source - (c) Darkest Hour Team 2010
// Red Orchestra Source - (c) Tripwire Interactive 2006
// AHZ AT Gun Source -(c) William "Teufelhund" Miller
//
// 6 Pounder Mk. IV AT Gun - Mk.X-T HE - DamageType
//==============================================================================
class DH_6PounderCannonShellDamageHE extends ROTankShellExplosionDamage;

defaultproperties
{
     HUDIcon=Texture'DH_InterfaceArt_tex.deathicons.ATGunKill'
     TankDamageModifier=0.000000
     APCDamageModifier=0.500000
     VehicleDamageModifier=1.000000
     TreadDamageModifier=0.750000
     DeathString="%o was ripped by shrapnel from %k's 6 Pounder HE shell."
     FemaleSuicide="%o fired her 6 Pounder AT-Gun HE shell prematurely."
     MaleSuicide="%o fired his 6 Pounder AT-Gun HE shell prematurely."
     bArmorStops=True
     KDeathVel=300.000000
     KDeathUpKick=60.000000
     KDeadLinZVelScale=0.002000
     KDeadAngVelScale=0.003000
     HumanObliterationThreshhold=200
}

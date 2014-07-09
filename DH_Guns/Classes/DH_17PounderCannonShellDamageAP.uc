//==============================================================================
// DH_17PounderCannonShellDamageAP
//
// Darkest Hour Source - (c) Darkest Hour Team 2010
// Red Orchestra Source - (c) Tripwire Interactive 2006
// AHZ AT Gun Source -(c) William "Teufelhund" Miller
//
// 17 Pounder Mk. I AT Gun - 76.2mm APC Shot Mk.IV - DamageType
//==============================================================================
class DH_17PounderCannonShellDamageAP extends ROTankShellImpactDamage;

defaultproperties
{
     HUDIcon=Texture'DH_InterfaceArt_tex.deathicons.ATGunKill'
     APCDamageModifier=0.750000
     VehicleDamageModifier=1.500000
     DeathString="%o was killed by %k's 17 Pounder AT-Gun APC shell."
     FemaleSuicide="%o fired her 17 Pounder AT-Gun APC shell prematurely."
     MaleSuicide="%o fired his 17 Pounder AT-Gun APC shell prematurely."
}

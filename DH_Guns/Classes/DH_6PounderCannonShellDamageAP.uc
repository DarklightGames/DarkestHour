//==============================================================================
// DH_6PounderCannonShellDamageAP
//
// Darkest Hour Source - (c) Darkest Hour Team 2010
// Red Orchestra Source - (c) Tripwire Interactive 2006
// AHZ AT Gun Source -(c) William "Teufelhund" Miller
//
// 6 Pounder Mk. IV AT Gun - Mk.IX APCBC Shot - DamageType
//==============================================================================
class DH_6PounderCannonShellDamageAP extends ROTankShellImpactDamage;

defaultproperties
{
     HUDIcon=Texture'DH_InterfaceArt_tex.deathicons.ATGunKill'
     APCDamageModifier=0.750000
     TreadDamageModifier=0.850000
     DeathString="%o was killed by %k's 6 Pounder AT-Gun APC shell."
     FemaleSuicide="%o fired her 6 Pounder AT-Gun shell APC prematurely."
     MaleSuicide="%o fired his 6 Pounder AT-Gun shell APC prematurely."
}

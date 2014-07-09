//==============================================================================
// DH_AT57CannonShellDamageAP
//
// Darkest Hour Source - (c) Darkest Hour Team 2010
// Red Orchestra Source - (c) Tripwire Interactive 2006
// AHZ AT Gun Source -(c) William "Teufelhund" Miller
//
// American 57mm APC shell M86 - DamageType
//==============================================================================
class DH_AT57CannonShellDamageAP extends ROTankShellImpactDamage;

defaultproperties
{
     HUDIcon=Texture'DH_InterfaceArt_tex.deathicons.ATGunKill'
     APCDamageModifier=0.750000
     TreadDamageModifier=0.850000
     DeathString="%o was killed by %k's 57mm AT-Gun APC shell."
     FemaleSuicide="%o fired her 57mm Pounder AT-Gun APC shell prematurely."
     MaleSuicide="%o fired his 57mm AT-Gun APC shell prematurely."
}

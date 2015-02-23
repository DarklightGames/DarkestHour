//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_17PounderCannonShellDamageAP extends DHTankShellImpactDamage
    abstract;

defaultproperties
{
    HUDIcon=texture'DH_InterfaceArt_tex.deathicons.ATGunKill'
    APCDamageModifier=0.75
    VehicleDamageModifier=1.5
    DeathString="%o was killed by %k's 17 Pounder AT-Gun APC shell."
    FemaleSuicide="%o fired her 17 Pounder AT-Gun APC shell prematurely."
    MaleSuicide="%o fired his 17 Pounder AT-Gun APC shell prematurely."
}

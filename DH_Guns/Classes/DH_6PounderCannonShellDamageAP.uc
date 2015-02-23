//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_6PounderCannonShellDamageAP extends DHTankShellImpactDamage
    abstract;

defaultproperties
{
    HUDIcon=texture'DH_InterfaceArt_tex.deathicons.ATGunKill'
    APCDamageModifier=0.75
    TreadDamageModifier=0.85
    DeathString="%o was killed by %k's 6 Pounder AT-Gun APC shell."
    FemaleSuicide="%o fired her 6 Pounder AT-Gun shell APC prematurely."
    MaleSuicide="%o fired his 6 Pounder AT-Gun shell APC prematurely."
}

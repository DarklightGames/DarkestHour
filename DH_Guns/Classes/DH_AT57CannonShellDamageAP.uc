//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_AT57CannonShellDamageAP extends DHTankShellImpactDamage
    abstract;

defaultproperties
{
    HUDIcon=texture'DH_InterfaceArt_tex.deathicons.ATGunKill'
    APCDamageModifier=0.75
    TreadDamageModifier=0.85
    DeathString="%o was killed by %k's 57mm AT-Gun APC shell."
    FemaleSuicide="%o fired her 57mm Pounder AT-Gun APC shell prematurely."
    MaleSuicide="%o fired his 57mm AT-Gun APC shell prematurely."
}

//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_6PounderCannonShellDamageAPDS extends DHTankShellImpactDamage
    abstract;

defaultproperties
{
    HUDIcon=texture'DH_InterfaceArt_tex.deathicons.ATGunKill'
    APCDamageModifier=0.500000
    TreadDamageModifier=0.750000
    DeathString="%o was killed by %k's 6 Pounder AT-Gun APDS shot."
    FemaleSuicide="%o fired her 6 Pounder AT-Gun APDS shot prematurely."
    MaleSuicide="%o fired his 6 Pounder AT-Gun APDS shot prematurely."
}

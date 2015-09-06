//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_6PounderCannonShellDamageAPDS extends DHCannonShellDamageImpact
    abstract;

defaultproperties
{
    HUDIcon=texture'DH_InterfaceArt_tex.deathicons.ATGunKill'
    APCDamageModifier=0.5
    TreadDamageModifier=0.75
    DeathString="%o was killed by %k's 6 Pounder AT gun APDS shell."
}

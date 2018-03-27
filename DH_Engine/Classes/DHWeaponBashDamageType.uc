//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2018
//==============================================================================

class DHWeaponBashDamageType extends DHMeleeWeaponDamageType
    abstract;

defaultproperties
{
    DeathString="%o was bludgeoned to death by %k's %w."
    MaleSuicide="%o bludgeoned himself to death with his own %w."
    FemaleSuicide="%o bludgeoned herself to death with her own %w."

    HUDIcon=Texture'InterfaceArt_tex.deathicons.buttsmack'

    KDamageImpulse=2000
    KDeathUpKick=25
}

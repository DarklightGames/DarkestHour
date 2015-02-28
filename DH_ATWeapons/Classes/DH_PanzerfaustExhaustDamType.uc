//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_PanzerfaustExhaustDamType extends DHGrenadeDamageType
    abstract;

defaultproperties
{
    HUDIcon=texture'DH_InterfaceArt_tex.deathicons.backblastkill'
    bCauseViewJarring=true
    WeaponClass=class'DH_ATWeapons.DH_PanzerFaustWeapon'
    DeathString="%o was cooked by the exhaust from %k's %w."
    FemaleSuicide="%o was cooked by the exhaust from her own %w."
    MaleSuicide="%o was cooked by the exhaust from his own %w."
    GibModifier=0.0
    DeathOverlayMaterial=Combiner'Effects_Tex.GoreDecals.PlayerDeathOverlay'
    DeathOverlayTime=999.0
    KDeathVel=20.0
}

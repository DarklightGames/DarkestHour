//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHRocketExhaustDamageType extends DHThrowableExplosiveDamageType
    abstract;

defaultproperties
{
    HUDIcon=Texture'DH_InterfaceArt_tex.deathicons.backblastkill'
    DeathString="%o was cooked by the exhaust from %k's %w."
    MaleSuicide="%o was cooked by the exhaust from his own %w."
    FemaleSuicide="%o was cooked by the exhaust from her own %w."
    GibModifier=0.0
    KDeathVel=20.0
    bCauseViewJarring=true
}

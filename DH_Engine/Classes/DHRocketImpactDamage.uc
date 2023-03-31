//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHRocketImpactDamage extends RORocketImpactDamage
    abstract;

defaultproperties
{
    DeathString="%o was killed by %k's %w."
    MaleSuicide="%o was killed by his own %w."
    FemaleSuicide="%o was killed by her own %w."
    DeathOverlayMaterial=Combiner'Effects_Tex.GoreDecals.PlayerDeathOverlay'
    DeathOverlayTime=999.0
}

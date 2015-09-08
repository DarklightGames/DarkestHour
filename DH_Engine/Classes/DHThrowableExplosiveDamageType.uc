//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHThrowableExplosiveDamageType extends ROGrenadeDamType
    abstract;

defaultproperties
{
    DeathString="%o was blown up by %k's %w."
	MaleSuicide="%o was blown up by his own %w."
	FemaleSuicide="%o was blown up by her own %w."
    DeathOverlayMaterial=Combiner'Effects_Tex.GoreDecals.PlayerDeathOverlay'
    DeathOverlayTime=999.0
}

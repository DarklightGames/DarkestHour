//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHThrowableExplosiveDamageType extends ROGrenadeDamType
    abstract;

defaultproperties
{
    // Reduced from 0.2 because APCs no longer have a damage threshold requiring an APCDamageModifier of at least 0.25
    // Grenades will cause a little damage to APCs (the same modifier as the limited damage radius explosion of an impacting AP shell)
    APCDamageModifier=0.05

    DeathString="%o was blown up by %k's %w."
    MaleSuicide="%o was blown up by his own %w."
    FemaleSuicide="%o was blown up by her own %w."
    DeathOverlayMaterial=Combiner'Effects_Tex.GoreDecals.PlayerDeathOverlay'
    DeathOverlayTime=999.0
}

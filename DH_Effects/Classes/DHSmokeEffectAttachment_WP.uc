//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================
// Actor that spawns a smoke emitter, plays the smoke sounds, and destroys
// itself when the sound is over.
//==============================================================================

class DHSmokeEffectAttachment_WP extends DHSmokeEffectAttachment
    notplaceable;

defaultproperties
{
    SmokeEmitterClass=class'DH_Effects.DHSmokeEffect_Phosphorus'
}

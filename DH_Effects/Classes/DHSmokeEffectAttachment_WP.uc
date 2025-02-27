//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
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

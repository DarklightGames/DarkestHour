//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHFlashEffectMedium extends Emitter;


defaultproperties
{
    LifeSpan=0.15

    Autodestroy=true
    bnodelete=false

    bDynamicLight=true
    bMovable=true

    LightType=LT_Steady
    LightBrightness = 64.0
    LightRadius = 16.0
    LightHue = 20
    LightSaturation = 128
    AmbientGlow = 254
    LightCone = 8
}

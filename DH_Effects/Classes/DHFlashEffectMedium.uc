//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
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

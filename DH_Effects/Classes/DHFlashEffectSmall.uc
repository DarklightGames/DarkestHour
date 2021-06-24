//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2021
//==============================================================================

class DHFlashEffectSmall extends Emitter;


defaultproperties
{
    LifeSpan=0.25

    Autodestroy=true
    bnodelete=false

    bDynamicLight=true
    bMovable=true

    LightType=LT_Steady
    LightBrightness = 24.0
    LightRadius = 5.0
    LightHue = 20
    LightSaturation = 128
    AmbientGlow = 254
    LightCone = 8
}

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

    LightEffect=LE_NonIncidence
    LightType=LT_Steady
    LightBrightness = 128.0 //64
    LightRadius = 24.0 //16
    LightHue = 20
    LightSaturation = 28
    AmbientGlow = 254
    LightCone = 8
}

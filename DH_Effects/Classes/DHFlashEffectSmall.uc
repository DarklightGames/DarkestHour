//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHFlashEffectSmall extends Emitter;


defaultproperties
{
    LifeSpan=0.10

    Autodestroy=true
    bnodelete=false

    bDynamicLight=true
    //bMovable=true

    LightEffect=LE_NonIncidence
    LightType=LT_Steady
    LightBrightness = 64.0
    LightRadius = 2.0
    LightHue = 20
    LightSaturation = 255
    AmbientGlow = 254
    LightCone = 8
}

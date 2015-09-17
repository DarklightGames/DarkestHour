//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_Flak38CannonShellAP extends DH_Sdkfz2341CannonShell;

defaultproperties
{
    ShellImpactDamage=class'DH_Guns.DH_Flak38CannonShellDamageAP'
    // TEST - why do all these properties have to be different from the 234/1? Should probably either be removed or added to 234/1.
    SpeedFudgeScale=0.5
    LightType=LT_Steady
    LightEffect=LE_QuadraticNonIncidence
    LightHue=28
    LightBrightness=255.0
    LightRadius=32.0
    bDynamicLight=true
    DrawScale=4.0
}

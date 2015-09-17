//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_Flak38CannonShellHE extends DH_Sdkfz2341CannonShellHE;

defaultproperties
{
    ShellImpactDamage=class'DH_Guns.DH_Flak38CannonShellDamageHE'
    MyDamageType=class'DH_Guns.DH_Flak38CannonShellDamageHE'
    // TEST - why do all these properties have to be different from the 234/1? Should probably either be removed or added to 234/1.
    ShellHitDirtEffectClass=class'ROEffects.GrenadeExplosion'
    ShellHitSnowEffectClass=class'ROEffects.GrenadeExplosion'
    ShellHitWoodEffectClass=class'ROEffects.GrenadeExplosion'
    ShellHitRockEffectClass=class'ROEffects.GrenadeExplosion'
    ShellHitWaterEffectClass=class'ROEffects.GrenadeExplosion'
    SpeedFudgeScale=0.5
    LightType=LT_Steady
    LightEffect=LE_QuadraticNonIncidence
    LightHue=28
    LightBrightness=255.0
    LightRadius=32.0
    bDynamicLight=true
}

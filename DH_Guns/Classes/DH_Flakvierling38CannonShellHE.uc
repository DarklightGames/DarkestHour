//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_Flakvierling38CannonShellHE extends DH_Sdkfz2341CannonShellHE;

defaultproperties
{
     ShellImpactDamage=class'DH_Guns.DH_Flakvierling38CannonShellDamageHE'
     ShellHitDirtEffectClass=class'ROEffects.GrenadeExplosion'
     ShellHitSnowEffectClass=class'ROEffects.GrenadeExplosion'
     ShellHitWoodEffectClass=class'ROEffects.GrenadeExplosion'
     ShellHitRockEffectClass=class'ROEffects.GrenadeExplosion'
     ShellHitWaterEffectClass=class'ROEffects.GrenadeExplosion'
     SpeedFudgeScale=0.500000
     LightType=LT_Steady
     LightEffect=LE_QuadraticNonIncidence
     LightHue=28
     LightBrightness=255.000000
     LightRadius=32.000000
     bDynamicLight=true
}

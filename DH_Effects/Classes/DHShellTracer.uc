//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHShellTracer extends Effects
    abstract;

var     float   DrawScaleIncreaseRate;
var     float   MaximumDrawScale;

simulated function Tick(float DeltaTime)
{
    SetDrawScale(FMin(MaximumDrawScale, DrawScale + (DrawScaleIncreaseRate * DeltaTime)));

    if (DrawScale >= MaximumDrawScale)
    {
        Disable('Tick');
    }
}

defaultproperties
{
    DrawScaleIncreaseRate=0.3
    MaximumDrawScale=0.3
    bTrailerSameRotation=true
    Physics=PHYS_Trailer
    Texture=Texture'DH_FX_Tex.Effects.RedFlare'
    DrawScale=0.01
    Style=STY_Additive
    Mass=13.0
}

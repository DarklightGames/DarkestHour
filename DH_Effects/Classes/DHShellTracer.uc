//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
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
    Texture=Texture'DH_FX_Tex.RedFlare'
    DrawScale=0.01
    Style=STY_Additive
    Mass=13.0
}

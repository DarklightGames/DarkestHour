//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHSpottingMarker extends Actor;

var FadeColor FC;
var bool      bIsDisabled;

simulated function PostBeginPlay()
{
    CreateMaterial();

    LoopAnim('Point');
}

simulated function SetColor(Color C)
{
    FC.Color1 = C;
    FC.Color1.A = 64;

    FC.Color2 = C;
    FC.Color2.A = 128;
}

function CreateMaterial()
{
    local FinalBlend FB;

    FC = new Class'FadeColor';
    FC.Color1 = Class'UColor'.default.Red;
    FC.Color1.A = 64;
    FC.Color2 = Class'UColor'.default.Red;
    FC.Color2.A = 128;
    FC.FadePeriod = 0.25;
    FC.ColorFadeType = FC_Sinusoidal;

    FB = new Class'FinalBlend';
    FB.FrameBufferBlending = FB_AlphaBlend;
    FB.ZWrite = true;
    FB.ZTest = true;
    FB.AlphaTest = true;
    FB.TwoSided = true;
    FB.Material = FC;

    Skins[0] = FB;
}

defaultproperties
{
    DrawType=DT_Mesh
    Mesh=SkeletalMesh'DH_Misc_anm.SpottingRing'
    RemoteRole=ROLE_None

    bHidden=false
    bBlockActors=false
    bBlockKarma=false
    bBlockNonZeroExtentTraces=false
    bBlockPlayers=false
    bBlockZeroExtentTraces=false
    bCollideActors=false
    bCollideWorld=false
    bUseCylinderCollision=false
    bStatic=false
    bWorldGeometry=false
    bIsDisabled=true
}

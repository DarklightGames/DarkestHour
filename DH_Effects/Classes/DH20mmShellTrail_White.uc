//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH20mmShellTrail_White extends Emitter;

defaultproperties
{
    AutoDestroy=true
    bNoDelete=false
    Physics=PHYS_Trailer
    bHardAttach=true

    Begin Object Class=TrailEmitter Name=TrailEmitter0
        TrailShadeType=PTTST_None//PTTST_Linear
        TrailLocation=PTTL_FollowEmitter
        MaxPointsPerTrail=15//150
        DistanceThreshold=5.0 //80.0
        UseCrossedSheets=true
        PointLifeTime=0.2
        UseColorScale=true
        UseSizeScale=true
        UseRegularSizeScale=false
        RespawnDeadParticles=False //added to kill tracer element at end of Lifetime
        AutomaticInitialSpawning=false
        ColorScale(0)=(Color=(R=255,G=255,B=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(R=255,G=255,B=255))
        Opacity=0.5
        MaxParticles=1
        SizeScale(0)=(RelativeSize=1.0)
        SizeScale(1)=(RelativeTime=1.0,RelativeSize=0.75)
        StartSizeRange=(X=(Min=6.0,Max=8.0),Y=(Min=30.0,Max=30.0),Z=(Min=30.0,Max=30.0))
        InitialParticlesPerSecond=2000.0
        Texture=Texture'DH_FX_Tex.dhtrailblur'
        SecondsBeforeInactive=0.0
        LifetimeRange=(Min=10.0,Max=10.0)
    End Object
    Emitters(0)=TrailEmitter'TrailEmitter0'
}

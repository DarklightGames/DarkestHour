//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHCasingTrail extends Emitter;

var() float VarOpacity;

simulated function PostBeginPlay()
{
    VarOpacity=FMax(0.0, 0.15);    

    Emitters[0].Opacity=VarOpacity;

    Super.PostBeginPlay();
}

defaultproperties
{
    AutoDestroy=true
    bNoDelete=false
    Physics=PHYS_Trailer
    bHardAttach=true
    //DrawScale=2.0

    Begin Object Class=TrailEmitter Name=TrailEmitter0
        FadeOut=True
        TrailShadeType=PTTST_Linear//PTTST_Linear
        TrailLocation=PTTL_FollowEmitter
        MaxPointsPerTrail=150.0
        DistanceThreshold=5.0
        UseCrossedSheets=false
        PointLifeTime=0.2
        UseColorScale=false
        UseSizeScale=true
        UseRegularSizeScale=false
        RespawnDeadParticles=False //added to kill tracer element at end of Lifetime
        AutomaticInitialSpawning=false
        Acceleration=(Z=150.0)
        ColorScale(0)=(Color=(G=255,R=255,B=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(G=255,R=255,B=255))
        FadeOutStartTime=0.15
        //Opacity=0.5
        MaxParticles=1
        DrawStyle=PTDS_Brighten
        SizeScale(0)=(RelativeSize=0.75)
        SizeScale(1)=(RelativeTime=1.0,RelativeSize=2.0) //2.0
        StartSizeRange=(X=(Min=0.4,Max=0.8),Y=(Min=0.4,Max=0.8),Z=(Min=0.4,Max=0.8))
        InitialParticlesPerSecond=2000.0
        Texture=Texture'DH_FX_tex.Effects.smoketrail'//'DH_FX_Tex.effects.dhtrailblur'
        SecondsBeforeInactive=0.0
        LifetimeRange=(Min=0.2,Max=0.35)
        InitialDelayRange=(Min=0.0,Max=0.1)
    End Object
    Emitters(0)=TrailEmitter'TrailEmitter0'
}

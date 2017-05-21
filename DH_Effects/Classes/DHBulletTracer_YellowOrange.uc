//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DHBulletTracer_YellowOrange extends Emitter;

defaultproperties
{
    AutoDestroy=true
    bNoDelete=false
    Physics=PHYS_Trailer
    bHardAttach=true

    Begin Object Class=TrailEmitter Name=TrailEmitter0
        TrailShadeType=PTTST_PointLife
        TrailLocation=PTTL_FollowEmitter
        MaxPointsPerTrail=150
        DistanceThreshold=80.0
        UseCrossedSheets=true
        PointLifeTime=0.2
        UseColorScale=true
        UseSizeScale=true
        UseRegularSizeScale=false
        AutomaticInitialSpawning=false
        ColorScale(0)=(Color=(B=20,G=209,R=235))
        ColorScale(1)=(RelativeTime=1.0,Color=(B=20,G=209,R=235))
        Opacity=0.65
        MaxParticles=1
        SizeScale(0)=(RelativeSize=1.0)
        SizeScale(1)=(RelativeTime=1.0,RelativeSize=0.5)
        StartSizeRange=(X=(Min=2.0,Max=2.0))
        InitialParticlesPerSecond=2000.0
        Texture=texture'Effects_Tex.Weapons.trailblur'
        SecondsBeforeInactive=0.0
        LifetimeRange=(Min=1.5,Max=2.5)
    End Object
    Emitters(0)=TrailEmitter'TrailEmitter0'
}

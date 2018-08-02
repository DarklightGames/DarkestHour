//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2018
//==============================================================================

class DHBloodPuffSmallCaliber extends Emitter;

defaultproperties
{
    Begin Object Class=SpriteEmitter Name=SpriteEmitter0
        FadeOut=true
        ResetAfterChange=true
        RespawnDeadParticles=false
        SpinParticles=true
        UseSizeScale=true
        UseRegularSizeScale=false
        UniformSize=true
        AutomaticInitialSpawning=false
        UseRandomSubdivision=true
        Acceleration=(Z=-80.0)
        ColorScale(0)=(Color=(B=250,G=250,R=250))
        ColorScale(1)=(RelativeTime=1.0,Color=(B=255,G=255,R=255,A=255))
        FadeInEndTime=0.05
        MaxParticles=4
        Name="SpriteEmitter5"
        StartLocationRange=(X=(Max=20.0))
        UseRotationFrom=PTRS_Actor
        StartSpinRange=(X=(Min=-0.5,Max=0.5))
        SizeScale(1)=(RelativeTime=0.25,RelativeSize=2.0)
        SizeScale(2)=(RelativeTime=0.5,RelativeSize=2.5)
        SizeScale(3)=(RelativeTime=1.0,RelativeSize=4.0)
        StartSizeRange=(X=(Min=5.0,Max=11.0),Y=(Min=5.0,Max=11.0),Z=(Min=5.0,Max=11.0))
        InitialParticlesPerSecond=1000.0
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.GoreEmitters.BloodCircle'
        TextureUSubdivisions=1
        TextureVSubdivisions=1
        LifetimeRange=(Min=0.8,Max=0.9)
        StartVelocityRange=(X=(Min=-60.0,Max=-40.0),Y=(Min=-10.0,Max=10.0),Z=(Max=75.0))
        MaxAbsVelocity=(X=1000.0,Y=1000.0,Z=1000.0)
        VelocityLossRange=(X=(Min=0.25,Max=0.25))
        GetVelocityDirectionFrom=PTVD_OwnerAndStartPosition
    End Object
    Emitters(0)=SpriteEmitter'SpriteEmitter0'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter1
        FadeOut=true
        RespawnDeadParticles=false
        SpinParticles=true
        UseSizeScale=true
        UseRegularSizeScale=false
        UniformSize=true
        AutomaticInitialSpawning=false
        UseRandomSubdivision=true
        Acceleration=(Z=-200.0)
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.0,Color=(B=255,G=255,R=255,A=255))
        MaxParticles=6
        Name="SpriteEmitter6"
        UseRotationFrom=PTRS_Actor
        StartSpinRange=(X=(Min=-180.0,Max=180.0),Y=(Min=-180.0,Max=180.0),Z=(Min=-180.0,Max=180.0))
        SizeScale(1)=(RelativeTime=1.0,RelativeSize=1.0)
        StartSizeRange=(X=(Min=10.0,Max=15.0),Y=(Min=10.0,Max=15.0),Z=(Min=10.0,Max=15.0))
        InitialParticlesPerSecond=1000.0
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.GoreEmitters.BloodCircle'
        LifetimeRange=(Min=0.5,Max=0.75)
        StartVelocityRange=(X=(Min=-40.0,Max=-20.0),Z=(Min=25.0,Max=50.0))
        VelocityLossRange=(X=(Min=0.25,Max=0.25))
    End Object
    Emitters(1)=SpriteEmitter'SpriteEmitter1'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter2
        FadeOut=true
        RespawnDeadParticles=false
        SpinParticles=true
        UseSizeScale=true
        UseRegularSizeScale=false
        UniformSize=true
        AutomaticInitialSpawning=false
        BlendBetweenSubdivisions=true
        UseRandomSubdivision=true
        ColorScale(0)=(Color=(A=255))
        ColorScale(1)=(RelativeTime=1.0,Color=(A=255))
        Opacity=0.5
        FadeOutStartTime=0.4
        MaxParticles=4
        Name="SpriteEmitter7"
        UseRotationFrom=PTRS_Actor
        StartSpinRange=(X=(Min=-0.5,Max=0.5))
        SizeScale(0)=(RelativeSize=0.5)
        SizeScale(1)=(RelativeTime=0.25,RelativeSize=1.5)
        SizeScale(2)=(RelativeTime=1.0,RelativeSize=2.5)
        StartSizeRange=(X=(Min=9.0,Max=11.0))
        InitialParticlesPerSecond=5000.0
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.BulletHits.metalsmokefinal'
        TextureUSubdivisions=2
        TextureVSubdivisions=2
        LifetimeRange=(Min=0.9,Max=0.9)
    End Object
    Emitters(2)=SpriteEmitter'SpriteEmitter2'

    AutoDestroy=true
    Style=STY_Alpha
    bDirectional=true
    bNoDelete=false
    RemoteRole=ROLE_DumbProxy
    bNetInitialRotation=true
    LifeSpan=1.5
}

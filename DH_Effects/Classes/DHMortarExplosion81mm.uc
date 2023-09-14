//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHMortarExplosion81mm extends Emitter;

defaultproperties
{
    AutoDestroy=true
    bNoDelete=false

    Begin Object Class=SpriteEmitter Name=SpriteEmitter0
        FadeOut=true
        FadeIn=true
        RespawnDeadParticles=false
        SpinParticles=true
        UseSizeScale=true
        UseRegularSizeScale=false
        UniformSize=true
        AutomaticInitialSpawning=false
        TriggerDisabled=false
        ResetOnTrigger=true
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.0,Color=(B=255,G=255,R=255,A=255))
        FadeOutStartTime=0.5
        FadeInEndTime=0.2
        MaxParticles=2
        StartLocationRange=(X=(Min=-10.0,Max=10.0),Y=(Min=-10.0,Max=10.0))
        SpinCCWorCW=(X=1.0)
        SpinsPerSecondRange=(X=(Min=-0.1,Max=0.1))
        StartSpinRange=(X=(Min=-0.5,Max=0.5))
        SizeScale(1)=(RelativeTime=0.25,RelativeSize=12.0)
        SizeScale(2)=(RelativeTime=1.0,RelativeSize=16.0)
        StartSizeRange=(X=(Min=30.0,Max=60.0),Y=(Min=30.0,Max=60.0),Z=(Min=45.0,Max=50.0))
        InitialParticlesPerSecond=500.0
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.explosions.LSmoke3'
        SecondsBeforeInactive=0.0
        LifetimeRange=(Max=6.0)
        StartVelocityRange=(X=(Min=-50.0,Max=50.0),Y=(Min=-50.0,Max=50.0),Z=(Min=50.0,Max=50.0))
        VelocityLossRange=(Z=(Min=3.0,Max=3.0))
    End Object
    Emitters(0)=SpriteEmitter'SpriteEmitter0'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter1
        FadeOut=true
        FadeIn=true
        RespawnDeadParticles=false
        SpinParticles=true
        UseSizeScale=true
        UseRegularSizeScale=false
        UniformSize=true
        AutomaticInitialSpawning=false
        TriggerDisabled=false
        ResetOnTrigger=true
        Acceleration=(X=32.0,Y=32.0,Z=-16.0)
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.0,Color=(B=255,G=255,R=255,A=255))
        Opacity=0.75
        FadeOutStartTime=1.02
        FadeInEndTime=0.51
        MaxParticles=5
        StartLocationOffset=(Z=64.0)
        StartLocationRange=(X=(Min=-10.0,Max=10.0),Y=(Min=-10.0,Max=10.0))
        SpinCCWorCW=(X=1.0)
        SpinsPerSecondRange=(X=(Min=0.1,Max=0.1))
        StartSpinRange=(X=(Min=-0.5,Max=0.5))
        SizeScale(0)=(RelativeSize=2.0)
        SizeScale(1)=(RelativeTime=0.5,RelativeSize=4.0)
        SizeScale(2)=(RelativeTime=1.0,RelativeSize=8.0)
        StartSizeRange=(X=(Min=30.0,Max=80.0),Y=(Min=30.0,Max=80.0),Z=(Min=45.0,Max=50.0))
        InitialParticlesPerSecond=15.0
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.explosions.LSmoke3'
        SecondsBeforeInactive=0.0
        LifetimeRange=(Min=2.0,Max=3.0)
        StartVelocityRange=(X=(Min=-122.472,Max=122.472),Y=(Min=-122.472,Max=122.472),Z=(Min=90.0,Max=90.0))
    End Object
    Emitters(1)=SpriteEmitter'SpriteEmitter1'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter2
        UseColorScale=true
        FadeOut=true
        RespawnDeadParticles=false
        UseSizeScale=true
        UseRegularSizeScale=false
        UniformSize=true
        AutomaticInitialSpawning=false
        BlendBetweenSubdivisions=true
        Acceleration=(Z=50.0)
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.0,Color=(B=255,G=255,R=255,A=255))
        ColorMultiplierRange=(X=(Min=0.25,Max=0.25),Y=(Min=0.25,Max=0.25),Z=(Min=0.25,Max=0.25))
        FadeOutFactor=(X=0.5,Y=0.5,Z=0.5)
        FadeOutStartTime=0.055
        MaxParticles=3
        SizeScale(1)=(RelativeTime=0.14,RelativeSize=2.0)
        SizeScale(2)=(RelativeTime=1.0,RelativeSize=3.0)
        StartSizeRange=(X=(Min=75.0,Max=75.0),Y=(Min=75.0,Max=75.0),Z=(Min=75.0,Max=75.0))
        InitialParticlesPerSecond=30.0
        DrawStyle=PTDS_Brighten
        Texture=Texture'Effects_Tex.explosions.impact_2frame'
        TextureUSubdivisions=2
        TextureVSubdivisions=1
        LifetimeRange=(Min=0.25,Max=0.25)
        StartVelocityRange=(Z=(Min=10.0,Max=10.0))
    End Object
    Emitters(2)=SpriteEmitter'SpriteEmitter2'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter3
        FadeOut=true
        FadeIn=true
        RespawnDeadParticles=false
        SpinParticles=true
        UseSizeScale=true
        UseRegularSizeScale=false
        UniformSize=true
        AutomaticInitialSpawning=false
        TriggerDisabled=false
        ResetOnTrigger=true
        Acceleration=(Y=50.0,Z=50.0)
        ColorScale(0)=(Color=(B=129,G=129,R=129,A=255))
        ColorScale(1)=(RelativeTime=1.0,Color=(B=255,G=255,R=255,A=255))
        Opacity=0.5
        MaxParticles=16
        StartLocationRange=(X=(Min=-10.0,Max=10.0),Y=(Min=-10.0,Max=10.0))
        SpinCCWorCW=(X=1.0)
        SpinsPerSecondRange=(X=(Max=0.25))
        StartSpinRange=(X=(Min=-0.5,Max=0.5))
        SizeScale(0)=(RelativeSize=2.0)
        SizeScale(1)=(RelativeTime=0.5,RelativeSize=4.0)
        SizeScale(2)=(RelativeTime=1.0,RelativeSize=6.0)
        StartSizeRange=(X=(Min=25.0,Max=75.0),Y=(Min=25.0,Max=75.0),Z=(Min=45.0,Max=50.0))
        InitialParticlesPerSecond=5000.0
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.explosions.LSmoke1'
        SecondsBeforeInactive=0.0
        LifetimeRange=(Min=7.0,Max=8.0)
        StartVelocityRange=(X=(Min=-100.0,Max=100.0),Y=(Min=-100.0,Max=100.0),Z=(Min=256.0,Max=1600.0))
        VelocityLossRange=(Z=(Min=1.0,Max=1.0))
    End Object
    Emitters(3)=SpriteEmitter'SpriteEmitter3'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter4
        FadeOut=true
        FadeIn=true
        RespawnDeadParticles=false
        SpinParticles=true
        UseSizeScale=true
        UseRegularSizeScale=false
        UniformSize=true
        AutomaticInitialSpawning=false
        TriggerDisabled=false
        ResetOnTrigger=true
        Acceleration=(Y=50.0,Z=50.0)
        ColorScale(0)=(Color=(B=96,G=96,R=96,A=255))
        ColorScale(1)=(RelativeTime=1.0,Color=(B=121,G=121,R=121,A=255))
        Opacity=0.5
        FadeOutStartTime=1.02
        FadeInEndTime=0.21
        StartLocationRange=(X=(Min=-10.0,Max=10.0),Y=(Min=-10.0,Max=10.0))
        AddLocationFromOtherEmitter=3
        SpinCCWorCW=(X=1.0)
        SpinsPerSecondRange=(X=(Min=-0.1,Max=0.1))
        StartSpinRange=(X=(Min=-0.5,Max=0.5))
        SizeScale(0)=(RelativeSize=2.0)
        SizeScale(1)=(RelativeTime=0.5,RelativeSize=4.0)
        SizeScale(2)=(RelativeTime=1.0,RelativeSize=6.0)
        StartSizeRange=(X=(Min=20.0),Y=(Min=20.0),Z=(Min=45.0,Max=50.0))
        InitialParticlesPerSecond=20.0
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.explosions.DSmoke_1'
        SecondsBeforeInactive=0.0
        LifetimeRange=(Min=7.0,Max=8.0)
        InitialDelayRange=(Min=0.2,Max=0.2)
        StartVelocityRange=(X=(Min=-50.0,Max=50.0),Y=(Min=-50.0,Max=50.0),Z=(Min=10.0,Max=10.0))
        VelocityLossRange=(Z=(Min=3.0,Max=3.0))
    End Object
    Emitters(4)=SpriteEmitter'SpriteEmitter4'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter5
        UseColorScale=true
        FadeOut=true
        FadeIn=true
        RespawnDeadParticles=false
        AlphaTest=false
        SpinParticles=true
        UseSizeScale=true
        UseRegularSizeScale=false
        UniformSize=true
        AutomaticInitialSpawning=false
        ColorScale(0)=(Color=(B=53,G=66,R=74,A=255))
        ColorScale(1)=(RelativeTime=1.0,Color=(B=53,G=66,R=74,A=255))
        FadeOutStartTime=0.3
        FadeInEndTime=0.105
        MaxParticles=1
        StartLocationOffset=(Z=64.0)
        StartSpinRange=(X=(Min=0.5,Max=0.5))
        SizeScale(1)=(RelativeTime=1.0,RelativeSize=8.0)
        StartSizeRange=(X=(Min=64.0,Max=64.0),Y=(Min=64.0,Max=64.0),Z=(Min=0.0,Max=0.0))
        InitialParticlesPerSecond=30.0
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.explosions.artilleryblast_1frame'
        LifetimeRange=(Min=1.0,Max=1.25)
        StartVelocityRange=(Z=(Min=386.0,Max=386.0))
        VelocityLossRange=(Z=(Min=0.5,Max=0.5))
    End Object
    Emitters(5)=SpriteEmitter'SpriteEmitter5'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter6
        FadeOut=true
        RespawnDeadParticles=false
        SpinParticles=true
        UseSizeScale=true
        UseRegularSizeScale=false
        UniformSize=true
        AutomaticInitialSpawning=false
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.0,Color=(B=255,G=255,R=255,A=255))
        FadeOutStartTime=0.13
        MaxParticles=2
        StartLocationOffset=(Z=32.0)
        StartSpinRange=(X=(Min=0.5,Max=0.5))
        SizeScale(0)=(RelativeSize=1.0)
        SizeScale(1)=(RelativeTime=1.0,RelativeSize=16.0)
        StartSizeRange=(X=(Min=48.0,Max=48.0),Y=(Min=48.0,Max=48.0),Z=(Min=48.0,Max=48.0))
        InitialParticlesPerSecond=100.0
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.explosions.explosion_1frame'
        LifetimeRange=(Min=1.0,Max=1.5)
        StartVelocityRange=(Z=(Min=120.0,Max=120.0))
    End Object
    Emitters(6)=SpriteEmitter'SpriteEmitter6'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter7
        ProjectionNormal=(Y=1.0)
        UseColorScale=true
        FadeOut=true
        RespawnDeadParticles=false
        SpinParticles=true
        UseSizeScale=true
        UseRegularSizeScale=false
        UniformSize=true
        AutomaticInitialSpawning=false
        Acceleration=(X=-10.0,Y=-10.0,Z=-1000.0)
        ColorScale(0)=(Color=(B=61,G=82,R=84,A=255))
        ColorScale(1)=(RelativeTime=1.0,Color=(B=96,G=111,R=115,A=255))
        MaxParticles=8
        SpinCCWorCW=(X=0.17)
        SpinsPerSecondRange=(X=(Min=0.125,Max=0.25))
        SizeScale(0)=(RelativeTime=1.0,RelativeSize=32.0)
        StartSizeRange=(X=(Min=5.0,Max=10.0),Y=(Min=5.0,Max=10.0),Z=(Min=5.0,Max=10.0))
        InitialParticlesPerSecond=100.0
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.explosions.exp_dirt'
        LifetimeRange=(Max=5.0)
        StartVelocityRange=(X=(Min=-200.0,Max=200.0),Y=(Min=-200.0,Max=200.0),Z=(Max=768.0))
    End Object
    Emitters(7)=SpriteEmitter'SpriteEmitter7'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter8
        UseColorScale=true
        FadeOut=true
        RespawnDeadParticles=false
        SpinParticles=true
        UseSizeScale=true
        UseRegularSizeScale=false
        UniformSize=true
        AutomaticInitialSpawning=false
        ColorScale(0)=(Color=(B=104,G=123,R=132,A=255))
        ColorScale(1)=(RelativeTime=1.0,Color=(B=176,G=182,R=181,A=255))
        FadeOutStartTime=1.14
        MaxParticles=16
        StartLocationOffset=(Z=32.0)
        StartLocationRange=(X=(Min=-25.0,Max=25.0),Y=(Min=-25.0,Max=25.0))
        StartLocationShape=PTLS_Sphere
        SpinsPerSecondRange=(X=(Min=0.05,Max=0.1))
        StartSpinRange=(X=(Min=-0.5,Max=0.5))
        SizeScale(0)=(RelativeTime=1.0,RelativeSize=7.0)
        StartSizeRange=(X=(Min=25.0),Y=(Min=25.0),Z=(Min=20.0,Max=20.0))
        InitialParticlesPerSecond=100.0
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.explosions.DSmoke_2'
        SecondsBeforeInactive=0.0
        LifetimeRange=(Min=3.0,Max=3.0)
        StartVelocityRange=(X=(Min=-1331.407959,Max=1331.407959),Y=(Min=-1331.407959,Max=1331.407959))
        VelocityLossRange=(X=(Min=3.0,Max=3.0),Y=(Min=3.0,Max=3.0))
    End Object
    Emitters(8)=SpriteEmitter'SpriteEmitter8'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter9
        UseDirectionAs=PTDU_Normal
        ProjectionNormal=(Y=1.0)
        UseColorScale=true
        FadeOut=true
        RespawnDeadParticles=false
        SpinParticles=true
        UseSizeScale=true
        UseRegularSizeScale=false
        UniformSize=true
        AutomaticInitialSpawning=false
        Acceleration=(X=-10.0,Y=-10.0,Z=-512.0)
        ColorScale(0)=(Color=(B=61,G=82,R=84,A=255))
        ColorScale(1)=(RelativeTime=1.0,Color=(B=96,G=111,R=115,A=255))
        MaxParticles=16
        SpinsPerSecondRange=(X=(Min=0.125,Max=0.25))
        SizeScale(0)=(RelativeTime=1.0,RelativeSize=32.0)
        StartSizeRange=(X=(Min=5.0,Max=10.0),Y=(Min=5.0,Max=10.0),Z=(Min=5.0,Max=10.0))
        InitialParticlesPerSecond=128.0
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.explosions.exp_dirt'
        LifetimeRange=(Min=1.96,Max=2.28)
        StartVelocityRange=(X=(Min=-200.0,Max=200.0),Y=(Min=-200.0,Max=200.0),Z=(Max=1024.0))
    End Object
    Emitters(9)=SpriteEmitter'SpriteEmitter9'
}

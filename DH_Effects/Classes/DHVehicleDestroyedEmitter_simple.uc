//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHVehicleDestroyedEmitter_simple extends Emitter;

defaultproperties
{
    AutoDestroy=true
    bNoDelete=false
    LifeSpan=8.0
    Style=STY_Masked
    bHardAttach=true

    Begin Object Class=SpriteEmitter Name=SpriteEmitter0
        FadeOut=true
        FadeIn=true
        RespawnDeadParticles=false
        SpinParticles=true
        UseSizeScale=true
        UseRegularSizeScale=false
        UniformSize=true
        AutomaticInitialSpawning=false
        Acceleration=(X=100.0,Z=100.0)
        ColorScale(0)=(Color=(B=47,G=100,R=149,A=255))
        ColorScale(1)=(RelativeTime=0.271429,Color=(A=255))
        ColorScale(2)=(RelativeTime=1.0,Color=(B=128,G=128,R=128,A=255))
        ColorScale(3)=(RelativeTime=1.0,Color=(A=255))
        ColorScale(4)=(RelativeTime=1.0,Color=(A=255))
        FadeOutStartTime=4.0
        FadeInEndTime=0.32
        MaxParticles=100
        StartLocationOffset=(Z=150.0)
        StartLocationRange=(X=(Min=20.0,Max=20.0),Y=(Min=20.0,Max=20.0))
        SpinsPerSecondRange=(X=(Min=0.05,Max=0.1))
        StartSpinRange=(X=(Min=-0.5,Max=0.5))
        SizeScale(0)=(RelativeSize=1.5)
        SizeScale(1)=(RelativeTime=1.0,RelativeSize=4.4)
        StartSizeRange=(X=(Min=75.0),Y=(Min=75.0),Z=(Min=75.0))
        ParticlesPerSecond=2.0
        InitialParticlesPerSecond=2.0
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.explosions.DSmoke_1'
        LifetimeRange=(Min=6.0,Max=8.0)
        StartVelocityRange=(X=(Min=-100.0,Max=100.0),Y=(Min=-100.0,Max=100.0),Z=(Min=25.0,Max=150.0))
        VelocityLossRange=(X=(Min=0.25,Max=1.0),Y=(Min=0.25,Max=1.0),Z=(Min=0.25,Max=1.0))
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
        BlendBetweenSubdivisions=true
        UseRandomSubdivision=true
        UseVelocityScale=true
        Acceleration=(Z=150.0)
        ColorScale(0)=(Color=(B=255,G=255,R=255))
        ColorScale(1)=(RelativeTime=0.25,Color=(B=100,G=177,R=230,A=255))
        ColorScale(2)=(RelativeTime=0.75,Color=(B=5,R=230,A=255))
        ColorScale(3)=(RelativeTime=1.0,Color=(B=255,G=255,R=255,A=255))
        FadeOutStartTime=0.6
        UseRotationFrom=PTRS_Actor
        StartSpinRange=(X=(Min=0.5,Max=0.5))
        SizeScale(0)=(RelativeSize=0.5)
        SizeScale(1)=(RelativeTime=1.0,RelativeSize=1.5)
        StartSizeRange=(X=(Min=150.0,Max=200.0))
        ParticlesPerSecond=5.0
        InitialParticlesPerSecond=5.0
        DrawStyle=PTDS_Brighten
        Texture=Texture'Effects_Tex.explosions.fire_16frame'
        TextureUSubdivisions=4
        TextureVSubdivisions=4
        LifetimeRange=(Min=1.0,Max=1.0)
        InitialDelayRange=(Min=0.5,Max=0.5)
        StartVelocityRange=(X=(Min=-20.0,Max=20.0),Y=(Min=-20.0,Max=20.0))
        VelocityScale(0)=(RelativeTime=0.1,RelativeVelocity=(X=0.1,Y=0.1,Z=0.1))
        VelocityScale(1)=(RelativeTime=0.5,RelativeVelocity=(X=1.0,Y=1.0,Z=1.0))
        VelocityScale(2)=(RelativeTime=1.0)
    End Object
    Emitters(1)=SpriteEmitter'SpriteEmitter1'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter2
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
        ColorScale(0)=(Color=(B=82,G=82,R=82,A=255))
        ColorScale(1)=(RelativeTime=0.5,Color=(B=128,G=128,R=128,A=255))
        ColorScale(2)=(RelativeTime=1.0,Color=(B=255,G=255,R=255,A=255))
        Opacity=0.75
        FadeOutStartTime=0.5
        FadeInEndTime=0.2
        MaxParticles=2
        StartLocationRange=(X=(Min=-10.0,Max=10.0),Y=(Min=-10.0,Max=10.0),Z=(Max=300.0))
        SpinsPerSecondRange=(X=(Min=0.05,Max=0.1))
        StartSpinRange=(X=(Min=-0.5,Max=0.5))
        SizeScale(0)=(RelativeSize=2.0)
        SizeScale(1)=(RelativeTime=0.14,RelativeSize=6.0)
        SizeScale(2)=(RelativeTime=1.0,RelativeSize=14.0)
        StartSizeRange=(X=(Min=30.0,Max=60.0),Y=(Min=30.0,Max=60.0),Z=(Min=45.0,Max=50.0))
        InitialParticlesPerSecond=500.0
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.explosions.LSmoke3'
        SecondsBeforeInactive=0.0
        LifetimeRange=(Min=2.0)
        StartVelocityRange=(X=(Min=-100.0,Max=100.0),Y=(Min=-100.0,Max=100.0),Z=(Min=50.0,Max=50.0))
        VelocityLossRange=(X=(Min=1.0,Max=1.0),Y=(Min=1.0,Max=1.0),Z=(Min=3.0,Max=3.0))
    End Object
    Emitters(2)=SpriteEmitter'SpriteEmitter2'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter3
        UseColorScale=true
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
        Acceleration=(X=100.0,Y=100.0)
        ColorScale(0)=(Color=(B=35,G=35,R=35,A=255))
        ColorScale(1)=(RelativeTime=1.0,Color=(B=128,G=128,R=128,A=255))
        FadeOutStartTime=1.02
        FadeInEndTime=0.51
        MaxParticles=5
        StartLocationOffset=(Z=150.0)
        StartLocationRange=(X=(Min=-10.0,Max=10.0),Y=(Min=-10.0,Max=10.0))
        SpinsPerSecondRange=(X=(Min=0.05,Max=0.1))
        StartSpinRange=(X=(Min=-0.5,Max=0.5))
        SizeScale(0)=(RelativeSize=2.0)
        SizeScale(1)=(RelativeTime=1.0,RelativeSize=8.0)
        StartSizeRange=(X=(Max=120.0),Y=(Max=120.0),Z=(Min=45.0,Max=50.0))
        InitialParticlesPerSecond=500.0
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.explosions.DSmoke_2'
        SecondsBeforeInactive=0.0
        LifetimeRange=(Min=2.0,Max=3.0)
        StartVelocityRange=(X=(Min=-300.0,Max=300.0),Y=(Min=-300.0,Max=300.0),Z=(Min=1000.0,Max=1500.0))
        VelocityLossRange=(X=(Min=1.0,Max=1.0),Y=(Min=1.0,Max=1.0),Z=(Min=1.0,Max=1.0))
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
        BlendBetweenSubdivisions=true
        Acceleration=(Z=50.0)
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.0,Color=(B=255,G=255,R=255,A=255))
        FadeOutStartTime=0.2
        FadeInEndTime=0.05
        MaxParticles=1
        StartLocationOffset=(Z=250.0)
        SpinCCWorCW=(X=0.0)
        StartSpinRange=(X=(Min=-0.5,Max=0.5))
        SizeScale(1)=(RelativeTime=0.14,RelativeSize=1.0)
        SizeScale(2)=(RelativeTime=1.0,RelativeSize=1.5)
        StartSizeRange=(X=(Min=200.0,Max=200.0),Y=(Min=200.0,Max=200.0),Z=(Min=200.0,Max=200.0))
        InitialParticlesPerSecond=30.0
        DrawStyle=PTDS_Brighten
        Texture=Texture'Effects_Tex.explosions.impact_2frame'
        TextureUSubdivisions=2
        TextureVSubdivisions=1
        LifetimeRange=(Min=0.5,Max=0.5)
        InitialDelayRange=(Min=0.1,Max=0.1)
        StartVelocityRange=(Z=(Min=10.0,Max=10.0))
    End Object
    Emitters(4)=SpriteEmitter'SpriteEmitter4'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter5
        FadeOut=true
        RespawnDeadParticles=false
        SpinParticles=true
        UseSizeScale=true
        UseRegularSizeScale=false
        UniformSize=true
        AutomaticInitialSpawning=false
        ColorScale(0)=(Color=(A=255))
        ColorScale(1)=(RelativeTime=1.0,Color=(B=255,G=255,R=255,A=255))
        FadeOutStartTime=0.5
        MaxParticles=1
        StartLocationOffset=(Z=75.0)
        StartSpinRange=(X=(Min=0.5,Max=0.5))
        SizeScale(0)=(RelativeSize=2.0)
        SizeScale(1)=(RelativeTime=1.0,RelativeSize=6.0)
        StartSizeRange=(X=(Min=125.0,Max=125.0),Y=(Min=125.0,Max=125.0),Z=(Min=125.0,Max=125.0))
        InitialParticlesPerSecond=18.0
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.explosions.explosion_1frame'
        LifetimeRange=(Min=0.9,Max=1.15)
        StartVelocityRange=(Z=(Min=400.0,Max=500.0))
    End Object
    Emitters(5)=SpriteEmitter'SpriteEmitter5'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter6
        FadeOut=true
        FadeIn=true
        RespawnDeadParticles=false
        UseSizeScale=true
        UseRegularSizeScale=false
        UniformSize=true
        AutomaticInitialSpawning=false
        BlendBetweenSubdivisions=true
        Acceleration=(Z=50.0)
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.0,Color=(B=255,G=255,R=255,A=255))
        FadeOutStartTime=0.2
        FadeInEndTime=0.05
        MaxParticles=1
        StartLocationOffset=(Z=50.0)
        SizeScale(1)=(RelativeTime=0.14,RelativeSize=1.0)
        SizeScale(2)=(RelativeTime=1.0,RelativeSize=1.5)
        StartSizeRange=(X=(Min=250.0,Max=250.0),Y=(Min=250.0,Max=250.0),Z=(Min=250.0,Max=250.0))
        InitialParticlesPerSecond=30.0
        DrawStyle=PTDS_Brighten
        Texture=Texture'Effects_Tex.explosions.impact_2frame'
        TextureUSubdivisions=2
        TextureVSubdivisions=1
        LifetimeRange=(Min=0.75,Max=0.75)
        StartVelocityRange=(Z=(Min=10.0,Max=10.0))
    End Object
    Emitters(6)=SpriteEmitter'SpriteEmitter6'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter7
        ProjectionNormal=(X=200.0,Y=200.0)
        UseColorScale=true
        FadeOut=true
        RespawnDeadParticles=false
        SpinParticles=true
        UseSizeScale=true
        UseRegularSizeScale=false
        UniformSize=true
        AutomaticInitialSpawning=false
        UseVelocityScale=true
        Acceleration=(Z=5.0)
        ColorScale(0)=(Color=(A=255))
        ColorScale(1)=(RelativeTime=1.0,Color=(B=192,G=192,R=192))
        FadeOutStartTime=3.48
        MaxParticles=5
        UseRotationFrom=PTRS_Offset
        SpinsPerSecondRange=(X=(Min=-0.1,Max=0.1))
        StartSpinRange=(X=(Min=-0.5,Max=0.5),Y=(Min=0.5,Max=1.0),Z=(Min=0.5,Max=1.0))
        SizeScale(0)=(RelativeSize=5.0)
        SizeScale(1)=(RelativeTime=0.5,RelativeSize=10.0)
        SizeScale(2)=(RelativeTime=1.0,RelativeSize=40.0)
        StartSizeRange=(X=(Min=10.0,Max=20.0),Y=(Min=10.0,Max=20.0),Z=(Min=10.0,Max=20.0))
        InitialParticlesPerSecond=1000.0
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.explosions.DSmoke_2'
        LifetimeRange=(Max=6.0)
        StartVelocityRange=(X=(Min=-1000.0,Max=1000.0),Y=(Min=-1000.0,Max=1000.0))
        VelocityLossRange=(X=(Min=1.0,Max=1.0),Y=(Min=1.0,Max=1.0),Z=(Min=1.0,Max=1.0))
        VelocityScale(0)=(RelativeVelocity=(X=1.0,Y=1.0,Z=1.0))
        VelocityScale(1)=(RelativeTime=0.1,RelativeVelocity=(X=0.2,Y=0.2,Z=1.0))
        VelocityScale(2)=(RelativeTime=1.0)
    End Object
    Emitters(7)=SpriteEmitter'SpriteEmitter7'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter8
        UseColorScale=true
        RespawnDeadParticles=false
        UseRevolution=true
        SpinParticles=true
        UseSizeScale=true
        UseRegularSizeScale=false
        UniformSize=true
        AutomaticInitialSpawning=false
        Acceleration=(Z=-1200.0)
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.0,Color=(B=255,G=255,R=255,A=255))
        Opacity=0.65
        MaxParticles=6
        SpinsPerSecondRange=(X=(Min=-1.0,Max=1.0))
        StartSpinRange=(X=(Min=-0.5,Max=0.5))
        SizeScale(0)=(RelativeTime=1.0,RelativeSize=7.0)
        StartSizeRange=(X=(Min=2.0,Max=6.0),Y=(Min=2.0,Max=6.0),Z=(Min=3.0,Max=5.0))
        InitialParticlesPerSecond=50.0
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.explosions.shrapnel3'
        StartVelocityRange=(X=(Min=-500.0,Max=500.0),Y=(Min=-500.0,Max=500.0),Z=(Min=500.0,Max=1000.0))
    End Object
    Emitters(8)=SpriteEmitter'SpriteEmitter8'
}

//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHMortarExplosion60mm extends Emitter;

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
        MaxParticles=12
        StartLocationRange=(X=(Min=-10.0,Max=10.0),Y=(Min=-10.0,Max=10.0))
        SpinCCWorCW=(X=1.0)
        SpinsPerSecondRange=(X=(Min=-0.1,Max=0.1))
        StartSpinRange=(X=(Min=-0.5,Max=0.5))
        SizeScale(0)=(RelativeSize=1.0)
        SizeScale(1)=(RelativeTime=0.14,RelativeSize=3.0)
        SizeScale(2)=(RelativeTime=1.0,RelativeSize=7.0)
        StartSizeRange=(X=(Min=25.0,Max=35.0),Y=(Min=25.0,Max=35.0),Z=(Min=45.0,Max=50.0))
        InitialParticlesPerSecond=512.0
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.explosions.LSmoke3'
        SecondsBeforeInactive=0.0
        LifetimeRange=(Min=2.0)
        StartVelocityRange=(X=(Min=-96.0,Max=96.0),Y=(Min=-96.0,Max=96.0),Z=(Min=100.0,Max=100.0))
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
        Acceleration=(Y=50.0,Z=50.0)
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.0,Color=(B=255,G=255,R=255,A=255))
        MaxParticles=16
        StartLocationRange=(X=(Min=-10.0,Max=10.0),Y=(Min=-10.0,Max=10.0))
        SpinCCWorCW=(X=1.0)
        SpinsPerSecondRange=(X=(Min=-0.1,Max=0.1))
        StartSpinRange=(X=(Min=-0.5,Max=0.5))
        SizeScale(0)=(RelativeSize=1.0)
        SizeScale(1)=(RelativeTime=0.5,RelativeSize=3.0)
        SizeScale(2)=(RelativeTime=1.0,RelativeSize=4.0)
        StartSizeRange=(X=(Min=25.0,Max=35.0),Y=(Min=25.0,Max=35.0),Z=(Min=45.0,Max=50.0))
        InitialParticlesPerSecond=100.0
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.explosions.DSmoke_2'
        SecondsBeforeInactive=0.0
        LifetimeRange=(Min=2.0)
        StartVelocityRange=(X=(Min=-32.0,Max=32.0),Y=(Min=-32.0,Max=32.0),Z=(Min=1.0,Max=1536.0))
        VelocityLossRange=(Z=(Min=3.0,Max=3.0))
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
        Acceleration=(Y=50.0,Z=50.0)
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.0,Color=(B=255,G=255,R=255,A=255))
        FadeOutStartTime=1.02
        FadeInEndTime=0.21
        MaxParticles=8
        StartLocationRange=(X=(Min=-10.0,Max=10.0),Y=(Min=-10.0,Max=10.0))
        AddLocationFromOtherEmitter=1
        SpinCCWorCW=(X=1.0)
        SpinsPerSecondRange=(X=(Min=-0.1,Max=0.1))
        StartSpinRange=(X=(Min=-0.5,Max=0.5))
        SizeScale(0)=(RelativeSize=1.0)
        SizeScale(1)=(RelativeTime=0.5,RelativeSize=2.0)
        SizeScale(2)=(RelativeTime=1.0,RelativeSize=3.0)
        StartSizeRange=(X=(Min=25.0,Max=35.0),Y=(Min=25.0,Max=35.0),Z=(Min=45.0,Max=50.0))
        InitialParticlesPerSecond=20.0
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.explosions.DSmoke_1'
        SecondsBeforeInactive=0.0
        LifetimeRange=(Min=2.0,Max=3.0)
        StartVelocityRange=(X=(Min=-50.0,Max=50.0),Y=(Min=-50.0,Max=50.0),Z=(Min=10.0,Max=10.0))
        VelocityLossRange=(Z=(Min=3.0,Max=3.0))
    End Object
    Emitters(2)=SpriteEmitter'SpriteEmitter2'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter3
        FadeOut=true
        RespawnDeadParticles=false
        SpinParticles=true
        UseSizeScale=true
        UseRegularSizeScale=false
        UniformSize=true
        AutomaticInitialSpawning=false
        Acceleration=(Z=-75.0)
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.0,Color=(B=255,G=255,R=255,A=255))
        FadeOutStartTime=0.13
        MaxParticles=2
        StartSpinRange=(X=(Min=0.5,Max=0.5))
        SizeScale(0)=(RelativeSize=0.5)
        SizeScale(1)=(RelativeTime=1.0,RelativeSize=4.5)
        StartSizeRange=(X=(Min=64.0,Max=64.0),Y=(Min=64.0,Max=64.0),Z=(Min=64.0,Max=64.0))
        InitialParticlesPerSecond=100.0
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.explosions.explosion_1frame'
        LifetimeRange=(Min=0.4,Max=0.5)
        StartVelocityRange=(Z=(Min=300.0,Max=300.0))
    End Object
    Emitters(3)=SpriteEmitter'SpriteEmitter3'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter4
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
        FadeOutStartTime=0.1025
        FadeInEndTime=0.05
        MaxParticles=1
        SizeScale(1)=(RelativeTime=0.14,RelativeSize=1.0)
        SizeScale(2)=(RelativeTime=1.0,RelativeSize=1.5)
        StartSizeRange=(X=(Min=50.0,Max=50.0),Y=(Min=50.0,Max=50.0),Z=(Min=50.0,Max=50.0))
        InitialParticlesPerSecond=30.0
        DrawStyle=PTDS_Brighten
        Texture=Texture'Effects_Tex.explosions.impact_2frame'
        TextureUSubdivisions=2
        TextureVSubdivisions=1
        LifetimeRange=(Min=0.25,Max=0.25)
        StartVelocityRange=(Z=(Min=10.0,Max=10.0))
    End Object
    Emitters(4)=SpriteEmitter'SpriteEmitter4'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter5
        RespawnDeadParticles=false
        UseRevolution=true
        SpinParticles=true
        UseSizeScale=true
        UseRegularSizeScale=false
        UniformSize=true
        AutomaticInitialSpawning=false
        Acceleration=(Z=-600.0)
        ColorScale(0)=(Color=(B=25,G=25,R=25,A=255))
        ColorScale(1)=(RelativeTime=1.0,Color=(B=82,G=84,R=95,A=255))
        MaxParticles=32
        SpinsPerSecondRange=(X=(Min=-1.0,Max=1.0))
        StartSpinRange=(X=(Min=-0.5,Max=0.5))
        SizeScale(0)=(RelativeTime=1.0,RelativeSize=5.0)
        StartSizeRange=(X=(Min=0.5,Max=1.5),Y=(Min=0.5,Max=1.5),Z=(Min=3.0,Max=5.0))
        InitialParticlesPerSecond=500.0
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.explosions.shrapnel1'
        StartVelocityRange=(X=(Min=-345.0,Max=450.0),Y=(Min=-345.0,Max=450.0),Z=(Min=350.0,Max=500.0))
    End Object
    Emitters(5)=SpriteEmitter'SpriteEmitter5'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter6
        UseColorScale=true
        FadeOut=true
        RespawnDeadParticles=false
        UseRevolution=true
        UseSizeScale=true
        UseRegularSizeScale=false
        UniformSize=true
        AutomaticInitialSpawning=false
        Acceleration=(Z=-1200.0)
        DampingFactorRange=(X=(Min=0.2,Max=0.2),Y=(Min=0.2,Max=0.2),Z=(Min=0.2,Max=0.2))
        ColorScale(0)=(Color=(B=25,G=25,R=25,A=255))
        ColorScale(1)=(RelativeTime=1.0,Color=(B=82,G=84,R=95,A=255))
        FadeOutStartTime=1.4
        MaxParticles=16
        SizeScale(0)=(RelativeTime=1.0,RelativeSize=5.0)
        StartSizeRange=(X=(Min=0.5,Max=2.0),Y=(Min=0.5,Max=2.0),Z=(Min=3.0,Max=5.0))
        InitialParticlesPerSecond=500.0
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.BulletHits.dirtchunks'
        TextureUSubdivisions=2
        TextureVSubdivisions=2
        LifetimeRange=(Min=2.0,Max=2.0)
        StartVelocityRange=(X=(Min=-100.0,Max=100.0),Y=(Min=-100.0,Max=100.0),Z=(Min=800.0,Max=1000.0))
    End Object
    Emitters(6)=SpriteEmitter'SpriteEmitter6'
}

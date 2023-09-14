//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHShellExplosion_MediumHE extends Emitter;

defaultproperties
{
    bNoDelete=false
    LifeSpan=16.0
    Style=STY_Masked

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
        Opacity=0.75
        FadeOutStartTime=0.5
        FadeInEndTime=0.2
        MaxParticles=5
        StartLocationRange=(X=(Min=-10.0,Max=10.0),Y=(Min=-10.0,Max=10.0),Z=(Max=300.0))
        SpinsPerSecondRange=(X=(Min=0.1,Max=0.1))
        StartSpinRange=(X=(Min=-0.5,Max=0.5))
        SizeScale(0)=(RelativeSize=2.0)
        SizeScale(1)=(RelativeTime=0.14,RelativeSize=6.0)
        SizeScale(2)=(RelativeTime=1.0,RelativeSize=14.0)
        StartSizeRange=(X=(Min=30.0,Max=60.0),Y=(Min=30.0,Max=60.0),Z=(Min=45.0,Max=50.0))
        InitialParticlesPerSecond=50.0
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.explosions.LSmoke3'
        SecondsBeforeInactive=0.0
        LifetimeRange=(Min=3.0,Max=5.0)
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
        Acceleration=(Z=-100.0)
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.0,Color=(B=255,G=255,R=255,A=255))
        Opacity=0.75
        FadeOutStartTime=1.02
        FadeInEndTime=0.51
        MaxParticles=5
        StartLocationOffset=(Z=150.0)
        StartLocationRange=(X=(Min=-10.0,Max=10.0),Y=(Min=-10.0,Max=10.0))
        SpinsPerSecondRange=(X=(Min=0.1,Max=0.1))
        StartSpinRange=(X=(Min=-0.5,Max=0.5))
        SizeScale(0)=(RelativeSize=2.0)
        SizeScale(1)=(RelativeTime=0.5,RelativeSize=4.0)
        SizeScale(2)=(RelativeTime=1.0,RelativeSize=8.0)
        StartSizeRange=(X=(Min=30.0,Max=50.0),Y=(Min=30.0,Max=50.0),Z=(Min=45.0,Max=50.0))
        InitialParticlesPerSecond=15.0
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.explosions.LSmoke3'
        SecondsBeforeInactive=0.0
        LifetimeRange=(Min=2.0,Max=3.0)
        StartVelocityRange=(X=(Min=-100.0,Max=100.0),Y=(Min=-100.0,Max=100.0),Z=(Min=250.0,Max=750.0))
        VelocityLossRange=(Z=(Min=1.0,Max=1.0))
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
        Acceleration=(X=200.0,Y=200.0,Z=50.0)
        ColorScale(0)=(Color=(B=107,G=107,R=107,A=255))
        ColorScale(1)=(RelativeTime=1.0,Color=(B=255,G=255,R=255,A=255))
        Opacity=0.5
        StartLocationRange=(X=(Min=-10.0,Max=10.0),Y=(Min=-10.0,Max=10.0))
        SpinsPerSecondRange=(X=(Max=0.2))
        StartSpinRange=(X=(Min=-0.5,Max=0.5))
        SizeScale(0)=(RelativeSize=2.0)
        SizeScale(1)=(RelativeTime=0.5,RelativeSize=4.0)
        SizeScale(2)=(RelativeTime=1.0,RelativeSize=6.0)
        StartSizeRange=(X=(Min=25.0,Max=35.0),Y=(Min=25.0,Max=35.0),Z=(Min=45.0,Max=50.0))
        InitialParticlesPerSecond=100.0
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.explosions.DSmoke_2'
        SecondsBeforeInactive=0.0
        LifetimeRange=(Min=2.0)
        StartVelocityRange=(X=(Min=-100.0,Max=100.0),Y=(Min=-100.0,Max=100.0),Z=(Min=500.0,Max=1000.0))
        VelocityLossRange=(Z=(Min=1.0,Max=1.0))
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
        Acceleration=(X=50.0,Y=50.0,Z=50.0)
        ColorScale(0)=(Color=(A=255))
        ColorScale(1)=(RelativeTime=1.0,Color=(A=255))
        ColorScale(2)=(RelativeTime=1.0,Color=(B=128,G=128,R=128,A=255))
        Opacity=0.5
        FadeOutStartTime=1.02
        FadeInEndTime=0.21
        MaxParticles=50
        StartLocationRange=(X=(Min=-10.0,Max=10.0),Y=(Min=-10.0,Max=10.0))
        AddLocationFromOtherEmitter=4
        SpinsPerSecondRange=(X=(Min=0.1,Max=0.15))
        StartSpinRange=(X=(Min=-0.5,Max=0.5))
        SizeScale(0)=(RelativeSize=2.0)
        SizeScale(1)=(RelativeTime=0.5,RelativeSize=5.0)
        SizeScale(2)=(RelativeTime=1.0,RelativeSize=10.0)
        StartSizeRange=(X=(Min=5.0,Max=10.0),Y=(Min=5.0,Max=10.0),Z=(Min=5.0,Max=10.0))
        InitialParticlesPerSecond=300.0
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.explosions.DSmoke_2'
        SecondsBeforeInactive=0.0
        LifetimeRange=(Min=2.0,Max=3.0)
        InitialDelayRange=(Min=0.5,Max=0.5)
        StartVelocityRange=(X=(Min=-50.0,Max=50.0),Y=(Min=-50.0,Max=50.0),Z=(Min=10.0,Max=10.0))
        VelocityLossRange=(Z=(Min=3.0,Max=3.0))
    End Object
    Emitters(3)=SpriteEmitter'SpriteEmitter3'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter4
        FadeOut=true
        RespawnDeadParticles=false
        UseRevolution=true
        SpinParticles=true
        UseSizeScale=true
        UseRegularSizeScale=false
        UniformSize=true
        AutomaticInitialSpawning=false
        UseRandomSubdivision=true
        Acceleration=(Z=-1000.0)
        DampingFactorRange=(X=(Min=0.2,Max=0.2),Y=(Min=0.2,Max=0.2),Z=(Min=0.2,Max=0.2))
        ColorScale(0)=(Color=(B=25,G=25,R=25,A=255))
        ColorScale(1)=(RelativeTime=1.0,Color=(B=82,G=84,R=95,A=255))
        FadeOutStartTime=1.4
        MaxParticles=5000
        SpinsPerSecondRange=(X=(Min=1.0,Max=2.0))
        StartSpinRange=(X=(Min=-0.5,Max=0.5))
        SizeScale(0)=(RelativeTime=1.0,RelativeSize=2.0)
        StartSizeRange=(X=(Min=2.0,Max=4.0),Y=(Min=2.0,Max=4.0),Z=(Min=2.0,Max=4.0))
        InitialParticlesPerSecond=10000.0
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.BulletHits.rock_chunks'
        TextureUSubdivisions=2
        TextureVSubdivisions=2
        LifetimeRange=(Min=0.5,Max=3.0)
        StartVelocityRange=(X=(Min=-2000.0,Max=2000.0),Y=(Min=-2000.0,Max=2000.0),Z=(Min=750.0,Max=1000.0))
    End Object
    Emitters(4)=SpriteEmitter'SpriteEmitter4'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter5
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
        FadeOutStartTime=0.048
        MaxParticles=3
        SizeScale(0)=(RelativeSize=2.0)
        SizeScale(1)=(RelativeTime=0.14,RelativeSize=4.0)
        SizeScale(2)=(RelativeTime=1.0,RelativeSize=6.0)
        InitialParticlesPerSecond=30.0
        DrawStyle=PTDS_Brighten
        Texture=Texture'Effects_Tex.explosions.impact_2frame'
        TextureUSubdivisions=2
        TextureVSubdivisions=1
        LifetimeRange=(Min=0.2,Max=0.2)
        StartVelocityRange=(Z=(Min=10.0,Max=10.0))
    End Object
    Emitters(5)=SpriteEmitter'SpriteEmitter5'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter6
        FadeOut=true
        FadeIn=true
        RespawnDeadParticles=false
        SpinParticles=true
        UseSizeScale=true
        UseRegularSizeScale=false
        UniformSize=true
        AutomaticInitialSpawning=false
        Acceleration=(Z=-75.0)
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.0,Color=(B=255,G=255,R=255,A=255))
        FadeOutStartTime=0.098
        FadeInEndTime=0.08
        MaxParticles=4
        StartSpinRange=(X=(Min=0.5,Max=0.5))
        SizeScale(0)=(RelativeSize=2.0)
        SizeScale(1)=(RelativeTime=1.0,RelativeSize=9.0)
        InitialParticlesPerSecond=100.0
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.explosions.explosion_1frame'
        LifetimeRange=(Min=0.5,Max=0.6)
        StartVelocityRange=(Z=(Min=1000.0,Max=1000.0))
    End Object
    Emitters(6)=SpriteEmitter'SpriteEmitter6'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter7
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
        FadeOutStartTime=0.018
        FadeInEndTime=0.008
        MaxParticles=1
        StartLocationOffset=(Z=200.0)
        SizeScale(0)=(RelativeSize=2.0)
        SizeScale(1)=(RelativeTime=0.14,RelativeSize=4.0)
        SizeScale(2)=(RelativeTime=1.0,RelativeSize=6.0)
        StartSizeRange=(X=(Min=75.0,Max=75.0),Y=(Min=75.0,Max=75.0),Z=(Min=75.0,Max=75.0))
        InitialParticlesPerSecond=30.0
        DrawStyle=PTDS_Brighten
        Texture=Texture'Effects_Tex.explosions.impact_2frame'
        TextureUSubdivisions=2
        TextureVSubdivisions=1
        LifetimeRange=(Min=0.2,Max=0.2)
        InitialDelayRange=(Min=0.05,Max=0.05)
        StartVelocityRange=(Z=(Min=10.0,Max=10.0))
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
        Acceleration=(X=50.0,Y=50.0,Z=0.5)
        ColorScale(0)=(Color=(B=104,G=123,R=132,A=255))
        ColorScale(1)=(RelativeTime=1.0,Color=(B=255,G=255,R=255,A=255))
        FadeOutStartTime=0.99
        MaxParticles=8
        StartLocationRange=(X=(Min=-25.0,Max=25.0),Y=(Min=-25.0,Max=25.0))
        StartLocationShape=PTLS_Sphere
        SpinsPerSecondRange=(X=(Min=0.05,Max=0.1))
        StartSpinRange=(X=(Min=-0.5,Max=0.5))
        SizeScale(0)=(RelativeTime=1.0,RelativeSize=10.0)
        StartSizeRange=(X=(Min=25.0),Y=(Min=25.0),Z=(Min=20.0,Max=20.0))
        InitialParticlesPerSecond=100.0
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.explosions.DSmoke_2'
        SecondsBeforeInactive=0.0
        LifetimeRange=(Min=3.0,Max=3.0)
        StartVelocityRange=(X=(Min=-1000.0,Max=1000.0),Y=(Min=-1000.0,Max=1000.0))
        VelocityLossRange=(X=(Min=3.0,Max=3.0),Y=(Min=3.0,Max=3.0))
    End Object
    Emitters(8)=SpriteEmitter'SpriteEmitter8'
}

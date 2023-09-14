//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHSmokeEffect_Shell extends DHSmokeEffectBase;

defaultproperties
{
    Begin Object Class=SpriteEmitter Name=SpriteEmitter0
        FadeOut=true
        FadeIn=true
        RespawnDeadParticles=false
        SpinParticles=true
        UseSizeScale=true
        UseRegularSizeScale=false
        UniformSize=true
        AutomaticInitialSpawning=false
        Acceleration=(X=10.0,Y=10.0)
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.0,Color=(B=255,G=255,R=255,A=255))
        Opacity=0.6
        FadeOutStartTime=2.56
        FadeInEndTime=0.48
        MaxParticles=30
        SpinsPerSecondRange=(X=(Min=0.05,Max=0.05))
        StartSpinRange=(X=(Min=-0.5,Max=0.5))
        SizeScale(1)=(RelativeTime=2.0,RelativeSize=6.0)
        StartSizeRange=(X=(Min=100.0,Max=100.0),Y=(Min=100.0,Max=100.0),Z=(Min=75.0,Max=75.0))
        InitialParticlesPerSecond=4.0
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.Smoke.grenadesmoke'
        LifetimeRange=(Min=3.0)
        StartVelocityRange=(X=(Min=-50.0,Max=50.0),Y=(Min=-50.0,Max=50.0),Z=(Min=15.0,Max=50.0))
        VelocityLossRange=(X=(Min=0.2,Max=0.2),Y=(Min=0.2,Max=0.2),Z=(Min=0.2,Max=0.2))
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
        Acceleration=(Z=-0.2)
        ColorScale(0)=(Color=(B=128,G=128,R=128,A=255))
        ColorScale(1)=(RelativeTime=1.0,Color=(B=255,G=255,R=255,A=255))
        Opacity=0.8
        FadeOutStartTime=40.0
        FadeInEndTime=5.5
        MaxParticles=2
        StartLocationRange=(X=(Min=-200.0,Max=200.0),Y=(Min=-200.0,Max=200.0),Z=(Min=200.0,Max=300.0))
        SpinsPerSecondRange=(X=(Min=0.003,Max=0.004))
        StartSpinRange=(X=(Min=0.05,Max=0.05))
        SizeScale(0)=(RelativeSize=0.5)
        SizeScale(1)=(RelativeTime=0.56,RelativeSize=1.5)
        SizeScale(2)=(RelativeTime=1.74,RelativeSize=2.0)
        StartSizeRange=(X=(Min=600.0,Max=800.0),Y=(Min=600.0,Max=800.0),Z=(Min=400.0,Max=500.0))
        InitialParticlesPerSecond=10.0
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.Smoke.grenadesmoke'
        LifetimeRange=(Min=45.0,Max=50.0)
        InitialDelayRange=(Min=2.0,Max=2.0)
        StartVelocityRange=(Z=(Min=2.0,Max=5.0))
        VelocityLossRange=(X=(Min=0.5,Max=0.5),Y=(Min=0.5,Max=0.5))
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
        Acceleration=(Z=-0.2)
        ColorScale(0)=(Color=(B=128,G=128,R=128,A=255))
        ColorScale(1)=(RelativeTime=1.0,Color=(B=255,G=255,R=255,A=255))
        Opacity=0.8
        FadeOutStartTime=50.400002
        FadeInEndTime=4.8
        StartLocationRange=(X=(Min=-350.0,Max=350.0),Y=(Min=-350.0,Max=350.0),Z=(Max=100.0))
        SpinsPerSecondRange=(X=(Min=0.003,Max=0.004))
        StartSpinRange=(X=(Min=-0.05,Max=0.05))
        SizeScale(0)=(RelativeSize=1.5)
        SizeScale(1)=(RelativeTime=1.0,RelativeSize=1.8)
        SizeScale(2)=(RelativeTime=1.74,RelativeSize=2.0)
        StartSizeRange=(X=(Min=600.0,Max=800.0),Y=(Min=600.0,Max=800.0),Z=(Min=400.0,Max=500.0))
        InitialParticlesPerSecond=10.0
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.Smoke.grenadesmoke'
        LifetimeRange=(Min=55.0,Max=60.0)
        InitialDelayRange=(Min=2.0,Max=2.0)
        StartVelocityRange=(Z=(Min=2.0,Max=5.0))
        VelocityLossRange=(X=(Min=0.5,Max=0.5),Y=(Min=0.5,Max=0.5))
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
        Acceleration=(X=1.0,Y=1.0)
        ColorScale(0)=(Color=(B=128,G=128,R=128,A=255))
        ColorScale(1)=(RelativeTime=1.0,Color=(B=128,G=128,R=128,A=255))
        Opacity=0.9
        FadeOutStartTime=6.0
        FadeInEndTime=2.0
        MaxParticles=70
        StartLocationRange=(X=(Min=-300.0,Max=300.0),Y=(Min=-300.0,Max=300.0),Z=(Min=25.0,Max=25.0))
        SpinsPerSecondRange=(X=(Min=0.025,Max=0.05))
        StartSpinRange=(X=(Min=-0.5,Max=0.5))
        SizeScale(0)=(RelativeTime=2.0,RelativeSize=6.0)
        StartSizeRange=(X=(Min=100.0,Max=100.0),Y=(Min=100.0,Max=100.0),Z=(Min=75.0,Max=100.0))
        InitialParticlesPerSecond=1.5
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.Smoke.grenadesmoke_fill'
        SecondsBeforeInactive=0.0
        LifetimeRange=(Min=8.0,Max=9.0)
        InitialDelayRange=(Min=0.75,Max=0.75)
        StartVelocityRange=(X=(Min=-50.0,Max=50.0),Y=(Min=-50.0,Max=50.0))
        VelocityLossRange=(X=(Min=0.15,Max=0.15),Y=(Min=0.15,Max=0.15),Z=(Min=0.1,Max=0.1))
    End Object
    Emitters(3)=SpriteEmitter'SpriteEmitter3'
}

//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHBulletPenetrateArmorEffect extends Emitter;

defaultproperties
{
    bLightChanged=true
    AutoDestroy=true
    Style=STY_Masked
    bNoDelete=false
    LifeSpan=4.0

    Begin Object Class=SpriteEmitter Name=SpriteEmitter0
        FadeOut=true
        RespawnDeadParticles=false
        SpinParticles=true
        UseSizeScale=true
        UseRegularSizeScale=false
        UniformSize=true
        AutomaticInitialSpawning=false
        Acceleration=(X=50.0,Y=50.0,Z=0.5)
        ColorScale(0)=(color=(B=104,G=123,R=132,A=255))
        ColorScale(1)=(RelativeTime=1.0,color=(B=255,G=255,R=255,A=255))
        FadeOutStartTime=0.99
        MaxParticles=1
        StartLocationRange=(X=(Min=-25.0,Max=25.0),Y=(Min=-25.0,Max=25.0))
        StartLocationShape=PTLS_Sphere
        SpinsPerSecondRange=(X=(Min=0.05,Max=0.1))
        StartSpinRange=(X=(Min=-0.5,Max=0.5))
        SizeScale(0)=(RelativeTime=1.0,RelativeSize=7.0)
        StartSizeRange=(X=(Min=4.0,Max=8.0),Y=(Min=4.0,Max=8.0),Z=(Min=4.0,Max=8.0))
        InitialParticlesPerSecond=100.0
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.explosions.DSmoke_1'
        SecondsBeforeInactive=0.0
        LifetimeRange=(Min=0.3,Max=0.3)
        StartVelocityRange=(X=(Min=-100.0,Max=100.0),Y=(Min=-100.0,Max=100.0),Z=(Min=-100.0,Max=100.0))
        VelocityLossRange=(X=(Min=3.0,Max=3.0),Y=(Min=3.0,Max=3.0),Z=(Min=3.0,Max=3.0))
    End Object
    Emitters(0)=SpriteEmitter'SpriteEmitter0'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter1
        FadeOut=true
        FadeIn=true
        RespawnDeadParticles=false
        UseSizeScale=true
        UseRegularSizeScale=false
        UniformSize=true
        AutomaticInitialSpawning=false
        UseRandomSubdivision=true
        Acceleration=(Z=50.0)
        ColorScale(0)=(color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.0,color=(B=255,G=255,R=255,A=255))
        FadeOutStartTime=0.1025
        FadeInEndTime=0.05
        MaxParticles=1
        SizeScale(1)=(RelativeTime=0.14,RelativeSize=1.0)
        SizeScale(2)=(RelativeTime=1.0,RelativeSize=1.5)
        StartSizeRange=(X=(Min=6.0,Max=6.0),Y=(Min=6.0,Max=6.0),Z=(Min=6.0,Max=6.0))
        InitialParticlesPerSecond=30.0
        DrawStyle=PTDS_Brighten
        Texture=Texture'Effects_Tex.Weapons.muzzle_4frame3rd'
        TextureUSubdivisions=2
        TextureVSubdivisions=2
        LifetimeRange=(Min=0.2,Max=0.2)
        StartVelocityRange=(Z=(Min=10.0,Max=10.0))
    End Object
    Emitters(1)=SpriteEmitter'SpriteEmitter1'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter2
        UseColorScale=true
        FadeOut=true
        RespawnDeadParticles=false
        UseRevolution=true
        SpinParticles=true
        UseSizeScale=true
        UseRegularSizeScale=false
        UniformSize=true
        AutomaticInitialSpawning=false
        UseRandomSubdivision=true
        Acceleration=(Z=-1200.0)
        DampingFactorRange=(X=(Min=0.2,Max=0.2),Y=(Min=0.2,Max=0.2),Z=(Min=0.2,Max=0.2))
        ColorScale(0)=(color=(B=128,G=128,R=128,A=255))
        ColorScale(1)=(RelativeTime=1.0,color=(B=192,G=192,R=192,A=255))
        FadeOutStartTime=1.4
        MaxParticles=3
        UseRotationFrom=PTRS_Actor
        SpinsPerSecondRange=(X=(Min=0.2,Max=0.5))
        StartSpinRange=(X=(Min=0.5,Max=0.5))
        SizeScale(0)=(RelativeTime=1.0,RelativeSize=5.0)
        StartSizeRange=(X=(Min=1.0,Max=1.5),Y=(Min=1.0,Max=1.5),Z=(Min=1.5,Max=2.5))
        InitialParticlesPerSecond=500.0
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.explosions.shrapnel3'
        TextureUSubdivisions=1
        TextureVSubdivisions=1
        LifetimeRange=(Min=2.0,Max=2.0)
        StartVelocityRange=(X=(Min=100.0,Max=300.0),Y=(Min=-100.0,Max=100.0),Z=(Min=-100.0,Max=100.0))
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
        ColorScale(0)=(color=(B=91,G=91,R=91,A=255))
        ColorScale(1)=(RelativeTime=1.0,color=(B=128,G=128,R=128,A=255))
        FadeOutStartTime=1.47
        FadeInEndTime=0.18
        MaxParticles=1
        StartLocationRange=(X=(Min=-10.0,Max=10.0),Y=(Min=-10.0,Max=10.0))
        AddLocationFromOtherEmitter=2
        SpinCCWorCW=(X=1.0)
        SpinsPerSecondRange=(X=(Min=0.05,Max=0.1))
        StartSpinRange=(X=(Min=-0.5,Max=0.5))
        SizeScale(1)=(RelativeTime=0.5,RelativeSize=2.0)
        SizeScale(2)=(RelativeTime=1.0,RelativeSize=3.0)
        StartSizeRange=(X=(Min=12.5,Max=20.0),Y=(Min=12.5,Max=20.0),Z=(Min=12.5,Max=20.0))
        InitialParticlesPerSecond=25.0
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.explosions.DSmoke_2'
        SecondsBeforeInactive=0.0
        LifetimeRange=(Min=1.0,Max=1.0)
        InitialDelayRange=(Min=0.15,Max=0.15)
        StartVelocityRange=(X=(Min=-10.0,Max=10.0),Y=(Min=-50.0,Max=50.0),Z=(Min=-50.0,Max=50.0))
        VelocityLossRange=(X=(Min=3.0,Max=3.0),Y=(Min=3.0,Max=3.0),Z=(Min=3.0,Max=3.0))
    End Object
    Emitters(3)=SpriteEmitter'SpriteEmitter3'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter4
        UseColorScale=true
        FadeOut=true
        RespawnDeadParticles=false
        UseRevolution=true
        SpinParticles=true
        UseSizeScale=true
        UseRegularSizeScale=false
        UniformSize=true
        AutomaticInitialSpawning=false
        UseRandomSubdivision=true
        Acceleration=(Z=-1200.0)
        DampingFactorRange=(X=(Min=0.2,Max=0.2),Y=(Min=0.2,Max=0.2),Z=(Min=0.2,Max=0.2))
        ColorScale(0)=(color=(B=128,G=128,R=128,A=255))
        ColorScale(1)=(RelativeTime=1.0,color=(B=192,G=192,R=192,A=255))
        FadeOutStartTime=1.4
        MaxParticles=3
        UseRotationFrom=PTRS_Actor
        SpinsPerSecondRange=(X=(Min=0.2,Max=0.5))
        StartSpinRange=(X=(Min=0.5,Max=0.5))
        SizeScale(0)=(RelativeTime=1.0,RelativeSize=5.0)
        StartSizeRange=(X=(Min=1.0,Max=1.5),Y=(Min=1.0,Max=1.5),Z=(Min=1.5,Max=2.5))
        InitialParticlesPerSecond=500.0
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.explosions.shrapnel1'
        TextureUSubdivisions=1
        TextureVSubdivisions=1
        LifetimeRange=(Min=2.0,Max=2.0)
        StartVelocityRange=(X=(Min=300.0,Max=445.0),Y=(Min=-300.0,Max=300.0),Z=(Min=-300.0,Max=300.0))
    End Object
    Emitters(4)=SpriteEmitter'SpriteEmitter4'
}

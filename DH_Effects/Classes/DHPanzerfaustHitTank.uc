//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHPanzerfaustHitTank extends Emitter;

defaultproperties
{
    AutoDestroy=True
    Style=STY_Masked
    bUnlit=true
    bDirectional=True
    bNoDelete=false
    RemoteRole=ROLE_SimulatedProxy
    bNetTemporary=true
    bHardAttach=true
    LifeSpan = 4

    Begin Object Class=SpriteEmitter Name=SpriteEmitter7
        UseColorScale=True
        FadeOut=True
        FadeIn=True
        RespawnDeadParticles=False
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        ColorScale(0)=(Color=(B=174,G=228,R=255,A=255))
        ColorScale(1)=(RelativeTime=0.200000,Color=(B=255,G=255,R=255,A=255))
        ColorScale(2)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        ColorScale(3)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        ColorScale(4)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        FadeOutStartTime=0.102500
        FadeInEndTime=0.050000
        MaxParticles=4

        SizeScale(1)=(RelativeTime=0.250000,RelativeSize=1.000000)
        SizeScale(2)=(RelativeTime=1.000000,RelativeSize=2.000000)
        StartSizeRange=(X=(Min=150.000000,Max=150.000000),Y=(Min=150.000000,Max=150.000000),Z=(Min=150.000000,Max=150.000000))
        InitialParticlesPerSecond=30.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.explosions.radialexplosion_1frame'
        LifetimeRange=(Min=0.500000,Max=0.700000)
    End Object
    Emitters(0)=SpriteEmitter'SpriteEmitter7'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter8
        UseColorScale=True
        FadeOut=True
        RespawnDeadParticles=False
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        Acceleration=(Z=-100.000000)
        ColorScale(0)=(Color=(A=255))
        ColorScale(1)=(RelativeTime=0.357143,Color=(B=89,G=89,R=89,A=255))
        ColorScale(2)=(RelativeTime=1.000000,Color=(B=125,G=125,R=125,A=255))
        Opacity=0.750000
        FadeOutStartTime=0.500000
        MaxParticles=15

        StartLocationRange=(X=(Min=-25.000000,Max=25.000000),Y=(Min=-25.000000,Max=25.000000))
        UseRotationFrom=PTRS_Actor
        SpinsPerSecondRange=(X=(Min=0.050000,Max=0.100000))
        StartSpinRange=(X=(Min=-0.500000,Max=0.500000))
        SizeScale(0)=(RelativeTime=0.250000,RelativeSize=2.000000)
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=5.000000)
        StartSizeRange=(X=(Min=50.000000,Max=80.000000),Y=(Min=50.000000,Max=80.000000),Z=(Min=50.000000,Max=80.000000))
        InitialParticlesPerSecond=500.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.explosions.LSmoke3'
        SecondsBeforeInactive=0.000000
        LifetimeRange=(Min=2.500000,Max=3.000000)
        StartVelocityRange=(X=(Min=-500.000000,Max=500.000000),Y=(Min=-500.000000,Max=500.000000),Z=(Min=-100.000000,Max=400.000000))
        VelocityLossRange=(X=(Min=3.000000,Max=3.000000),Y=(Min=3.000000,Max=3.000000),Z=(Min=3.000000,Max=3.000000))
    End Object
    Emitters(1)=SpriteEmitter'SpriteEmitter8'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter9
        FadeOut=True
        FadeIn=True
        RespawnDeadParticles=False
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        BlendBetweenSubdivisions=True
        Acceleration=(Z=50.000000)
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        Opacity=0.600000
        FadeOutStartTime=0.102500
        FadeInEndTime=0.050000
        MaxParticles=2

        UseRotationFrom=PTRS_Actor
        SizeScale(1)=(RelativeTime=0.140000,RelativeSize=1.000000)
        SizeScale(2)=(RelativeTime=1.000000,RelativeSize=1.500000)
        StartSizeRange=(X=(Min=40.000000,Max=80.000000),Y=(Min=40.000000,Max=80.000000),Z=(Min=40.000000,Max=80.000000))
        InitialParticlesPerSecond=30.000000
        DrawStyle=PTDS_Brighten
        Texture=Texture'Effects_Tex.Weapons.muzzle_4frame3rd'
        TextureUSubdivisions=2
        TextureVSubdivisions=2
        LifetimeRange=(Min=0.200000,Max=0.200000)
        StartVelocityRange=(Z=(Min=10.000000,Max=10.000000))
    End Object
    Emitters(2)=SpriteEmitter'SpriteEmitter9'

    Begin Object Class=SparkEmitter Name=SparkEmitter0
        LineSegmentsRange=(Min=0.750000,Max=1.500000)
        TimeBeforeVisibleRange=(Min=0.010000,Max=0.500000)
        TimeBetweenSegmentsRange=(Min=0.050000,Max=0.050000)
        FadeOut=True
        RespawnDeadParticles=False
        AutomaticInitialSpawning=False
        Acceleration=(Z=-200.000000)
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        FadeOutStartTime=0.400000
        MaxParticles=50

        StartLocationShape=PTLS_Sphere
        SphereRadiusRange=(Max=10.000000)
        UseRotationFrom=PTRS_Actor
        InitialParticlesPerSecond=1000.000000
        Texture=Texture'Effects_Tex.explosions.fire_quad'
        LifetimeRange=(Min=1.000000,Max=2.000000)
        StartVelocityRange=(X=(Min=-50.000000,Max=300.000000),Y=(Min=-400.000000,Max=400.000000),Z=(Min=-300.000000,Max=450.000000))
    End Object
    Emitters(3)=SparkEmitter'SparkEmitter0'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter10
        UseColorScale=True
        FadeOut=True
        FadeIn=True
        RespawnDeadParticles=False
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        Acceleration=(Z=50.000000)
        ColorScale(0)=(Color=(R=185,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        Opacity=0.400000
        FadeOutStartTime=0.102500
        FadeInEndTime=0.050000
        MaxParticles=2

        UseRotationFrom=PTRS_Actor
        SizeScale(1)=(RelativeTime=0.140000,RelativeSize=5.000000)
        SizeScale(2)=(RelativeTime=1.000000,RelativeSize=10.000000)
        StartSizeRange=(X=(Min=75.000000,Max=75.000000),Y=(Min=75.000000,Max=75.000000),Z=(Min=75.000000,Max=75.000000))
        InitialParticlesPerSecond=30.000000
        DrawStyle=PTDS_Brighten
        Texture=Texture'SpecialEffects.Coronas.Corona2'
        LifetimeRange=(Min=0.200000,Max=0.200000)
        StartVelocityRange=(Z=(Min=10.000000,Max=10.000000))
    End Object
    Emitters(4)=SpriteEmitter'SpriteEmitter10'

    Begin Object Class=SparkEmitter Name=SparkEmitter1
        LineSegmentsRange=(Min=1.500000,Max=2.500000)
        TimeBeforeVisibleRange=(Min=0.010000,Max=0.500000)
        TimeBetweenSegmentsRange=(Min=0.050000,Max=0.050000)
        FadeOut=True
        RespawnDeadParticles=False
        AutomaticInitialSpawning=False
        Acceleration=(Z=-250.000000)
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        FadeOutStartTime=0.400000

        StartLocationShape=PTLS_Sphere
        SphereRadiusRange=(Max=10.000000)
        UseRotationFrom=PTRS_Actor
        InitialParticlesPerSecond=1000.000000
        Texture=Texture'Effects_Tex.explosions.fire_quad'
        LifetimeRange=(Min=1.000000,Max=2.000000)
        StartVelocityRange=(X=(Min=-50.000000,Max=50.000000),Y=(Min=-50.000000,Max=50.000000),Z=(Min=400.000000,Max=800.000000))
    End Object
    Emitters(5)=SparkEmitter'SparkEmitter1'
}

//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHTankAPHitDeflect extends Emitter;

defaultproperties
{
    Begin Object Class=SpriteEmitter Name=SpriteEmitter9
        FadeOut=True
        FadeIn=True
        RespawnDeadParticles=False
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        Acceleration=(X=50.000000,Y=50.000000,Z=-100.000000)
        ColorScale(0)=(Color=(B=104,G=123,R=132,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        FadeOutStartTime=0.990000
        FadeInEndTime=0.250000
        StartLocationRange=(X=(Min=-25.000000,Max=25.000000),Y=(Min=-25.000000,Max=25.000000))
        StartLocationShape=PTLS_Sphere
        SpinsPerSecondRange=(X=(Min=0.050000,Max=0.100000))
        StartSpinRange=(X=(Min=-0.500000,Max=0.500000))
        SizeScale(0)=(RelativeTime=1.000000,RelativeSize=7.000000)
        StartSizeRange=(X=(Min=10.000000,Max=50.000000),Y=(Min=10.000000,Max=50.000000),Z=(Min=20.000000,Max=20.000000))
        InitialParticlesPerSecond=100.000000
        DrawStyle=PTDS_AlphaBlend
        UseRotationFrom=PTRS_Actor
        Texture=Texture'Effects_Tex.explosions.DSmoke_2'
        SecondsBeforeInactive=0.000000
        LifetimeRange=(Min=2.500000,Max=3.000000)
        StartVelocityRange=(X=(Min=-100.000000,Max=300.000000),Y=(Min=-300.000000,Max=300.000000),Z=(Min=-200.000000,Max=200.000000))
        VelocityLossRange=(X=(Min=3.000000,Max=3.000000),Y=(Min=3.000000,Max=3.000000),Z=(Min=3.000000,Max=3.000000))
    End Object
    Emitters(0)=SpriteEmitter'SpriteEmitter9'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter10
        FadeOut=True
        FadeIn=True
        RespawnDeadParticles=False
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        UseRandomSubdivision=True
        Acceleration=(Z=50.000000)
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        FadeOutStartTime=0.102500
        FadeInEndTime=0.050000
        MaxParticles=2

        SizeScale(1)=(RelativeTime=0.140000,RelativeSize=1.000000)
        SizeScale(2)=(RelativeTime=1.000000,RelativeSize=1.500000)
        StartSizeRange=(X=(Min=40.000000,Max=40.000000),Y=(Min=40.000000,Max=40.000000),Z=(Min=40.000000,Max=40.000000))
        InitialParticlesPerSecond=30.000000
        DrawStyle=PTDS_Brighten
        UseRotationFrom=PTRS_Actor
        Texture=Texture'Effects_Tex.Weapons.muzzle_4frame3rd'
        TextureUSubdivisions=2
        TextureVSubdivisions=2
        LifetimeRange=(Min=0.200000,Max=0.200000)
        StartVelocityRange=(Z=(Min=10.000000,Max=10.000000))
    End Object
    Emitters(1)=SpriteEmitter'SpriteEmitter10'

    Begin Object Class=SparkEmitter Name=SparkEmitter1
        LineSegmentsRange=(Min=2.0,Max=2.5)
        TimeBetweenSegmentsRange=(Min=0.100000,Max=0.100000)
        FadeOut=True
        FadeIn=True
        RespawnDeadParticles=False
        AutomaticInitialSpawning=False
        Acceleration=(Z=-10.000000)
        UseColorScale=true
        ColorScale(0)=(Color=(B=0,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=0.25,Color=(B=0,G=0,R=255,A=255))
        ColorScale(2)=(RelativeTime=0.7,Color=(B=255,G=255,R=255,A=255))
        ColorScale(3)=(RelativeTime=1.0,Color=(B=0,G=0,R=0,A=255))
        FadeOutStartTime=0.10
        FadeInEndTime=0.0
        MaxParticles=30
        StartLocationShape=PTLS_Sphere
        UseRotationFrom=PTRS_Actor
        SphereRadiusRange=(Max=1.000000)
        InitialParticlesPerSecond=5000.000000
        Texture=Texture'Effects_Tex.BulletHits.sparkfinal2'
        LifetimeRange=(Min=0.5,Max=0.75)
        StartVelocityRange=(X=(Min=-200,Max=300.000000),Y=(Min=-100.000000,Max=100.000000),Z=(Min=-50.000000,Max=500.000000))
    End Object
    Emitters(2)=SparkEmitter'SparkEmitter1'

    Begin Object Class=SparkEmitter Name=SparkEmitter2
        LineSegmentsRange=(Min=0.0,Max=0.0)
        TimeBetweenSegmentsRange=(Min=0.100000,Max=0.100000)
        FadeOut=True
        FadeIn=True
        RespawnDeadParticles=False
        AutomaticInitialSpawning=False
        Acceleration=(Z=-10.000000)
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        FadeOutStartTime=0.25
        FadeInEndTime=0.25
        MaxParticles=15
        StartLocationShape=PTLS_Sphere
        UseRotationFrom=PTRS_Actor
        SphereRadiusRange=(Max=1.000000)
        InitialParticlesPerSecond=5000.000000
        Texture=Texture'Effects_Tex.BulletHits.sparkfinal2'
        LifetimeRange=(Min=0.500000,Max=0.750000)
        StartVelocityRange=(X=(Min=-50,Max=50.000000),Y=(Min=-50.000000,Max=50.000000),Z=(Min=200.000000,Max=350.000000))
    End Object
    Emitters(3)=SparkEmitter'SparkEmitter2'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter7
        UseCollision=True
        UseMaxCollisions=True
        FadeOut=True
        FadeIn=True
        RespawnDeadParticles=False
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        Acceleration=(Z=-250.000000)
        MaxCollisions=(Min=1.000000,Max=2.000000)
        DampingFactorRange=(X=(Min=0.7,Max=0.7),Y=(Min=0.7,Max=0.7),Z=(Min=0.7,Max=0.7))
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        FadeOutStartTime=1.600000
        FadeInEndTime=0.08
        name="embers"
        StartLocationRange=(Z=(Min=100.000000,Max=150.000000))
        SizeScale(0)=(RelativeSize=1.00000)
        SizeScale(1)=(RelativeTime=0.500000,RelativeSize=2.000000)
        SizeScale(2)=(RelativeTime=1.000000,RelativeSize=1.500000)
        StartSizeRange=(X=(Min=2.000000,Max=3.000000),Y=(Min=2.000000,Max=3.00000),Z=(Min=2.000000,Max=3.00000))
        InitialParticlesPerSecond=50.000000
        DrawStyle=PTDS_AlphaBlend
        UseRotationFrom=PTRS_Actor
        Texture=Texture'DH_FX_Tex.Effects.FlareOrange'
        LifetimeRange=(Min=1.000000,Max=2.5)
        StartVelocityRange=(X=(Min=100.000000,Max=400.000000),Y=(Min=-400.000000,Max=400.000000),Z=(Min=-150.000000,Max=500.000000))
    End Object
    Emitters(7)=SpriteEmitter'SpriteEmitter7'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter8
        UseCollision=false
        FadeOut=True
        FadeIn=True
        RespawnDeadParticles=False
        UniformSize=True
        AutomaticInitialSpawning=False
        UseRandomSubdivision=True
        Acceleration=(Z=-250.000000)
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        FadeOutStartTime=0.750000
        Opacity=0.75
        MaxParticles=40
        Name="SpriteEmitter38"
        UseRotationFrom=PTRS_Actor
        StartSizeRange=(X=(Min=2.00000,Max=3.0000))
        InitialParticlesPerSecond=300.000000
        DrawStyle=PTDS_Brighten
        Texture=Texture'Effects_Tex.Smoke.Sparks'
        TextureUSubdivisions=2
        TextureVSubdivisions=2
        LifetimeRange=(Min=1.500000,Max=2.500000)
        StartVelocityRange=(X=(Min=150.000000,Max=250.000000),Y=(Min=-150.000000,Max=150.000000),Z=(Min=-150.000000,Max=500.000000))
    End Object
    Emitters(8)=SpriteEmitter'SpriteEmitter8'


    bLightChanged=True

    AutoDestroy=True
    Style=STY_Masked
    bUnlit=true
    bDirectional=True
    bNoDelete=false
    RemoteRole=ROLE_SimulatedProxy
    bNetTemporary=true
    bHardAttach=true
    LifeSpan = 4

    bSelected=True
}

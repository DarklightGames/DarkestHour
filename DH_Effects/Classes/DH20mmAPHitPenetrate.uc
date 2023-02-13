//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH20mmAPHitPenetrate extends Emitter;

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
    LifeSpan = 8
    DrawScale=0.75

    Begin Object Class=SpriteEmitter Name=SpriteEmitter0
        UseColorScale=True
        FadeOut=True
        RespawnDeadParticles=False
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        UseRandomSubdivision=True
        Acceleration=(Z=-30.000000)
        ColorScale(0)=(Color=(A=255))
        ColorScale(1)=(RelativeTime=0.532143,Color=(B=56,G=56,R=56,A=255))
        ColorScale(2)=(RelativeTime=1.000000,Color=(B=106,G=106,R=106,A=255))
        FadeOutStartTime=0.500000
        MaxParticles=800

        AddLocationFromOtherEmitter=5
        SpinsPerSecondRange=(X=(Min=0.100000,Max=0.150000))
        StartSpinRange=(X=(Min=-0.500000,Max=0.500000))
        SizeScale(0)=(RelativeSize=1.000000)
        SizeScale(1)=(RelativeTime=0.500000,RelativeSize=3.000000)
        SizeScale(2)=(RelativeTime=1.000000,RelativeSize=5.000000)
        StartSizeRange=(X=(Min=4.000000,Max=6.000000),Y=(Min=4.000000,Max=6.000000),Z=(Min=6.000000,Max=8.000000))
        InitialParticlesPerSecond=1200.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.BulletHits.stonesmokefinal'
        TextureUSubdivisions=2
        TextureVSubdivisions=2
        SecondsBeforeInactive=0.000000
        MinSquaredVelocity=0.500000
        LifetimeRange=(Min=1.500000,Max=2.000000)
        StartVelocityRange=(X=(Min=-100.000000,Max=100.000000),Y=(Min=-100.000000,Max=100.000000),Z=(Min=10.000000,Max=350.000000))
        MaxAbsVelocity=(X=5.000000,Y=5.000000,Z=5.000000)
        VelocityLossRange=(Z=(Min=3.000000,Max=3.000000))
        AddVelocityFromOtherEmitter=4
    End Object
    Emitters(0)=SpriteEmitter'SpriteEmitter0'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter1
        UseColorScale=True
        FadeOut=True
        FadeIn=True
        RespawnDeadParticles=False
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        TriggerDisabled=False
        ResetOnTrigger=True
        Acceleration=(Z=-100.000000)
        ColorScale(0)=(Color=(A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=85,G=85,R=85,A=255))
        Opacity=0.500000
        FadeOutStartTime=0.500000
        FadeInEndTime=0.200000
        MaxParticles=2

        StartLocationRange=(X=(Min=-10.000000,Max=10.000000),Y=(Min=-10.000000,Max=10.000000))
        UseRotationFrom=PTRS_Actor
        SpinCCWorCW=(X=1.000000)
        SpinsPerSecondRange=(X=(Min=-0.100000,Max=0.100000))
        StartSpinRange=(X=(Min=-0.500000,Max=0.500000))
        SizeScale(0)=(RelativeSize=1.000000)
        SizeScale(1)=(RelativeTime=0.140000,RelativeSize=3.000000)
        SizeScale(2)=(RelativeTime=1.000000,RelativeSize=7.000000)
        StartSizeRange=(X=(Min=25.000000,Max=35.000000),Y=(Min=25.000000,Max=35.000000),Z=(Min=45.000000,Max=50.000000))
        InitialParticlesPerSecond=500.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.explosions.LSmoke3'
        SecondsBeforeInactive=0.000000
        LifetimeRange=(Min=2.000000)
        StartVelocityRange=(X=(Min=100.000000,Max=100.000000))
        VelocityLossRange=(X=(Min=3.000000,Max=3.000000),Y=(Min=3.000000,Max=3.000000),Z=(Min=3.000000,Max=3.000000))
    End Object
    Emitters(1)=SpriteEmitter'SpriteEmitter1'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter2
        FadeOut=True
        RespawnDeadParticles=False
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        UseRandomSubdivision=True
        ColorScale(0)=(Color=(G=128,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=213,G=234,R=255,A=255))
        FadeOutStartTime=0.050000
        MaxParticles=2

        UseRotationFrom=PTRS_Actor
        StartSpinRange=(X=(Min=0.500000,Max=0.500000))
        SizeScale(0)=(RelativeSize=0.500000)
        SizeScale(1)=(RelativeTime=0.250000,RelativeSize=1.000000)
        SizeScale(2)=(RelativeTime=1.000000,RelativeSize=2.000000)
        StartSizeRange=(X=(Min=15.000000,Max=35.000000),Y=(Min=15.000000,Max=35.000000),Z=(Min=15.000000,Max=35.000000))
        InitialParticlesPerSecond=30.000000
        DrawStyle=PTDS_Brighten
        Texture=Texture'Effects_Tex.Weapons.muzzle_4frame3rd'
        TextureUSubdivisions=2
        TextureVSubdivisions=2
        LifetimeRange=(Min=0.100000,Max=0.200000)
    End Object
    Emitters(2)=SpriteEmitter'SpriteEmitter2'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter3
        UseColorScale=True
        FadeOut=True
        RespawnDeadParticles=False
        Disabled=True
        Backup_Disabled=True
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        Acceleration=(X=50.000000,Y=50.000000,Z=-100.000000)
        ColorScale(0)=(Color=(A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=128,G=128,R=128,A=255))
        FadeOutStartTime=0.990000
        MaxParticles=5

        StartLocationRange=(X=(Min=-25.000000,Max=25.000000),Y=(Min=-25.000000,Max=25.000000))
        StartLocationShape=PTLS_Sphere
        SpinsPerSecondRange=(X=(Min=0.050000,Max=0.100000))
        StartSpinRange=(X=(Min=-0.500000,Max=0.500000))
        SizeScale(0)=(RelativeTime=1.000000,RelativeSize=10.000000)
        StartSizeRange=(X=(Min=10.000000,Max=50.000000),Y=(Min=10.000000,Max=50.000000),Z=(Min=20.000000,Max=20.000000))
        InitialParticlesPerSecond=500.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.explosions.DSmoke_2'
        SecondsBeforeInactive=0.000000
        LifetimeRange=(Min=3.000000,Max=3.000000)
        StartVelocityRange=(X=(Min=-500.000000,Max=500.000000),Y=(Min=-500.000000,Max=500.000000),Z=(Min=50.000000,Max=75.000000))
        VelocityLossRange=(X=(Min=3.000000,Max=3.000000),Y=(Min=3.000000,Max=3.000000),Z=(Min=3.000000,Max=3.000000))
    End Object
    Emitters(3)=SpriteEmitter'SpriteEmitter3'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter4
        FadeOut=True
        RespawnDeadParticles=False
        UseRevolution=True
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        Acceleration=(Z=-300.000000)
        DampingFactorRange=(X=(Min=0.200000,Max=0.200000),Y=(Min=0.200000,Max=0.200000),Z=(Min=0.200000,Max=0.200000))
        ColorScale(0)=(Color=(B=128,G=128,R=128,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=192,G=192,R=192,A=255))
        FadeOutStartTime=1.100000
        MaxParticles=15

        StartLocationShape=PTLS_Sphere
        SphereRadiusRange=(Min=5.000000,Max=8.000000)
        UseRotationFrom=PTRS_Actor
        SpinsPerSecondRange=(X=(Min=-0.200000,Max=0.200000))
        StartSpinRange=(X=(Min=0.500000,Max=0.500000))
        SizeScale(0)=(RelativeTime=1.000000,RelativeSize=1.500000)
        StartSizeRange=(X=(Min=2.000000,Max=3.000000),Y=(Min=2.000000,Max=3.000000),Z=(Min=2.000000,Max=3.000000))
        InitialParticlesPerSecond=500.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'DH_FX_Tex.Effects.FlareOrange'
        LifetimeRange=(Min=1.000000,Max=2.000000)
        StartVelocityRange=(X=(Min=100.000000,Max=600.000000),Y=(Min=-200.000000,Max=400.000000),Z=(Min=-200.000000,Max=400.000000))
    End Object
    Emitters(4)=SpriteEmitter'SpriteEmitter4'

    Begin Object Class=SparkEmitter Name=SparkEmitter0
        LineSegmentsRange=(Min=0.500000,Max=1.000000)
        TimeBeforeVisibleRange=(Min=0.010000,Max=0.050000)
        TimeBetweenSegmentsRange=(Min=0.050000,Max=0.100000)
        UseColorScale=True
        FadeOut=True
        RespawnDeadParticles=False
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        Acceleration=(Z=-100.000000)
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        FadeOutStartTime=0.070000
        MaxParticles=40

        StartLocationShape=PTLS_Sphere
        SphereRadiusRange=(Min=2.000000,Max=5.000000)
        SizeScale(0)=(RelativeSize=10.000000)
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=1.000000)
        InitialParticlesPerSecond=1000.000000
        Texture=Texture'Effects_Tex.explosions.fire_quad'
        LifetimeRange=(Min=1.000000,Max=1.500000)
        StartVelocityRange=(X=(Min=-300.000000,Max=300.000000),Y=(Min=-250.000000,Max=350.000000),Z=(Min=-250.000000,Max=250.000000))
    End Object
    Emitters(5)=SparkEmitter'SparkEmitter0'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter5
        FadeOut=True
        FadeIn=True
        RespawnDeadParticles=False
        Disabled=True
        Backup_Disabled=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        UseRandomSubdivision=True
        Acceleration=(Z=-100.000000)
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        FadeOutStartTime=0.800000
        FadeInEndTime=0.020000
        MaxParticles=60

        StartLocationShape=PTLS_Sphere
        SphereRadiusRange=(Max=100.000000)
        UseRotationFrom=PTRS_Actor
        SizeScale(0)=(RelativeSize=1.000000)
        SizeScale(1)=(RelativeTime=0.500000,RelativeSize=2.000000)
        SizeScale(2)=(RelativeTime=1.000000,RelativeSize=1.500000)
        StartSizeRange=(X=(Min=0.500000,Max=1.000000),Y=(Min=0.500000,Max=1.000000),Z=(Min=0.500000,Max=1.000000))
        InitialParticlesPerSecond=500.000000
        DrawStyle=PTDS_Brighten
        Texture=Texture'Effects_Tex.Smoke.Sparks'
        TextureUSubdivisions=2
        TextureVSubdivisions=2
        LifetimeRange=(Min=0.750000,Max=2.000000)
        StartVelocityRange=(X=(Min=-200.000000,Max=200.000000),Y=(Min=-200.000000,Max=200.000000),Z=(Min=-200.000000,Max=200.000000))
        StartVelocityRadialRange=(Min=2.000000,Max=20.000000)
    End Object
    Emitters(6)=SpriteEmitter'SpriteEmitter5'

}

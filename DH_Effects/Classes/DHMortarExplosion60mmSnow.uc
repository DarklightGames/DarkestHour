//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2021
//==============================================================================

class DHMortarExplosion60mmSnow extends Emitter;

defaultproperties
{
    AutoDestroy=true
    bNoDelete=false

    Begin Object Class=SpriteEmitter Name=SpriteEmitter15
        UseColorScale=True
        FadeOut=True
        RespawnDeadParticles=False
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        Acceleration=(Z=-200.000000)
        ColorScale(0)=(Color=(B=192,G=192,R=192,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        FadeOutStartTime=0.500000
        MaxParticles=12

        StartLocationOffset=(Z=-50.000000)
        StartLocationRange=(X=(Min=-150.000000,Max=150.000000),Y=(Min=-150.000000,Max=150.000000))
        SpinCCWorCW=(X=1.000000)
        SpinsPerSecondRange=(X=(Min=-0.100000,Max=0.100000))
        StartSpinRange=(X=(Min=-0.500000,Max=0.500000))
        SizeScale(0)=(RelativeSize=1.000000)
        SizeScale(1)=(RelativeTime=0.140000,RelativeSize=3.000000)
        SizeScale(2)=(RelativeTime=1.000000,RelativeSize=7.000000)
        StartSizeRange=(X=(Min=45.000000,Max=65.000000),Y=(Min=45.000000,Max=65.000000),Z=(Min=25.000000,Max=35.000000))
        InitialParticlesPerSecond=512.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.explosions.LSmoke1'
        SecondsBeforeInactive=0.000000
        LifetimeRange=(Max=6.000000)
        InitialDelayRange=(Min=0.100000,Max=0.150000)
        StartVelocityRange=(X=(Min=-96.000000,Max=96.000000),Y=(Min=-96.000000,Max=96.000000),Z=(Min=400.000000,Max=800.000000))
        VelocityLossRange=(Z=(Min=4.000000,Max=6.000000))
    End Object
    Emitters(0)=SpriteEmitter'SpriteEmitter15'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter16
        UseColorScale=True
        FadeOut=True
        FadeIn=True
        RespawnDeadParticles=False
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        Acceleration=(X=15.000000,Y=10.000000,Z=75.000000)
        ColorScale(0)=(Color=(B=192,G=192,R=192,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        Opacity=0.600000
        FadeOutStartTime=0.960000
        FadeInEndTime=0.180000
        MaxParticles=12

        StartLocationOffset=(Z=-50.000000)
        StartLocationRange=(X=(Min=-100.000000,Max=150.000000),Y=(Min=-100.000000,Max=150.000000),Z=(Min=-25.000000,Max=25.000000))
        SpinCCWorCW=(X=1.000000)
        SpinsPerSecondRange=(X=(Min=-0.100000,Max=0.100000))
        StartSpinRange=(X=(Min=-0.500000,Max=0.500000))
        SizeScale(0)=(RelativeSize=1.000000)
        SizeScale(1)=(RelativeTime=0.140000,RelativeSize=3.000000)
        SizeScale(2)=(RelativeTime=1.000000,RelativeSize=20.000000)
        StartSizeRange=(X=(Min=25.000000,Max=40.000000),Y=(Min=25.000000,Max=40.000000),Z=(Min=25.000000,Max=40.000000))
        InitialParticlesPerSecond=100.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.explosions.LSmoke3'
        SecondsBeforeInactive=0.000000
        LifetimeRange=(Max=6.000000)
        StartVelocityRange=(X=(Min=85.000000,Max=150.000000),Y=(Min=85.000000,Max=150.000000),Z=(Min=500.000000,Max=700.000000))
        VelocityLossRange=(Z=(Min=3.250000,Max=3.700000))
    End Object
    Emitters(1)=SpriteEmitter'SpriteEmitter16'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter17
        FadeOut=True
        RespawnDeadParticles=False
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        UseRandomSubdivision=True
        Acceleration=(Z=100.000000)
        ColorScale(0)=(Color=(B=84,G=96,R=101,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=115,G=136,R=145,A=255))
        Opacity=0.770000
        MaxParticles=1

        StartLocationOffset=(Z=-50.000000)
        StartLocationRange=(Z=(Max=50.000000))
        StartSpinRange=(X=(Min=0.500000,Max=0.500000))
        SizeScale(0)=(RelativeSize=0.500000)
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=4.500000)
        StartSizeRange=(X=(Min=30.000000,Max=40.000000))
        InitialParticlesPerSecond=100.000000
        DrawStyle=PTDS_Brighten
        Texture=Texture'Effects_Tex.Weapons.muzzle_4frame3rd'
        TextureUSubdivisions=2
        TextureVSubdivisions=2
        LifetimeRange=(Min=0.250000,Max=0.350000)
        StartVelocityRange=(Y=(Min=-50.000000,Max=50.000000),Z=(Min=300.000000,Max=350.000000))
    End Object
    Emitters(2)=SpriteEmitter'SpriteEmitter17'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter18
        UseColorScale=True
        FadeOut=True
        RespawnDeadParticles=False
        SpinParticles=True
        DampRotation=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        Acceleration=(Z=-900.000000)
        DampingFactorRange=(X=(Min=0.150000,Max=0.250000),Y=(Min=0.150000,Max=0.250000),Z=(Min=0.150000,Max=0.250000))
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        MaxParticles=8

        SpinsPerSecondRange=(X=(Min=0.100000,Max=0.250000))
        StartSpinRange=(X=(Min=-0.500000,Max=0.500000))
        RotationDampingFactorRange=(X=(Min=1.000000,Max=1.000000),Y=(Min=1.000000,Max=1.000000),Z=(Min=1.000000,Max=1.000000))
        SizeScale(0)=(RelativeSize=0.100000)
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=1.500000)
        StartSizeRange=(X=(Min=50.000000,Max=75.000000))
        InitialParticlesPerSecond=10000.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'DH_FX_Tex.debris.genericchunkssparse'
        LifetimeRange=(Min=2.000000,Max=2.000000)
        StartVelocityRange=(X=(Min=-200.000000,Max=250.000000),Y=(Min=-250.000000,Max=200.000000),Z=(Min=400.000000,Max=750.000000))
        VelocityScale(0)=(RelativeVelocity=(X=1.000000,Y=1.000000,Z=1.000000))
        VelocityScale(1)=(RelativeTime=0.475000,RelativeVelocity=(X=0.100000,Y=0.200000,Z=0.200000))
        VelocityScale(2)=(RelativeTime=1.000000)
    End Object
    Emitters(3)=SpriteEmitter'SpriteEmitter18'

    Begin Object Class=SparkEmitter Name=SparkEmitter1
        LineSegmentsRange=(Min=1.000000,Max=2.000000)
        TimeBeforeVisibleRange=(Min=0.100000,Max=0.500000)
        TimeBetweenSegmentsRange=(Min=0.020000,Max=0.050000)
        UseColorScale=True
        FadeOut=True
        RespawnDeadParticles=False
        AutomaticInitialSpawning=False
        Acceleration=(Z=-100.000000)
        ColorScale(0)=(Color=(B=128,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(R=128,A=255))
        MaxParticles=100

        InitialParticlesPerSecond=500.000000
        Texture=Texture'Effects_Tex.explosions.fire_quad'
        LifetimeRange=(Min=0.200000,Max=0.750000)
        StartVelocityRange=(X=(Min=-550.000000,Max=500.000000),Y=(Min=-525.000000,Max=600.000000),Z=(Min=-100.000000,Max=350.000000))
        VelocityLossRange=(Z=(Min=1.000000,Max=3.000000))
    End Object
    Emitters(4)=SparkEmitter'SparkEmitter1'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter19
        UseDirectionAs=PTDU_UpAndNormal
        ProjectionNormal=(X=1.000000,Y=0.500000)
        UseCollision=True
        UseColorScale=True
        FadeOut=True
        RespawnDeadParticles=False
        Disabled=True
        Backup_Disabled=True
        SpinParticles=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        UseRandomSubdivision=True
        Acceleration=(Y=10.000000,Z=-100.000000)
        DampingFactorRange=(X=(Min=0.000000,Max=0.000000),Y=(Min=0.000000,Max=0.000000),Z=(Min=0.000000,Max=0.000000))
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=64,G=128,R=255,A=255))
        ColorScaleRepeats=4.000000
        FadeOutStartTime=0.450000
        MaxParticles=100

        StartLocationOffset=(Z=20.000000)
        AddLocationFromOtherEmitter=4
        SphereRadiusRange=(Min=20.000000,Max=50.000000)
        SpinsPerSecondRange=(X=(Min=0.500000,Max=4.000000))
        StartSpinRange=(X=(Min=-0.500000,Max=1.000000))
        StartSizeRange=(X=(Min=1.500000,Max=3.000000))
        InitialParticlesPerSecond=1000.000000
        Texture=Texture'Effects_Tex.Smoke.Sparks'
        TextureUSubdivisions=2
        TextureVSubdivisions=2
        LifetimeRange=(Min=1.000000,Max=3.000000)
        InitialDelayRange=(Min=0.300000,Max=0.450000)
        StartVelocityRange=(X=(Min=-160.000000,Max=150.000000),Y=(Min=-150.000000,Max=165.000000),Z=(Min=25.000000,Max=75.000000))
        VelocityLossRange=(Z=(Min=1.000000,Max=3.000000))
        GetVelocityDirectionFrom=PTVD_StartPositionAndOwner
    End Object
    Emitters(5)=SpriteEmitter'SpriteEmitter19'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter21
        UseCollision=True
        UseMaxCollisions=True
        FadeOut=True
        RespawnDeadParticles=False
        SpinParticles=True
        DampRotation=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        UseRandomSubdivision=True
        Acceleration=(Z=-950.000000)
        ExtentMultiplier=(X=0.500000,Y=0.500000,Z=0.500000)
        DampingFactorRange=(X=(Min=0.000000,Max=0.000000),Y=(Min=0.000000,Max=0.000000),Z=(Min=0.500000,Max=0.500000))
        SpawnFromOtherEmitter=8
        SpawnAmount=1
        ColorScale(0)=(Color=(B=128,G=128,R=128,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=128,G=128,R=128,A=255))

        StartLocationOffset=(Z=25.000000)
        SpinsPerSecondRange=(X=(Min=0.100000,Max=0.200000))
        StartSpinRange=(X=(Min=0.500000,Max=0.500000))
        RotationDampingFactorRange=(X=(Min=1.000000,Max=1.000000),Y=(Min=1.000000,Max=1.000000),Z=(Min=1.000000,Max=1.000000))
        StartSizeRange=(X=(Min=1.500000,Max=3.000000))
        InitialParticlesPerSecond=1000.000000
        Texture=Texture'Effects_Tex.Smoke.Sparks'
        TextureUSubdivisions=2
        TextureVSubdivisions=2
        StartVelocityRange=(X=(Min=-2000.000000,Max=1900.000000),Y=(Min=-1900.000000,Max=2000.000000),Z=(Min=200.000000,Max=450.000000))
    End Object
    Emitters(6)=SpriteEmitter'SpriteEmitter21'

    Begin Object Class=SparkEmitter Name=SparkEmitter2
        LineSegmentsRange=(Min=1.000000,Max=2.000000)
        TimeBeforeVisibleRange=(Min=0.100000,Max=0.500000)
        TimeBetweenSegmentsRange=(Min=0.020000,Max=0.050000)
        UseColorScale=True
        FadeOut=True
        RespawnDeadParticles=False
        AutomaticInitialSpawning=False
        Acceleration=(Z=-450.000000)
        ColorScale(0)=(Color=(B=128,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(R=128,A=255))
        MaxParticles=30

        InitialParticlesPerSecond=500.000000
        Texture=Texture'Effects_Tex.explosions.fire_quad'
        LifetimeRange=(Min=0.200000,Max=0.750000)
        StartVelocityRange=(X=(Min=-50.000000,Max=50.000000),Y=(Min=-55.000000,Max=60.000000),Z=(Min=1.000000,Max=1000.000000))
        VelocityLossRange=(Z=(Min=1.000000,Max=3.000000))
    End Object
    Emitters(7)=SparkEmitter'SparkEmitter2'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter23
        UseColorScale=True
        FadeOut=True
        RespawnDeadParticles=False
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        ColorScale(0)=(Color=(B=192,G=192,R=192,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        Opacity=0.720000
        FadeOutStartTime=0.500000
        MaxParticles=15

        SpinCCWorCW=(X=1.000000)
        SpinsPerSecondRange=(X=(Min=-0.100000,Max=0.100000))
        StartSpinRange=(X=(Min=-0.500000,Max=0.500000))
        SizeScale(0)=(RelativeSize=1.000000)
        SizeScale(1)=(RelativeTime=0.140000,RelativeSize=3.000000)
        SizeScale(2)=(RelativeTime=1.000000,RelativeSize=7.000000)
        StartSizeRange=(X=(Min=5.000000,Max=10.000000))
        InitialParticlesPerSecond=1000.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.explosions.LSmoke1'
        SecondsBeforeInactive=0.000000
        LifetimeRange=(Max=6.000000)
        VelocityLossRange=(Z=(Min=4.000000,Max=6.000000))
    End Object
    Emitters(8)=SpriteEmitter'SpriteEmitter23'
}

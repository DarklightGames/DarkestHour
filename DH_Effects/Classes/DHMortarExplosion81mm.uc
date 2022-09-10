//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHMortarExplosion81mm extends Emitter;

defaultproperties
{
    AutoDestroy=true
    bNoDelete=false

    Begin Object Class=SpriteEmitter Name=SpriteEmitter8
        UseColorScale=True
        FadeOut=True
        RespawnDeadParticles=False
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        Acceleration=(Z=100.000000)
        ColorScale(0)=(Color=(B=75,G=91,R=109,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=180,G=196,R=201,A=255))
        FadeOutStartTime=0.5
        MaxParticles=16
        name="light_puff"
        StartLocationOffset=(Z=-50.000000)
        StartLocationRange=(X=(Min=-200.000000,Max=250.000000),Y=(Min=-200.000000,Max=250.000000))
        SpinCCWorCW=(X=1.000000)
        SpinsPerSecondRange=(X=(Min=-0.100000,Max=0.100000))
        StartSpinRange=(X=(Min=-0.500000,Max=0.500000))
        SizeScale(0)=(RelativeSize=1.000000)
        SizeScale(1)=(RelativeTime=0.140000,RelativeSize=3.000000)
        SizeScale(2)=(RelativeTime=1.000000,RelativeSize=7.000000)
        StartSizeRange=(X=(Min=55.000000,Max=75.000000),Y=(Min=55.000000,Max=75.000000),Z=(Min=25.000000,Max=35.000000))
        InitialParticlesPerSecond=512.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.explosions.LSmoke1'
        SecondsBeforeInactive=0.000000
        LifetimeRange=(Max=6.0)
        InitialDelayRange=(Min=0.100000,Max=0.150000)
        StartVelocityRange=(X=(Min=-150.000000,Max=175.000000),Y=(Min=-150.000000,Max=175.000000),Z=(Min=150.000000,Max=250.000000))
        VelocityLossRange=(Z=(Min=4.000000,Max=6.000000))
    End Object
    Emitters(0)=SpriteEmitter'SpriteEmitter8'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter9
        UseColorScale=True
        FadeOut=True
        FadeIn=True
        RespawnDeadParticles=False
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        Acceleration=(X=50,Z=100.000000)
        ColorScale(0)=(Color=(B=192,G=192,R=192,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        FadeOutStartTime=0.5
        MaxParticles=12
        name="dark_puff"
        StartLocationOffset=(Z=-25.000000)
        StartLocationRange=(X=(Min=-125.000000,Max=135.000000),Y=(Min=-135.000000,Max=125.000000))
        SpinCCWorCW=(X=1.000000)
        SpinsPerSecondRange=(X=(Min=0.05,Max=0.20000))
        StartSpinRange=(X=(Min=-0.500000,Max=0.500000))
        SizeScale(0)=(RelativeSize=1.000000)
        SizeScale(1)=(RelativeTime=0.250000,RelativeSize=3.000000)
        SizeScale(2)=(RelativeTime=1.000000,RelativeSize=7.000000)
        StartSizeRange=(X=(Min=35.000000,Max=55.000000),Y=(Min=35.000000,Max=55.000000),Z=(Min=45.000000,Max=50.000000))
        InitialParticlesPerSecond=100.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.explosions.LSmoke3'
        SecondsBeforeInactive=0.000000
        LifetimeRange=(Min=4.0,Max=6.0)
        InitialDelayRange=(Min=0.15,Max=0.250000)
        StartVelocityRange=(Y=(Min=85.000000,Max=250.000000),Z=(Min=600.000000,Max=1200.000000))
        VelocityLossRange=(Z=(Min=4.000000,Max=4.000000))
    End Object
    Emitters(1)=SpriteEmitter'SpriteEmitter9'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter11
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
        StartLocationRange=(X=(Min=-80.000000,Max=75.000000),Y=(Min=-75.000000,Max=85.000000))
        Opacity=0.920000
        FadeOutStartTime=0.130000
        MaxParticles=1
        name="flash"
        StartLocationOffset=(Z=-100.000000)
        StartSpinRange=(X=(Min=0.500000,Max=0.500000))
        SizeScale(0)=(RelativeSize=0.500000)
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=4.500000)
        StartSizeRange=(X=(Min=35.000000,Max=55.000000),Y=(Min=35.000000,Max=55.000000),Z=(Min=35.000000,Max=55.000000))
        InitialParticlesPerSecond=100.000000
        DrawStyle=PTDS_Brighten
        Texture=Texture'Effects_Tex.Weapons.muzzle_4frame3rd'
        TextureUSubdivisions=2
        TextureVSubdivisions=2
        LifetimeRange=(Min=0.25000,Max=0.350000)
        StartVelocityRange=(Z=(Min=300.000000,Max=600.000000))
    End Object
    Emitters(2)=SpriteEmitter'SpriteEmitter11'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter14
        FadeOut=True
        RespawnDeadParticles=False
        SpinParticles=True
        DampRotation=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        UseRandomSubdivision=True
        Acceleration=(Z=-1200.000000)
        DampingFactorRange=(X=(Min=0.150000,Max=0.250000),Y=(Min=0.150000,Max=0.250000),Z=(Min=0.150000,Max=0.250000))
        ColorScale(0)=(Color=(B=128,G=128,R=128,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=128,G=128,R=128,A=255))
        FadeOutStartTime=1.500000
        MaxParticles=250
        name="dirt_debris"
        SpinsPerSecondRange=(X=(Min=0.100000,Max=0.200000))
        StartSpinRange=(X=(Min=0.500000,Max=0.500000))
        RotationDampingFactorRange=(X=(Min=1.000000,Max=1.000000),Y=(Min=1.000000,Max=1.000000),Z=(Min=1.000000,Max=1.000000))
        SizeScale(0)=(RelativeSize=1.000000)
        StartSizeRange=(X=(Min=1.500000,Max=3.000000),Y=(Min=1.500000,Max=3.000000),Z=(Min=5.000000,Max=8.000000))
        InitialParticlesPerSecond=10000.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.BulletHits.groundchunksfinal'
        TextureUSubdivisions=2
        TextureVSubdivisions=2
        LifetimeRange=(Min=2.250000,Max=3.000000)
        StartVelocityRange=(X=(Min=-350.000000,Max=300.000000),Y=(Min=-350.000000,Max=400.000000),Z=(Min=500.000000,Max=1000.000000))
        VelocityScale(0)=(RelativeVelocity=(X=1.000000,Y=1.000000,Z=1.000000))
        VelocityScale(1)=(RelativeTime=0.475000,RelativeVelocity=(X=0.100000,Y=0.200000,Z=0.200000))
        VelocityScale(2)=(RelativeTime=1.000000)
    End Object
    Emitters(3)=SpriteEmitter'SpriteEmitter14'

    Begin Object Class=SparkEmitter Name=SparkEmitter1
        LineSegmentsRange=(Min=1.000000,Max=2.000000)
        TimeBeforeVisibleRange=(Min=0.100000,Max=0.500000)
        TimeBetweenSegmentsRange=(Min=0.10000,Max=0.150000)
        UseColorScale=True
        FadeOut=True
        RespawnDeadParticles=False
        AutomaticInitialSpawning=False
        Acceleration=(Z=-450.000000)
        ColorScale(0)=(Color=(B=128,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(R=128,A=255))
        FadeOutStartTime=0.150000
        MaxParticles=100
        name="shrap_sparks"
        InitialParticlesPerSecond=1000.000000
        Texture=Texture'Effects_Tex.explosions.fire_quad'
        LifetimeRange=(Min=0.200000,Max=0.750000)
        StartVelocityRange=(X=(Min=-550.000000,Max=500.000000),Y=(Min=-525.000000,Max=600.000000),Z=(Min=50.000000,Max=800.000000))
        VelocityLossRange=(Z=(Min=1.000000,Max=3.000000))
    End Object
    Emitters(4)=SparkEmitter'SparkEmitter1'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter15
        UseCollision=True
        UseDirectionAs=PTDU_UpAndNormal
        ProjectionNormal=(X=1.000000,Y=0.500000)
        UseColorScale=True
        RespawnDeadParticles=False
        SpinParticles=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        UseRandomSubdivision=True
        Acceleration=(X=100.000000,Y=10.000000,Z=-250.000000)
        DampingFactorRange=(X=(Min=0.000000,Max=0.000000),Y=(Min=0.000000,Max=0.000000),Z=(Min=0.000000,Max=0.000000))
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=64,G=128,R=255,A=255))
        ColorScaleRepeats=4.0
        MaxParticles=150
        name="floating_embers"
        StartLocationOffset=(Z=25.000000)
        StartLocationShape=PTLS_Sphere
        SphereRadiusRange=(Min=50.000000,Max=100.000000)
        SpinsPerSecondRange=(X=(Min=0.500000,Max=4.000000))
        StartSpinRange=(X=(Min=-0.500000,Max=1.000000))
        StartSizeRange=(X=(Min=1.500000,Max=3.000000))
        InitialParticlesPerSecond=1000.000000
        Texture=Texture'Effects_Tex.Smoke.Sparks'
        TextureUSubdivisions=2
        TextureVSubdivisions=2
        LifetimeRange=(Min=1.000000,Max=3.000000)
        InitialDelayRange=(Min=0.150000,Max=0.200000)
        StartVelocityRange=(X=(Min=25.000000,Max=150.000000),Y=(Min=35.000000,Max=135.000000),Z=(Min=400.000000,Max=600.000000))
        VelocityLossRange=(Z=(Min=2.000000,Max=3.000000))
    End Object
    Emitters(5)=SpriteEmitter'SpriteEmitter15'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter16
        UseDirectionAs=PTDU_Normal
        UseColorScale=True
        FadeOut=True
        RespawnDeadParticles=False
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        Acceleration=(Z=5.000000)
        ColorScale(0)=(Color=(B=104,G=116,R=121,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=135,G=156,R=165,A=255))
        Opacity=0.6
        FadeOutStartTime=1.500000
        MaxParticles=1
        name="shockwave"
        UseRotationFrom=PTRS_Normal
        RotationNormal=(Z=1.000000)
        SizeScale(1)=(RelativeTime=0.500000,RelativeSize=2.000000)
        SizeScale(2)=(RelativeTime=1.000000,RelativeSize=4.000000)
        StartSizeRange=(X=(Min=400.000000,Max=500.000000),Y=(Min=400.000000,Max=500.000000),Z=(Min=400.000000,Max=500.000000))
        InitialParticlesPerSecond=1000.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.explosions.DSmoke_2'
        LifetimeRange=(Min=2.500000,Max=3.000000)
        StartVelocityRange=(Z=(Min=10.000000,Max=10.000000))
        StartVelocityRadialRange=(Min=100.000000,Max=100.000000)
    End Object
    Emitters(6)=SpriteEmitter'SpriteEmitter16'

    Begin Object Class=BeamEmitter Name=BeamEmitter8
        BeamDistanceRange=(Min=400.000000,Max=800.000000)
        DetermineEndPointBy=PTEP_Distance
        RotatingSheets=1
        UseColorScale=True
        SpinParticles=True
        FadeOut=True
        FadeIn=true
        RespawnDeadParticles=False
        AutoDestroy=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=true
        AutomaticInitialSpawning=False
        ColorScale(0)=(Color=(B=34,G=46,R=51,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=65,G=86,R=95,A=255))
        Opacity=1.0
        FadeOutStartTime=0.450000
        MaxParticles=2
        name="dark_spikes"
        StartLocationOffset=(X=-10.000000)
        SpinsPerSecondRange=(X=(Min=0.05,Max=0.20000))
        StartSpinRange=(X=(Min=-0.500000,Max=0.500000))
        SizeScale(1)=(RelativeSize=0.1)
        SizeScale(2)=(RelativeTime=0.14,RelativeSize=1.0)
        SizeScale(3)=(RelativeTime=1.000000,RelativeSize=3.500000)
        StartSizeRange=(X=(Min=300.000000,Max=350.000000),Y=(Min=300.000000,Max=350.000000),Z=(Min=500.000000))
        InitialParticlesPerSecond=200.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'DH_FX_Tex.Effects.Impact03'
        LifetimeRange=(Min=3.0,Max=4.0)
        InitialDelayRange=(Min=0.15,Max=0.250000)
        StartVelocityRange=(X=(Min=-225,Max=200.000000),Y=(Min=-200.000000,Max=235.000000),Z=(Min=400.000000,Max=800.000000))
    End Object
    Emitters(7)=BeamEmitter'BeamEmitter8'

        Begin Object Class=BeamEmitter Name=BeamEmitter85
        BeamDistanceRange=(Min=350.000000,Max=550.000000)
        DetermineEndPointBy=PTEP_Distance
        RotatingSheets=1
        UseColorScale=True
        SpinParticles=True
        FadeOut=True
        FadeIn=true
        RespawnDeadParticles=False
        AutoDestroy=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=true
        AutomaticInitialSpawning=False
        ColorScale(0)=(Color=(B=75,G=91,R=109,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=180,G=196,R=201,A=255))
        Opacity=0.5
        FadeOutStartTime=0.450000
        MaxParticles=1
        name="lite_spikes"
        StartLocationOffset=(X=-10.000000)
        SpinsPerSecondRange=(X=(Min=0.05,Max=0.20000))
        StartSpinRange=(X=(Min=-0.500000,Max=0.500000))
        SizeScale(1)=(RelativeSize=0.1)
        SizeScale(2)=(RelativeTime=0.14,RelativeSize=1.0)
        SizeScale(3)=(RelativeTime=1.000000,RelativeSize=3.500000)
        StartSizeRange=(X=(Min=250.000000,Max=275.000000),Y=(Min=250.000000,Max=275.000000),Z=(Min=400.000000))
        InitialParticlesPerSecond=200.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'DH_FX_Tex.Effects.Impact02'
        LifetimeRange=(Min=3.0,Max=4.0)
        InitialDelayRange=(Min=0.15,Max=0.250000)
        StartVelocityRange=(X=(Min=-150,Max=145.000000),Y=(Min=-160.000000,Max=155.000000),Z=(Min=400.000000,Max=800.000000))
    End Object
    Emitters(8)=BeamEmitter'BeamEmitter85'
}

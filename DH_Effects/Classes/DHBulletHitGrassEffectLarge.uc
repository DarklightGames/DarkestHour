//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHBulletHitGrassEffectLarge extends emitter;

//Particle count: 48

defaultproperties
{
    Begin Object Class=SpriteEmitter Name=SpriteEmitter9
        UseColorScale=True
        RespawnDeadParticles=False
        SpinParticles=True
        UniformSize=True
        AutomaticInitialSpawning=False
        UseRandomSubdivision=True
        Acceleration=(X=30.000000,Y=40.000000,Z=-500.000000)
        ColorScale(0)=(Color=(B=30,G=79,R=71,A=255))
        ColorScale(1)=(RelativeTime=0.485714,Color=(B=107,G=148,R=123,A=255))
        ColorScale(2)=(RelativeTime=1.000000,Color=(B=30,G=79,R=71,A=255))
        ColorScaleRepeats=2.000000
        MaxParticles=15 // 25
        Name="grass_high"
        StartLocationShape=PTLS_Sphere
        SphereRadiusRange=(Min=2.000000,Max=5.000000)
        UseRotationFrom=PTRS_Actor
        SpinsPerSecondRange=(X=(Min=0.750000,Max=3.000000))
        StartSpinRange=(X=(Min=0.500000,Max=1.000000))
        StartSizeRange=(X=(Min=1.000000,Max=5.00000))
        InitialParticlesPerSecond=10000.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'DH_FX_Tex.Effects.GrassDebris'
        TextureUSubdivisions=2
        TextureVSubdivisions=2
        LifetimeRange=(Min=1.000000,Max=3.000000)
        StartVelocityRange=(X=(Min=150.000000,Max=400.000000),Y=(Min=-85.000000,Max=95.000000),Z=(Min=-95.000000,Max=75.000000))
    End Object
    Emitters(0)=SpriteEmitter'SpriteEmitter9'

    Begin Object Class=BeamEmitter Name=BeamEmitter0
        BeamDistanceRange=(Min=85.000000,Max=175.000000)
        DetermineEndPointBy=PTEP_Distance
        RotatingSheets=1
        UseColorScale=True
        FadeOut=True
        RespawnDeadParticles=False
        AutoDestroy=True
        AutomaticInitialSpawning=False
        UseRandomSubdivision=True
        ColorScale(0)=(Color=(B=122,G=155,R=175,A=255))
        ColorScale(1)=(Color=(B=65,G=86,R=95,A=255))
        ColorScale(2)=(RelativeTime=1.000000,Color=(B=87,G=109,R=130,A=255))
        FadeOutStartTime=0.150000
        MaxParticles=2
        Name="lite_impact"
        StartLocationOffset=(X=-10.000000)
        UseRotationFrom=PTRS_Actor
        StartSizeRange=(X=(Min=45.000000,Max=55.000000),Y=(Min=45.000000,Max=55.000000),Z=(Min=85.000000))
        InitialParticlesPerSecond=200.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'DH_FX_Tex.Effects.Impact03'
        LifetimeRange=(Min=0.200000,Max=0.6000000)
        StartVelocityRange=(X=(Min=300.000000,Max=600.000000),Y=(Min=-115.000000,Max=125.000000),Z=(Min=-125.000000,Max=115.000000))
    End Object
    Emitters(1)=BeamEmitter'BeamEmitter0'

    Begin Object Class=BeamEmitter Name=BeamEmitter6
        BeamDistanceRange=(Min=85.000000,Max=185.000000)
        DetermineEndPointBy=PTEP_Distance
        RotatingSheets=1
        UseColorScale=True
        FadeOut=True
        RespawnDeadParticles=False
        AutoDestroy=True
        AutomaticInitialSpawning=False
        UseRandomSubdivision=True
        ColorScale(0)=(Color=(B=44,G=56,R=61,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=65,G=86,R=95,A=255))
        FadeOutStartTime=0.150000
        MaxParticles=2
        Name="dark_impact"
        StartLocationOffset=(X=-10.000000)
        UseRotationFrom=PTRS_Actor
        StartSizeRange=(X=(Min=45.000000,Max=55.000000),Y=(Min=45.000000,Max=55.000000),Z=(Min=85.000000))
        InitialParticlesPerSecond=200.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'DH_FX_Tex.Effects.Impact03'
        LifetimeRange=(Min=0.200000,Max=0.60000)
        StartVelocityRange=(X=(Min=300.000000,Max=600.000000),Y=(Min=-125.000000,Max=115.000000),Z=(Min=-115.000000,Max=125.000000))
    End Object
    Emitters(2)=BeamEmitter'BeamEmitter6'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter10
        UseColorScale=True
        FadeOut=True
        RespawnDeadParticles=False
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        //ColorScale(0)=(Color=(B=30,G=79,R=71,A=255))
        //ColorScale(1)=(RelativeTime=1.000000,Color=(B=120,G=167,R=175,A=255))
        ColorScale(0)=(Color=(B=115,G=136,R=145,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=115,G=136,R=145,A=255))
        FadeOutStartTime=0.10000
        MaxParticles=8
        Name="base_puff"
        StartLocationRange=(X=(Min=-5.000000,Max=10.000000))
        UseRotationFrom=PTRS_Actor
        SpinsPerSecondRange=(X=(Min=0.100000,Max=0.150000))
        SizeScale(0)=(RelativeSize=0.500000)
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=3.000000)
        StartSizeRange=(X=(Min=20.000000,Max=35.000000))
        InitialParticlesPerSecond=500.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.explosions.DSmoke_2'
        LifetimeRange=(Min=0.150000,Max=1.500000)
        StartVelocityRange=(X=(Min=5.000000,Max=75.000000),Y=(Min=-35.000000,Max=40.000000),Z=(Min=-35.000000,Max=40.000000))
    End Object
    Emitters(3)=SpriteEmitter'SpriteEmitter10'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter11
        UseDirectionAs=PTDU_UpAndNormal
        ProjectionNormal=(X=1.000000,Y=0.500000)
        UseColorScale=True
        RespawnDeadParticles=False
        SpinParticles=True
        UniformSize=True
        AutomaticInitialSpawning=False
        UseRandomSubdivision=True
        Acceleration=(X=30.000000,Y=10.000000,Z=-450.000000)
        ColorScale(0)=(Color=(B=34,G=68,R=60,A=255))
        ColorScale(1)=(RelativeTime=0.485714,Color=(B=98,G=157,R=131,A=255))
        ColorScale(2)=(RelativeTime=1.000000,Color=(B=30,G=68,R=60,A=255))
        ColorScaleRepeats=2.000000
        MaxParticles=12
        Name="green_bits"
        StartLocationShape=PTLS_Sphere
        SphereRadiusRange=(Min=5.000000,Max=10.000000)
        UseRotationFrom=PTRS_Actor
        SpinsPerSecondRange=(X=(Min=0.750000,Max=3.000000))
        StartSpinRange=(X=(Min=0.500000,Max=1.000000))
        StartSizeRange=(X=(Min=1.500000,Max=3.000000))
        InitialParticlesPerSecond=10000.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.BulletHits.snowchunksfinal'
        TextureUSubdivisions=2
        TextureVSubdivisions=2
        LifetimeRange=(Min=1.000000,Max=3.000000)
        StartVelocityRange=(X=(Min=150.000000,Max=400.000000),Y=(Min=-50.000000,Max=45.000000),Z=(Min=-45.000000,Max=50.000000))
    End Object
    Emitters(4)=SpriteEmitter'SpriteEmitter11'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter3
        UseColorScale=True
        FadeOut=True
        FadeIn=True
        RespawnDeadParticles=False
        SpinParticles=True
        AutoDestroy=true
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        Acceleration=(X=20.000000,Y=50.000000)
        ColorScale(0)=(Color=(B=115,G=136,R=145,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=115,G=136,R=145,A=255))
        Opacity=0.5
        FadeOutStartTime=0.2500000
        FadeInEndTime=0.1
        MaxParticles=4
        Name="dust_cloud"
        StartLocationOffset=(Z=-25.000000)
        UseRotationFrom=PTRS_Actor
        StartLocationRange=(X=(Min=-10.000000,Max=10.000000),Y=(Min=-10.000000,Max=10.000000))
        RotationOffset=(Pitch=728,Yaw=4733,Roll=13107)
        SpinCCWorCW=(Y=1.000000,Z=1.000000)
        SpinsPerSecondRange=(X=(Min=0.025000,Max=0.050000),Y=(Max=0.100000),Z=(Min=1.000000,Max=1.000000))
        StartSpinRange=(X=(Min=-0.500000,Max=0.500000),Y=(Min=16000.000000,Max=20000.000000),Z=(Min=9000.000000,Max=12000.000000))
        SizeScale(1)=(RelativeTime=1.00,RelativeSize=3.000000)
        StartSizeRange=(X=(Min=35.000000,Max=55.000000))
        InitialParticlesPerSecond=50.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.explosions.LSmoke1'
        LifetimeRange=(Min=1.000000,Max=1.500000)
        StartVelocityRange=(X=(Min=25.000000,Max=75.000000),Y=(Min=-100.000000,Max=100.000000),Z=(Min=-20.0,Max=20.000000))
    End Object
    Emitters(5)=SpriteEmitter'SpriteEmitter3'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter45
        UseCollision=True
        UseMaxCollisions=True
        UseColorScale=True
        FadeOut=True
        RespawnDeadParticles=False
        SpinParticles=True
        DampRotation=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        Acceleration=(Y=20.000000,Z=-800.000000)
        ExtentMultiplier=(X=0.000000,Y=0.000000,Z=0.000000)
        DampingFactorRange=(X=(Min=0.150000,Max=0.250000),Y=(Min=0.150000,Max=0.250000),Z=(Min=0.150000,Max=0.250000))
        ColorScale(0)=(Color=(B=52,G=64,R=69,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=69,G=86,R=95,A=255))
        MaxParticles=5
        FadeOutStartTime=0.15
        Name="random_chunks"
        UseRotationFrom=PTRS_Actor
        SpinsPerSecondRange=(X=(Min=0.100000,Max=0.250000))
        StartSpinRange=(X=(Min=0.500000,Max=0.500000))
        RotationDampingFactorRange=(X=(Min=1.000000,Max=1.000000),Y=(Min=1.000000,Max=1.000000),Z=(Min=1.000000,Max=1.000000))
        SizeScale(0)=(RelativeSize=0.700000)
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=3.000000)
        StartSizeRange=(X=(Min=5.000000,Max=15.000000))
        InitialParticlesPerSecond=100.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'DH_FX_Tex.debris.genericchunkssparse'
        LifetimeRange=(Min=0.550000,Max=0.950000)
        StartVelocityRange=(X=(Min=250.000000,Max=350.000000),Y=(Min=-100.000000,Max=75.000000),Z=(Min=-80.000000,Max=125.000000))
        VelocityScale(0)=(RelativeVelocity=(X=1.000000,Y=1.000000,Z=1.000000))
        VelocityScale(1)=(RelativeTime=0.475000,RelativeVelocity=(X=0.100000,Y=0.200000,Z=0.200000))
        VelocityScale(2)=(RelativeTime=1.000000)
    End Object
    Emitters(6)=SpriteEmitter'SpriteEmitter45'

    Autodestroy=true
    bnodelete=false
}

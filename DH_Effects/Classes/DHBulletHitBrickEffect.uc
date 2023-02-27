//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHBulletHitBrickEffect extends emitter;

defaultproperties
{
    Begin Object Class=SpriteEmitter Name=SpriteEmitter1
        UseColorScale=True
        FadeOut=True
        RespawnDeadParticles=False
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        UseRandomSubdivision=True
        UseVelocityScale=True
        Acceleration=(Y=20.000000)
        ColorScale(0)=(Color=(B=51,G=72,R=134,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        FadeOutStartTime=0.500000
        MaxParticles=4
        Name="dust_up1"
        UseRotationFrom=PTRS_Actor
        SpinsPerSecondRange=(X=(Min=0.150000,Max=0.150000))
        SizeScale(0)=(RelativeSize=0.500000)
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=1.000000)
        StartSizeRange=(X=(Min=15.000000,Max=25.000000))
        InitialParticlesPerSecond=1000.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.BulletHits.stonesmokefinal'
        TextureUSubdivisions=2
        TextureVSubdivisions=2
        LifetimeRange=(Min=1.500000,Max=2.000000)
        StartVelocityRange=(X=(Min=75.000000,Max=150.000000),Y=(Min=-75.000000),Z=(Min=-75.000000))
        VelocityScale(0)=(RelativeVelocity=(X=1.000000,Y=1.000000,Z=1.000000))
        VelocityScale(1)=(RelativeTime=0.475000,RelativeVelocity=(X=0.100000,Y=0.200000,Z=0.200000))
        VelocityScale(2)=(RelativeTime=1.000000)
    End Object
    Emitters(0)=SpriteEmitter'SpriteEmitter1'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter2
        UseColorScale=True
        FadeOut=True
        RespawnDeadParticles=False
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        BlendBetweenSubdivisions=True
        UseRandomSubdivision=True
        UseVelocityScale=True
        ColorScale(0)=(Color=(B=51,G=72,R=134,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        FadeOutStartTime=0.500000
        MaxParticles=3
        Name="dust_up2"
        UseRotationFrom=PTRS_Actor
        SpinsPerSecondRange=(X=(Min=0.050000,Max=0.050000))
        SizeScale(0)=(RelativeSize=0.500000)
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=1.000000)
        StartSizeRange=(X=(Min=30.000000,Max=40.000000))
        InitialParticlesPerSecond=1000.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.BulletHits.stonesmokefinal'
        TextureUSubdivisions=2
        TextureVSubdivisions=2
        LifetimeRange=(Min=1.500000,Max=2.000000)
        StartVelocityRange=(X=(Min=50.000000,Max=150.000000),Y=(Max=125.000000),Z=(Max=125.000000))
        VelocityScale(0)=(RelativeVelocity=(X=1.000000,Y=1.000000,Z=1.000000))
        VelocityScale(1)=(RelativeTime=0.475000,RelativeVelocity=(X=0.100000,Y=0.200000,Z=0.200000))
        VelocityScale(2)=(RelativeTime=1.000000)
    End Object
    Emitters(1)=SpriteEmitter'SpriteEmitter2'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter3
        UseColorScale=True
        FadeOut=True
        RespawnDeadParticles=False
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        BlendBetweenSubdivisions=True
        UseRandomSubdivision=True
        UseVelocityScale=True
        ColorScale(0)=(Color=(B=51,G=72,R=134,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        FadeOutStartTime=0.500000
        MaxParticles=3
        Name="side_dust"
        UseRotationFrom=PTRS_Actor
        SpinsPerSecondRange=(X=(Min=0.150000,Max=0.150000))
        SizeScale(0)=(RelativeSize=0.500000)
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=2.000000)
        StartSizeRange=(X=(Min=10.000000,Max=15.000000))
        InitialParticlesPerSecond=100.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.BulletHits.stonesmokefinal'
        TextureUSubdivisions=2
        TextureVSubdivisions=2
        LifetimeRange=(Min=1.250000,Max=1.500000)
        StartVelocityRange=(X=(Min=5.000000,Max=10.000000),Y=(Min=-100.000000,Max=100.000000),Z=(Min=-100.000000,Max=100.000000))
        VelocityScale(0)=(RelativeVelocity=(X=1.000000,Y=1.000000,Z=1.000000))
        VelocityScale(1)=(RelativeTime=0.475000,RelativeVelocity=(X=0.100000,Y=0.200000,Z=0.200000))
        VelocityScale(2)=(RelativeTime=1.000000)
    End Object
    Emitters(2)=SpriteEmitter'SpriteEmitter3'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter4
        UseCollision=True
        UseMaxCollisions=True
        UseColorScale=True
        FadeOut=True
        FadeIn=True
        RespawnDeadParticles=False
        SpinParticles=True
        DampRotation=True
        UniformSize=True
        AutomaticInitialSpawning=False
        UseRandomSubdivision=True
        Acceleration=(Z=-1000.000000)
        DampingFactorRange=(X=(Min=0.150000,Max=0.250000),Y=(Min=0.150000,Max=0.250000),Z=(Min=0.150000,Max=0.250000))
        MaxCollisions=(Min=1.000000,Max=1.000000)
        ColorScale(0)=(Color=(B=4,G=47,R=147,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=4,G=47,R=147,A=255))
        FadeOutStartTime=0.500000
        MaxParticles=25
        Name="brick_chunks"
        UseRotationFrom=PTRS_Actor
        SpinsPerSecondRange=(X=(Min=0.250000,Max=0.350000))
        StartSpinRange=(X=(Min=0.500000,Max=0.500000))
        RotationDampingFactorRange=(X=(Min=1.000000,Max=1.000000),Y=(Min=1.000000,Max=1.000000),Z=(Min=1.000000,Max=1.000000))
        StartSizeRange=(X=(Min=0.500000,Max=2.000000))
        InitialParticlesPerSecond=10000.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.BulletHits.concrete_chunks'
        TextureUSubdivisions=4
        TextureVSubdivisions=4
        LifetimeRange=(Max=1.500000)
        StartVelocityRange=(X=(Min=50.000000,Max=500.000000),Y=(Min=-150.000000,Max=175.000000),Z=(Min=-150.000000,Max=175.000000))
    End Object
    Emitters(3)=SpriteEmitter'SpriteEmitter4'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter5
        UseColorScale=True
        FadeOut=True
        RespawnDeadParticles=False
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        ColorScale(0)=(Color=(B=51,G=72,R=134,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        Opacity=0.7
        FadeOutStartTime=0.100000
        MaxParticles=2
        Name="point_puff"
        StartSpinRange=(X=(Min=0.500000,Max=0.500000))
        SizeScale(0)=(RelativeSize=0.500000)
        SizeScale(1)=(RelativeTime=0.250000,RelativeSize=1.000000)
        SizeScale(2)=(RelativeTime=1.000000,RelativeSize=2.000000)
        StartSizeRange=(X=(Min=20.000000,Max=25.000000),Y=(Min=20.000000,Max=25.000000),Z=(Min=20.000000,Max=30.000000))
        InitialParticlesPerSecond=1000.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.explosions.radialexplosion_1frame'
        LifetimeRange=(Min=0.150000,Max=0.250000)
    End Object
    Emitters(4)=SpriteEmitter'SpriteEmitter5'

    Begin Object Class=SparkEmitter Name=SparkEmitter2
        LineSegmentsRange=(Min=0.000000,Max=0.000000)
        TimeBetweenSegmentsRange=(Min=0.030000,Max=0.075000)
        FadeOut=True
        RespawnDeadParticles=False
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        Acceleration=(Z=-250.000000)
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        FadeOutStartTime=0.150000
        MaxParticles=15
        Name="sparks"
        SizeScale(0)=(RelativeSize=1.000000)
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=0.25)
        InitialParticlesPerSecond=1000.000000
        UseRotationFrom=PTRS_Actor
        Texture=Texture'Effects_Tex.explosions.fire_quad'
        LifetimeRange=(Min=0.20,Max=0.35)
        StartVelocityRange=(X=(Min=20.000000,Max=100.000000),Y=(Min=-12.000000,Max=20.000000),Z=(Min=-20.000000,Max=15.000000))
    End Object
    Emitters(5)=SparkEmitter'SparkEmitter2'

    Begin Object Class=BeamEmitter Name=BeamEmitter1
        BeamDistanceRange=(Min=40.000000,Max=50.000000)
        DetermineEndPointBy=PTEP_Distance
        RotatingSheets=1
        UseColorScale=True
        RespawnDeadParticles=False
        AutoDestroy=True
        AutomaticInitialSpawning=False
        ColorScale(0)=(Color=(B=51,G=72,R=134,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=51,G=72,R=134,A=255))
        StartLocationOffset=(X=-5.000000)
        Opacity=0.35
        MaxParticles=3
        Name="impact"
        UseRotationFrom=PTRS_Actor
        StartSizeRange=(X=(Min=10.000000,Max=20.000000),Y=(Min=10.000000,Max=20.000000),Z=(Min=25.000000,Max=40.000000))
        InitialParticlesPerSecond=200.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'DH_FX_Tex.Effects.Impact01'
        LifetimeRange=(Min=0.100000,Max=0.20000)
        StartVelocityRange=(X=(Min=100.000000,Max=200.000000),Y=(Min=-20.000000,Max=20.000000),Z=(Min=-20.000000,Max=20.000000))
    End Object
    Emitters(6)=BeamEmitter'BeamEmitter1'

    Autodestroy=true
    bnodelete=false
}

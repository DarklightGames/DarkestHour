//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHBulletHitBrickEffectLarge extends Emitter;

//particles: 34

defaultproperties
{
    Begin Object Class=SpriteEmitter Name=SpriteEmitter0
        RespawnDeadParticles=False
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        MaxParticles=1
        SizeScale(0)=(RelativeSize=0.100000)
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=1.000000)
        StartSizeRange=(X=(Min=8.000000,Max=12.000000))
        InitialParticlesPerSecond=500.000000
        DrawStyle=PTDS_Brighten
        Texture=Texture'Effects_Tex.muzzle_4frame3rd'
        TextureUSubdivisions=2
        TextureVSubdivisions=2
        LifetimeRange=(Min=0.100000,Max=0.100000)
    End Object
    Emitters(0)=SpriteEmitter'SpriteEmitter0'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter1
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
        Opacity=0.5
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
        Texture=Texture'Effects_Tex.radialexplosion_1frame'
        LifetimeRange=(Min=0.150000,Max=0.250000)
    End Object
    Emitters(1)=SpriteEmitter'SpriteEmitter1'

    Begin Object Class=SparkEmitter Name=SparkEmitter0
        LineSegmentsRange=(Min=0.000000,Max=0.000000)
        TimeBetweenSegmentsRange=(Min=0.030000,Max=0.075000)
        FadeOut=True
        RespawnDeadParticles=False
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        //Acceleration=(Z=-250.000000)
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        FadeOutStartTime=0.150000
        MaxParticles=8 // 15
        Name="sparks"
        StartLocationOffset=(X=5.000000)
        SizeScale(0)=(RelativeSize=2.000000)
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=0.50)
        InitialParticlesPerSecond=1000.000000
        UseRotationFrom=PTRS_Actor
        Texture=Texture'Effects_Tex.fire_quad'
        LifetimeRange=(Min=0.20,Max=0.35)
        StartVelocityRange=(X=(Min=40.000000,Max=175.000000),Y=(Min=-25.000000,Max=40.000000),Z=(Min=-40.000000,Max=35.000000))
    End Object
    Emitters(2)=SparkEmitter'SparkEmitter0'

    Begin Object Class=MeshEmitter Name=MeshEmitter0
        FadeOut=true
        StaticMesh=StaticMesh'DH_Landscape.brick_single_damaged'
        UseCollision=True
        RespawnDeadParticles=False
        SpinParticles=True
        DampRotation=True
        UniformSize=True
        AutomaticInitialSpawning=False
        Acceleration=(Z=-750.000000)
        DampingFactorRange=(X=(Min=0.200000,Max=0.500000),Y=(Min=0.200000,Max=0.500000),Z=(Min=0.200000,Max=0.500000))
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        FadeOutStartTime=0.5
        MaxParticles=5
        Name="main_chunks"
        UseRotationFrom=PTRS_Actor
        SpinsPerSecondRange=(X=(Min=-1.000000,Max=1.000000),Y=(Min=-1.000000,Max=1.000000),Z=(Min=-1.000000,Max=1.000000))
        StartSpinRange=(X=(Min=-1.000000,Max=1.000000),Y=(Min=-1.000000,Max=1.000000),Z=(Min=-1.000000,Max=1.000000))
        StartSizeRange=(X=(Min=0.2,Max=0.4),Y=(Min=0.2,Max=0.4),Z=(Min=0.2,Max=0.4))
        InitialParticlesPerSecond=2000.000000
        LifetimeRange=(Min=1.0,Max=2.0)
        StartVelocityRange=(X=(Min=150.000000,Max=700.000000),Y=(Min=-125.000000,Max=135.000000),Z=(Min=-135.000000,Max=125.000000))
        VelocityLossRange=(Z=(Min=1.000000,Max=1.000000))
    End Object
    Emitters(3)=MeshEmitter'MeshEmitter0'

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
        Texture=Texture'Effects_Tex.stonesmokefinal'
        TextureUSubdivisions=2
        TextureVSubdivisions=2
        LifetimeRange=(Min=1.250000,Max=1.500000)
        StartVelocityRange=(X=(Min=5.000000,Max=10.000000),Y=(Min=-100.000000,Max=100.000000),Z=(Min=-100.000000,Max=100.000000))
        VelocityScale(0)=(RelativeVelocity=(X=1.000000,Y=1.000000,Z=1.000000))
        VelocityScale(1)=(RelativeTime=0.475000,RelativeVelocity=(X=0.100000,Y=0.200000,Z=0.200000))
        VelocityScale(2)=(RelativeTime=1.000000)
    End Object
    Emitters(4)=SpriteEmitter'SpriteEmitter3'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter4
        FadeOut=true
        UseColorScale=True
        RespawnDeadParticles=False
        SpinParticles=True
        DampRotation=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        Acceleration=(Y=20.0,Z=-800.000000)
        ColorScale(0)=(Color=(B=51,G=72,R=134,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=51,G=72,R=134,A=255))
        FadeOutStartTime=0.2
        MaxParticles=6 //15
        Name="fine_grains"
        StartLocationOffset=(X=10.000000)
        UseRotationFrom=PTRS_Actor
        SpinsPerSecondRange=(X=(Min=0.100000,Max=0.250000))
        StartSpinRange=(X=(Min=0.500000,Max=0.500000))
        RotationDampingFactorRange=(X=(Min=1.000000,Max=1.000000),Y=(Min=1.000000,Max=1.000000),Z=(Min=1.000000,Max=1.000000))
        SizeScale(0)=(RelativeSize=0.100000)
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=4.000000)
        StartSizeRange=(X=(Min=5.000000,Max=12.000000))
        InitialParticlesPerSecond=600.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'DH_FX_Tex.chunksparselite'
        LifetimeRange=(Min=0.50000,Max=0.75000)
        StartVelocityRange=(X=(Min=100.000000,Max=300.000000),Y=(Min=-100.000000,Max=75.000000),Z=(Min=-80.000000,Max=125.000000))
        VelocityScale(0)=(RelativeVelocity=(X=1.000000,Y=1.000000,Z=1.000000))
        VelocityScale(1)=(RelativeTime=0.475000,RelativeVelocity=(X=0.100000,Y=0.200000,Z=0.200000))
        VelocityScale(2)=(RelativeTime=1.000000)
    End Object
    Emitters(5)=SpriteEmitter'SpriteEmitter4'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter5
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
        Acceleration=(Y=-50.000000,Z=-200.000000)
        ColorScale(0)=(Color=(B=51,G=72,R=134,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        FadeOutStartTime=0.250000
        MaxParticles=4
        Name="heavy_dust"
        StartLocationRange=(X=(Min=-10.000000),Y=(Min=-5.000000,Max=5.000000),Z=(Min=-5.000000,Max=5.000000))
        UseRotationFrom=PTRS_Actor
        SpinsPerSecondRange=(X=(Min=0.150000,Max=0.250000))
        StartSpinRange=(X=(Min=0.500000,Max=0.500000))
        SizeScale(0)=(RelativeSize=0.100000)
        SizeScale(1)=(RelativeTime=0.140000,RelativeSize=2.000000)
        SizeScale(2)=(RelativeTime=1.000000,RelativeSize=6.0000)
        StartSizeRange=(X=(Min=15.000000,Max=25.000000))
        InitialParticlesPerSecond=20.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.stonesmokefinal'
        TextureUSubdivisions=2
        TextureVSubdivisions=2//Texture=Texture'DH_FX_Tex.Impact03'
        LifetimeRange=(Min=2.000000,Max=3.000000)
        StartVelocityRange=(X=(Min=150.000000,Max=350.000000),Y=(Min=-35.000000,Max=45.000000),Z=(Min=-45.000000,Max=35.000000))
        VelocityScale(0)=(RelativeVelocity=(X=1.000000,Y=1.000000,Z=1.000000))
        VelocityScale(1)=(RelativeTime=0.475000,RelativeVelocity=(X=0.100000,Y=0.200000,Z=0.200000))
        VelocityScale(2)=(RelativeTime=1.000000)
    End Object
    Emitters(6)=SpriteEmitter'SpriteEmitter5'

    Begin Object Class=BeamEmitter Name=BeamEmitter8
        BeamDistanceRange=(Min=85.000000,Max=160.000000)
        DetermineEndPointBy=PTEP_Distance
        RotatingSheets=1
        UseColorScale=True
        FadeOut=True
        RespawnDeadParticles=False
        AutoDestroy=True
        AutomaticInitialSpawning=False
        UseRandomSubdivision=True
        ColorScale(0)=(Color=(B=51,G=72,R=134,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=51,G=72,R=134,A=255))
        FadeOutStartTime=0.150000
        MaxParticles=2
        Name="dark_spike"
        StartLocationOffset=(X=-10.000000)
        UseRotationFrom=PTRS_Actor
        StartSizeRange=(X=(Min=45.000000,Max=55.000000),Y=(Min=45.000000,Max=55.000000),Z=(Min=85.000000))
        InitialParticlesPerSecond=200.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'DH_FX_Tex.Impact03'
        LifetimeRange=(Min=0.200000,Max=0.400000)
        StartVelocityRange=(X=(Min=300.000000,Max=600.000000),Y=(Min=-175.000000,Max=185.000000),Z=(Min=-185.000000,Max=175.000000))
    End Object
    Emitters(7)=BeamEmitter'BeamEmitter8'

    Autodestroy=true
    bnodelete=false
}

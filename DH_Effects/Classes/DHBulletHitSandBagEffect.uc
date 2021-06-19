//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2021
//==============================================================================

class DHBulletHitSandBagEffect extends emitter;

defaultproperties
{
    Begin Object Class=SpriteEmitter Name=SpriteEmitter10
        RespawnDeadParticles=False
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        Opacity=0.75
        MaxParticles=1
        name="flash"
        SizeScale(0)=(RelativeSize=0.100000)
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=1.000000)
        StartSizeRange=(X=(Min=6.000000,Max=9.000000))
        InitialParticlesPerSecond=500.000000
        DrawStyle=PTDS_Brighten
        Texture=Texture'Effects_Tex.Weapons.muzzle_4frame3rd'
        TextureUSubdivisions=2
        TextureVSubdivisions=2
        LifetimeRange=(Min=0.150000,Max=0.200000)
    End Object
    Emitters(0)=SpriteEmitter'SpriteEmitter10'

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
        ColorScale(0)=(Color=(B=189,G=215,R=223,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=115,G=136,R=145,A=255))
        FadeOutStartTime=1.0
        MaxParticles=5
        name="dust_cloud"
        UseRotationFrom=PTRS_Actor
        SpinsPerSecondRange=(X=(Min=0.050000,Max=0.150000))
        SizeScale(0)=(RelativeSize=0.500000)
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=1.000000)
        StartSizeRange=(X=(Min=40.000000,Max=50.000000))
        InitialParticlesPerSecond=100.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.BulletHits.stonesmokefinal'
        TextureUSubdivisions=2
        TextureVSubdivisions=2
        LifetimeRange=(Min=1.500000,Max=2.000000)
        StartVelocityRange=(X=(Min=75.000000,Max=200.000000),Y=(Min=-25.000000,Max=25.000000),Z=(Min=-25.000000,Max=25.000000))
        VelocityScale(0)=(RelativeVelocity=(X=1.000000,Y=1.000000,Z=1.000000))
        VelocityScale(1)=(RelativeTime=0.475000,RelativeVelocity=(X=0.100000,Y=0.200000,Z=0.200000))
        VelocityScale(2)=(RelativeTime=1.000000)
    End Object
    Emitters(1)=SpriteEmitter'SpriteEmitter2'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter1
        UseCollision=True
        UseMaxCollisions=True
        UseColorScale=True
        FadeOut=True
        RespawnDeadParticles=False
        SpinParticles=True
        DampRotation=True
        UniformSize=True
        AutomaticInitialSpawning=False
        UseRandomSubdivision=True
        Acceleration=(Z=-300.000000)
        DampingFactorRange=(X=(Min=0.150000,Max=0.250000),Y=(Min=0.150000,Max=0.250000),Z=(Min=0.150000,Max=0.250000))
        MaxCollisions=(Min=1.000000,Max=1.000000)
        ColorScale(0)=(Color=(B=128,G=178,R=194,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=128,G=174,R=190,A=255))
        FadeOutStartTime=0.500000
        MaxParticles=300
        name="side_chunks"
        SphereRadiusRange=(Min=2.000000,Max=5.000000)
        UseRotationFrom=PTRS_Actor
        SpinsPerSecondRange=(X=(Min=0.100000,Max=0.200000))
        StartSpinRange=(X=(Min=0.500000,Max=0.500000))
        RotationDampingFactorRange=(X=(Min=1.000000,Max=1.000000),Y=(Min=1.000000,Max=1.000000),Z=(Min=1.000000,Max=1.000000))
        StartSizeRange=(X=(Min=0.500000,Max=1.000000))
        InitialParticlesPerSecond=10000.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.BulletHits.snowchunksfinal'
        TextureUSubdivisions=2
        TextureVSubdivisions=2
        LifetimeRange=(Min=0.500000,Max=1.000000)
        StartVelocityRange=(X=(Min=25.000000,Max=35.000000),Y=(Min=-100.000000,Max=150.000000),Z=(Min=-100.000000,Max=150.000000))
    End Object
    Emitters(2)=SpriteEmitter'SpriteEmitter1'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter13
        UseColorScale=True
        RespawnDeadParticles=False
        SpinParticles=True
        UniformSize=True
        AutomaticInitialSpawning=False
        UseRandomSubdivision=True
        Acceleration=(X=30.000000,Y=10.000000,Z=-250.000000)
        ColorScale(0)=(Color=(B=121,G=157,R=174,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=121,G=157,R=174,A=255))
        MaxParticles=20
        name="light_shreds"
        StartLocationShape=PTLS_Sphere
        SphereRadiusRange=(Min=10.000000,Max=20.000000)
        UseRotationFrom=PTRS_Actor
        SpinsPerSecondRange=(X=(Min=0.750000,Max=3.000000))
        StartSpinRange=(X=(Min=0.500000,Max=1.000000))
        StartSizeRange=(X=(Min=0.750000,Max=1.500000))
        InitialParticlesPerSecond=100.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.BulletHits.paperchunks'
        TextureUSubdivisions=4
        TextureVSubdivisions=4
        LifetimeRange=(Min=1.000000,Max=3.000000)
        StartVelocityRange=(X=(Min=50.000000,Max=150.000000),Y=(Min=-15.000000,Max=20.000000),Z=(Min=-25.000000,Max=15.000000))
    End Object
    Emitters(3)=SpriteEmitter'SpriteEmitter13'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter14
        UseCollision=True
        UseColorScale=True
        RespawnDeadParticles=False
        UniformSize=True
        AutomaticInitialSpawning=False
        UseRandomSubdivision=True
        DampingFactorRange=(X=(Min=0.000000,Max=0.000000),Y=(Min=0.000000,Max=0.000000),Z=(Min=0.000000,Max=0.000000))
        ColorScale(0)=(Color=(B=128,G=128,R=128,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=128,G=128,R=128,A=255))
        MaxParticles=4
        UseRotationFrom=PTRS_Actor
        StartSizeRange=(X=(Min=3.000000,Max=4.000000))
        InitialParticlesPerSecond=10000.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.BulletHits.paperchunks'
        TextureUSubdivisions=4
        TextureVSubdivisions=4
        LifetimeRange=(Min=2.0,Max=3.000000)
    End Object
    Emitters(4)=SpriteEmitter'SpriteEmitter14'

   Begin Object Class=BeamEmitter Name=BeamEmitter2
        BeamDistanceRange=(Min=45.000000,Max=85.000000)
        DetermineEndPointBy=PTEP_Distance
        RotatingSheets=1
        UseColorScale=True
        FadeOut=True
        RespawnDeadParticles=False
        AutoDestroy=True
        UseSizeScale=True
        UseRegularSizeScale=False
        AutomaticInitialSpawning=False
        Acceleration=(X=100.000000)
        ColorScale(0)=(Color=(B=189,G=215,R=223,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=115,G=136,R=145,A=255))
        Opacity=0.45
        FadeOutStartTime=0.200000
        MaxParticles=2
        name="litedust"
        StartLocationOffset=(X=-20.000000)
        UseRotationFrom=PTRS_Actor
        SizeScale(0)=(RelativeSize=1.000000)
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=2.500000)
        StartSizeRange=(X=(Min=15.000000,Max=25.000000),Y=(Min=15.000000,Max=25.000000),Z=(Min=45.000000))
        InitialParticlesPerSecond=200.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'DH_FX_Tex.Effects.Impact01'
        LifetimeRange=(Min=0.700000,Max=0.900000)
        StartVelocityRange=(X=(Min=350.000000,Max=600.000000),Y=(Min=-200.000000,Max=225.000000),Z=(Min=-200.000000,Max=225.000000))
    End Object
    Emitters(5)=BeamEmitter'BeamEmitter2'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter88
        UseColorScale=True
        FadeOut=True
        RespawnDeadParticles=False
        SpinParticles=True
        DampRotation=True
        UniformSize=True
        UseSizeScale=true
        AutomaticInitialSpawning=False
        UseRandomSubdivision=True
        Acceleration=(Z=-1000.000000)
        ColorScale(0)=(Color=(B=128,G=178,R=194,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=128,G=174,R=190,A=255))
        Opacity=0.15
        FadeOutStartTime=0.25
        MaxParticles=250
        name="pouring_sand"
        UseRotationFrom=PTRS_Actor
        SpinsPerSecondRange=(X=(Min=0.100000,Max=0.200000))
        StartSpinRange=(X=(Min=0.500000,Max=0.500000))
        RotationDampingFactorRange=(X=(Min=1.000000,Max=1.000000),Y=(Min=1.000000,Max=1.000000),Z=(Min=1.000000,Max=1.000000))
        StartSizeRange=(X=(Min=2.0,Max=2.500000))
        SizeScale(0)=(RelativeTime=1.000000,RelativeSize=0.05)
        InitialParticlesPerSecond=150.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.BulletHits.snowchunksfinal'
        TextureUSubdivisions=2
        TextureVSubdivisions=2
        LifetimeRange=(Min=0.50,Max=0.75)
        StartVelocityRange=(X=(Min=45.000000,Max=55.000000),Y=(Min=-6.000000,Max=4.000000),Z=(Min=-5.000000,Max=7.000000))
    End Object
    Emitters(6)=SpriteEmitter'SpriteEmitter88'

    Autodestroy=true
    bnodelete=false
    CullDistance=3000
}

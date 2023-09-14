//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHBulletHitHedgeEffect extends emitter;

defaultproperties
{
    Begin Object Class=BeamEmitter Name=BeamEmitter0
        BeamDistanceRange=(Min=50.000000,Max=85.000000)
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
        MaxParticles=12
        name="main_impact"
        StartLocationOffset=(X=-10.000000)
        UseRotationFrom=PTRS_Actor
        StartSizeRange=(X=(Min=5.000000,Max=15.000000),Y=(Min=5.000000,Max=15.000000),Z=(Min=50.000000,Max=60.000000))
        InitialParticlesPerSecond=200.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'DH_FX_Tex.Effects.Impact03'
        LifetimeRange=(Min=0.200000,Max=0.400000)
        StartVelocityRange=(X=(Min=300.000000,Max=600.000000),Y=(Min=-75.000000,Max=85.000000),Z=(Min=-85.000000,Max=75.000000))
    End Object
    Emitters(0)=BeamEmitter'BeamEmitter0'

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
        ColorScale(0)=(Color=(B=50,G=99,R=91,A=255))
        ColorScale(1)=(RelativeTime=0.5,Color=(B=107,G=148,R=123,A=255))
        ColorScale(2)=(RelativeTime=1.000000,Color=(B=50,G=99,R=91,A=255))
        ColorScaleRepeats=2.000000
        MaxParticles=10
        name="Leaves_Up"
        StartLocationShape=PTLS_Sphere
        SphereRadiusRange=(Min=15.000000,Max=25.000000)
        UseRotationFrom=PTRS_Actor
        SpinsPerSecondRange=(X=(Min=0.750000,Max=3.000000))
        StartSpinRange=(X=(Min=0.500000,Max=1.000000))
        StartSizeRange=(X=(Min=2.0,Max=3.5))
        InitialParticlesPerSecond=10000.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'DH_FX_Tex.Effects.LeafDebris01'
        TextureUSubdivisions=2
        TextureVSubdivisions=2
        LifetimeRange=(Min=1.000000,Max=3.000000)
        StartVelocityRange=(X=(Min=100.000000,Max=300.000000),Y=(Min=-75.000000,Max=85.000000),Z=(Min=-75.000000,Max=85.000000))
        StartVelocityRadialRange=(Min=2.000000,Max=20.000000)
        VelocityLossRange=(Z=(Min=2.000000,Max=3.0000000))
    End Object
    Emitters(1)=SpriteEmitter'SpriteEmitter11'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter10
        UseColorScale=True
        FadeOut=True
        RespawnDeadParticles=False
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        ColorScale(0)=(Color=(B=30,G=79,R=71,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=120,G=167,R=175,A=255))
        FadeOutStartTime=0.10000
        MaxParticles=12
        name="green_puff"
        StartLocationRange=(X=(Min=-10.000000,Max=5.000000))
        UseRotationFrom=PTRS_Actor
        SpinsPerSecondRange=(X=(Min=0.100000,Max=0.150000))
        SizeScale(0)=(RelativeSize=0.500000)
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=3.000000)
        StartSizeRange=(X=(Min=10.000000,Max=15.000000),Y=(Min=10.000000,Max=15.000000),Z=(Min=10.000000,Max=15.000000))
        InitialParticlesPerSecond=500.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.explosions.DSmoke_2'
        LifetimeRange=(Min=0.150000,Max=1.500000)
        StartVelocityRange=(X=(Min=5.000000,Max=75.000000),Y=(Min=-35.000000,Max=40.000000),Z=(Min=-35.000000,Max=40.000000))
    End Object
    Emitters(2)=SpriteEmitter'SpriteEmitter10'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter98
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
        MaxParticles=10
        name="LeavesOut"
        StartLocationShape=PTLS_Sphere
        SphereRadiusRange=(Min=10.0000,Max=25.000000)
        UseRotationFrom=PTRS_Actor
        SpinsPerSecondRange=(X=(Min=0.750000,Max=3.000000))
        StartSpinRange=(X=(Min=0.500000,Max=1.000000))
        StartSizeRange=(X=(Min=2.5,Max=5.5))
        InitialParticlesPerSecond=10000.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.BulletHits.snowchunksfinal'
        TextureUSubdivisions=2
        TextureVSubdivisions=2
        LifetimeRange=(Min=1.000000,Max=3.000000)
        StartVelocityRange=(X=(Min=50.000000,Max=150.000000),Y=(Min=-225.000000,Max=250.000000),Z=(Min=-250.000000,Max=225.000000))
        StartVelocityRadialRange=(Min=2.000000,Max=20.000000)
    End Object
    Emitters(3)=SpriteEmitter'SpriteEmitter98'

    Begin Object Class=MeshEmitter Name=MeshEmitter0
        StaticMesh=StaticMesh'LyesKrovySM.Veg.Lyes_fallen_branchlarge'
        UseCollision=True
        UseMaxCollisions=True
        RespawnDeadParticles=False
        SpinParticles=True
        AutomaticInitialSpawning=False
        Acceleration=(Z=-850.000000)
        DampingFactorRange=(X=(Min=0.000000,Max=0.000000),Y=(Min=0.000000,Max=0.000000),Z=(Min=0.000000,Max=0.000000))
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        MaxParticles=1
        name="LargeTwig"
        StartLocationShape=PTLS_Sphere
        SphereRadiusRange=(Min=15.000000,Max=25.000000)
        UseRotationFrom=PTRS_Actor
        StartSpinRange=(X=(Min=-0.500000,Max=1.000000),Y=(Min=-0.25,Max=0.5))
        SpinsPerSecondRange=(X=(Min=0.5,Max=2.0),Y=(Min=-0.250000,Max=0.250000)) //yaw,pitch,roll (n/a)
        StartSizeRange=(X=(Min=0.080000,Max=0.120000),Y=(Min=0.080000,Max=0.120000),Z=(Min=0.080000,Max=0.120000))
        InitialParticlesPerSecond=1000.000000
        LifetimeRange=(Min=1.000000,Max=1.400000)
        StartVelocityRange=(X=(Min=250.000000,Max=350.000000),Y=(Min=-100.000000,Max=350.000000),Z=(Min=-100.000000,Max=450.000000))
    End Object
    Emitters(4)=MeshEmitter'MeshEmitter0'

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
        ColorScale(0)=(Color=(B=115,G=136,R=145,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=115,G=136,R=145,A=255))
        FadeOutStartTime=0.500000
        MaxParticles=3
        name="dust"
        UseRotationFrom=PTRS_Actor
        SpinsPerSecondRange=(X=(Min=0.050000,Max=0.050000))
        SizeScale(0)=(RelativeSize=0.500000)
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=1.000000)
        StartSizeRange=(X=(Min=30.000000,Max=40.000000))
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
    Emitters(5)=SpriteEmitter'SpriteEmitter2'

    Autodestroy=true
    bnodelete=false
}

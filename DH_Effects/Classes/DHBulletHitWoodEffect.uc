//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2021
//==============================================================================

class DHBulletHitWoodEffect extends emitter;

defaultproperties
{
   Begin Object Class=SpriteEmitter Name=SpriteEmitter9
        RespawnDeadParticles=False
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        MaxParticles=1
        name="flash"
        SizeScale(0)=(RelativeSize=0.100000)
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=1.000000)
        StartSizeRange=(X=(Min=4.000000,Max=8.000000))
        InitialParticlesPerSecond=500.000000
        DrawStyle=PTDS_Brighten
        Texture=Texture'Effects_Tex.Weapons.muzzle_4frame3rd'
        TextureUSubdivisions=2
        TextureVSubdivisions=2
        LifetimeRange=(Min=0.100000,Max=0.100000)
    End Object
    Emitters(0)=SpriteEmitter'SpriteEmitter9'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter10
        UseDirectionAs=PTDU_UpAndNormal
        ProjectionNormal=(X=1.000000,Y=0.500000)
        RespawnDeadParticles=False
        SpinParticles=True
        UniformSize=True
        AutomaticInitialSpawning=False
        UseRandomSubdivision=True
        Acceleration=(X=30.000000,Y=40.000000,Z=-650.000000)
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        MaxParticles=12
        name="chipsup"
        StartLocationShape=PTLS_Sphere
        SphereRadiusRange=(Min=5.000000,Max=10.000000)
        UseRotationFrom=PTRS_Actor
        SpinsPerSecondRange=(X=(Min=0.750000,Max=5.000000))
        StartSpinRange=(X=(Min=0.500000,Max=1.000000))
        StartSizeRange=(X=(Min=2.000000,Max=5.000000))
        InitialParticlesPerSecond=10000.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.BulletHits.woodchunksfinal'
        TextureUSubdivisions=2
        TextureVSubdivisions=2
        LifetimeRange=(Min=0.75,Max=1.5)
        StartVelocityRange=(X=(Min=-100.000000,Max=350.000000),Y=(Min=-60.000000,Max=85.000000),Z=(Min=-75.000000,Max=60.000000))
    End Object
    Emitters(1)=SpriteEmitter'SpriteEmitter10'

    Begin Object Class=BeamEmitter Name=BeamEmitter2
        BeamDistanceRange=(Min=35.000000,Max=55.000000)
        DetermineEndPointBy=PTEP_Distance
        RotatingSheets=1
        UseColorScale=True
        FadeOut=True
        RespawnDeadParticles=False
        AutoDestroy=True
        AutomaticInitialSpawning=False
        ColorScale(0)=(Color=(B=136,G=168,R=183,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=81,G=117,R=134,A=255))
        FadeOutStartTime=0.150000
        MaxParticles=8
        name="mainimpact"
        StartLocationOffset=(X=-10.000000)
        UseRotationFrom=PTRS_Actor
        StartSizeRange=(X=(Min=5.000000,Max=15.000000),Y=(Min=5.000000,Max=15.000000),Z=(Min=35.000000,Max=45.000000))
        InitialParticlesPerSecond=200.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'DH_FX_Tex.Effects.Impact03'
        LifetimeRange=(Min=0.200000,Max=0.400000)
        StartVelocityRange=(X=(Min=300.000000,Max=600.000000),Y=(Min=-75.000000,Max=85.000000),Z=(Min=-85.000000,Max=75.000000))
    End Object
    Emitters(2)=BeamEmitter'BeamEmitter2'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter11
        FadeOut=True
        RespawnDeadParticles=False
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        ColorScale(0)=(Color=(B=30,G=79,R=71,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=120,G=167,R=175,A=255))
        FadeOutStartTime=0.100000
        MaxParticles=12
        name="wooddust"
        StartLocationRange=(X=(Min=-10.000000,Max=5.000000))
        UseRotationFrom=PTRS_Actor
        SpinsPerSecondRange=(X=(Min=0.100000,Max=0.150000))
        SizeScale(0)=(RelativeSize=0.500000)
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=3.000000)
        StartSizeRange=(X=(Min=10.000000,Max=15.000000),Y=(Min=10.000000,Max=15.000000),Z=(Min=10.000000,Max=15.000000))
        InitialParticlesPerSecond=500.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.BulletHits.woodsmokefinal2'
        TextureUSubdivisions=2
        TextureVSubdivisions=2
        LifetimeRange=(Min=0.150000,Max=1.500000)
        StartVelocityRange=(X=(Min=5.000000,Max=75.000000),Y=(Min=-35.000000,Max=40.000000),Z=(Min=-35.000000,Max=40.000000))
    End Object
    Emitters(3)=SpriteEmitter'SpriteEmitter11'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter12
        UseDirectionAs=PTDU_UP
        //EffectAxis=PTEA_NegativeX
        RespawnDeadParticles=False
        SpinParticles=True
        UniformSize=False
        UseColorScale=True
        AutomaticInitialSpawning=False
        Acceleration=(X=30.000000,Y=10.000000,Z=-350.000000)
        ColorScale(0)=(Color=(B=81,G=117,R=134,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=81,G=117,R=134,A=255))
        MaxParticles=25
        name"splinters"
        StartLocationShape=PTLS_Box
        CoordinateSystem=PTCS_Independent
        UseRotationFrom=PTRS_Actor
        SpinsPerSecondRange=(X=(Min=0.750000,Max=3.000000))
        StartSpinRange=(X=(Min=0.500000,Max=1.000000))
        StartSizeRange=(X=(Min=1.000000,Max=1.7500000),Y=(Min=6.000000,Max=10.00000),Z=(Min=6.000000,Max=10.00000))
        SpinCCWorCW=(X=1.00000,Y=0.500000,Z=0.500000)
        UseRevolution=true
        RevolutionsPerSecondRange=(X=(Min=0.000000,Max=0.000000),Y=(Min=0.000000,Max=0.000000),Z=(Min=0.000000,Max=0.500000))
        InitialParticlesPerSecond=10000.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.Vehicles.vehiclesparkhead'
        LifetimeRange=(Min=1.000000,Max=3.000000)
        StartVelocityRange=(X=(Min=25.000000,Max=150.000000),Y=(Min=-75.000000,Max=65.000000),Z=(Min=-65.000000,Max=75.000000))
        MaxAbsVelocity=(X=10000.000000,Y=10000.000000,Z=10000.000000)
    End Object
    Emitters(4)=SpriteEmitter'SpriteEmitter12'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter89
        UseDirectionAs=PTDU_UpAndNormal
        ProjectionNormal=(X=1.000000,Y=0.500000)
        FadeOut=true
        RespawnDeadParticles=False
        SpinParticles=True
        UniformSize=True
        AutomaticInitialSpawning=False
        UseRandomSubdivision=True
        Acceleration=(X=30.000000,Y=40.000000,Z=-800.000000)
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        FadeOutStartTime=0.25
        MaxParticles=12
        name="chipsout"
        StartLocationShape=PTLS_Sphere
        SphereRadiusRange=(Min=5.000000,Max=10.000000)
        UseRotationFrom=PTRS_Actor
        SpinsPerSecondRange=(X=(Min=0.750000,Max=3.000000))
        StartSpinRange=(X=(Min=0.500000,Max=1.000000))
        StartSizeRange=(X=(Min=1.5,Max=4.0))
        InitialParticlesPerSecond=10000.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.BulletHits.woodchunksfinal'
        TextureUSubdivisions=2
        TextureVSubdivisions=2
        LifetimeRange=(Min=0.75,Max=1.25)
        StartVelocityRange=(X=(Min=25.000000,Max=100.000000),Y=(Min=-120.000000,Max=135.000000),Z=(Min=-135.000000,Max=120.000000))
    End Object
    Emitters(5)=SpriteEmitter'SpriteEmitter89'

    Autodestroy=true
    bnodelete=false
}

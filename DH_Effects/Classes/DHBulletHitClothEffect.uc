//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHBulletHitClothEffect extends emitter;

defaultproperties
{
    Begin Object Class=SpriteEmitter Name=SpriteEmitter10
        RespawnDeadParticles=False
        UseRegularSizeScale=False
        UniformSize=True
        SpinParticles=True
        AutomaticInitialSpawning=False
        UseRandomSubdivision=True
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        MaxParticles=3
        name="base_puff"
        StartLocationRange=(X=(Min=1.000000,Max=5.00000))
        UseRotationFrom=PTRS_Actor
        StartSpinRange=(X=(Min=-0.500000,Max=0.500000))
        SpinsPerSecondRange=(X=(Min=0.0000,Max=1.0000))
        StartSizeRange=(X=(Min=4.000000,Max=8.000000))
        InitialParticlesPerSecond=500.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.smoke.LightSmoke_8frame'
        TextureUSubdivisions=4
        TextureVSubdivisions=4
        LifetimeRange=(Min=0.150000,Max=0.250000)
    End Object
    Emitters(0)=SpriteEmitter'SpriteEmitter10'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter7
        FadeOut=True
        RespawnDeadParticles=False
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        BlendBetweenSubdivisions=True
        UseRandomSubdivision=True
        Acceleration=(Z=-50.000000)
        UseVelocityScale=True
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        FadeOutStartTime=0.500000
        Opacity=0.5
        MaxParticles=3
        name="dust_base"
        UseRotationFrom=PTRS_Actor
        StartSpinRange=(X=(Min=-0.500000,Max=0.500000))
        SpinsPerSecondRange=(X=(Min=0.150000,Max=0.250000))
        SizeScale(0)=(RelativeSize=0.500000)
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=2.000000)
        StartSizeRange=(X=(Min=0.000000,Max=35.000000))
        InitialParticlesPerSecond=1000.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.BulletHits.stonesmokefinal'
        TextureUSubdivisions=2
        TextureVSubdivisions=2
        LifetimeRange=(Min=1.0000,Max=1.250000)
        StartVelocityRange=(X=(Min=10.000000,Max=25.000000),Y=(Min=-10.000000,Max=5.000000),Z=(Min=-5.000000,Max=10.000000))
        VelocityScale(0)=(RelativeVelocity=(X=1.000000,Y=1.000000,Z=1.000000))
        VelocityScale(1)=(RelativeTime=0.475000,RelativeVelocity=(X=0.100000,Y=0.200000,Z=0.200000))
        VelocityScale(2)=(RelativeTime=1.000000)
    End Object
    Emitters(1)=SpriteEmitter'SpriteEmitter7'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter25
        FadeOut=true
        RespawnDeadParticles=False
        //SpinParticles=True
        UniformSize=True
        UseColorScale=true
        AutomaticInitialSpawning=False
        UseSizeScale=True
        ColorScale(0)=(Color=(B=147,G=147,R=147,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=147,G=147,R=147,A=255))
        Opacity=0.75
        MaxParticles=2
        name="fabric_smoke"
        UseRotationFrom=PTRS_Actor
        //SpinsPerSecondRange=(X=(Min=0.15000,Max=0.2500000))
        //StartSpinRange=(X=(Min=-0.500000,Max=0.500000))
        SizeScale(0)=(RelativeSize=1.00000)
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=3.000000)
        StartSizeRange=(X=(Min=25.00000,Max=45.000000))
        InitialParticlesPerSecond=200.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'DH_FX_Tex.dust.dustpuff01'
        LifetimeRange=(Min=0.20,Max=0.35)
        StartVelocityRange=(X=(Min=150.000000,Max=250.000000),Y=(Min=-35.000000,Max=45.000000),Z=(Min=-45.000000,Max=35.000000))
    End Object
    Emitters(2)=SpriteEmitter'SpriteEmitter25'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter15
        UseDirectionAs=PTDU_UpAndNormal
        ProjectionNormal=(X=1.000000,Y=0.500000)
        UseColorScale=True
        RespawnDeadParticles=False
        SpinParticles=True
        UniformSize=True
        AutomaticInitialSpawning=False
        UseRandomSubdivision=True
        Acceleration=(X=30.000000,Y=10.000000,Z=-100.000000)
        ColorScale(0)=(Color=(B=147,G=147,R=147,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=147,G=147,R=147,A=255))
        MaxParticles=10
        name="fabric_chunks"
        StartLocationShape=PTLS_Sphere
        SphereRadiusRange=(Min=15.000000,Max=35.000000)
        UseRotationFrom=PTRS_Actor
        SpinsPerSecondRange=(X=(Min=0.00000,Max=5.000000))
        StartSpinRange=(X=(Min=-0.500000,Max=0.500000))
        StartSizeRange=(X=(Min=1.0000,Max=2.500000))
        InitialParticlesPerSecond=100.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'DH_FX_Tex.Subdivision_Particles.Feathers'
        TextureUSubdivisions=2
        TextureVSubdivisions=2
        LifetimeRange=(Min=1.000000,Max=3.000000)
        StartVelocityRange=(X=(Min=50.000000,Max=150.000000),Y=(Min=-25.000000,Max=35.000000),Z=(Min=-35.000000,Max=25.000000))
    End Object
    Emitters(4)=SpriteEmitter'SpriteEmitter15'

    Begin Object Class=BeamEmitter Name=BeamEmitter0
        FadeOut=true
        BeamDistanceRange=(Min=20.000000,Max=60.000000)
        DetermineEndPointBy=PTEP_Distance
        RotatingSheets=2
        UseSizeScale=True
        RespawnDeadParticles=False
        AutoDestroy=True
        AutomaticInitialSpawning=False
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        FadeOutStartTime=0.15
        Opacity=0.3
        MaxParticles=1
        name="main_impact"
        UseRotationFrom=PTRS_Actor
        StartSizeRange=(X=(Min=10.000000,Max=20.000000),Y=(Min=10.000000,Max=20.000000),Z=(Min=20.000000))
        SizeScale(0)=(RelativeSize=0.100000)
        SizeScale(1)=(RelativeTime=0.50000,RelativeSize=1.00000)
        SizeScale(2)=(RelativeTime=1.0000,RelativeSize=5.000)
        InitialParticlesPerSecond=10.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'DH_FX_Tex.Effects.Impact03'
        LifetimeRange=(Min=0.35000,Max=0.50000)
        StartVelocityRange=(X=(Min=100.000000,Max=200.000000),Y=(Min=-20.000000,Max=20.000000),Z=(Min=-20.000000,Max=20.000000))
    End Object
    Emitters(5)=BeamEmitter'BeamEmitter0'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter14
        UseCollision=True
        UseColorScale=True
        RespawnDeadParticles=False
        UniformSize=True
        AutomaticInitialSpawning=False
        UseRandomSubdivision=True
        DampingFactorRange=(X=(Min=0.000000,Max=0.000000),Y=(Min=0.000000,Max=0.000000),Z=(Min=0.000000,Max=0.000000))
        ColorScale(0)=(Color=(B=121,G=157,R=174,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=121,G=157,R=174,A=255))
        MaxParticles=4
        name="bullet_hole"
        UseRotationFrom=PTRS_Actor
        StartSizeRange=(X=(Min=3.000000,Max=4.000000))
        InitialParticlesPerSecond=10000.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.BulletHits.paperchunks'
        TextureUSubdivisions=4
        TextureVSubdivisions=4
        LifetimeRange=(Min=1.000000,Max=3.000000)
    End Object
    Emitters(6)=SpriteEmitter'SpriteEmitter14'


    Autodestroy=true
    bnodelete=false
}

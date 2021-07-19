//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2021
//==============================================================================

class DHBloodPuffMediumCaliber extends Emitter;

defaultproperties
{
    Begin Object Class=SpriteEmitter Name=SpriteEmitter5
        UseColorScale=True
        FadeOut=True
        RespawnDeadParticles=False
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        ColorScale(0)=(Color=(R=49,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(R=239,A=255))
        FadeOutStartTime=0.100000
        MaxParticles=2
        name="initial_puff
        StartSpinRange=(X=(Min=0.500000,Max=0.500000))
        SizeScale(0)=(RelativeSize=0.500000)
        SizeScale(1)=(RelativeTime=0.250000,RelativeSize=1.000000)
        SizeScale(2)=(RelativeTime=1.000000,RelativeSize=2.000000)
        StartSizeRange=(X=(Min=20.000000,Max=30.000000),Y=(Min=20.000000,Max=30.000000),Z=(Min=20.000000,Max=30.000000))
        InitialParticlesPerSecond=1000.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.explosions.radialexplosion_1frame'
        LifetimeRange=(Min=0.150000,Max=0.250000)
    End Object
    Emitters(0)=SpriteEmitter'SpriteEmitter5'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter34
        RespawnDeadParticles=False
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        Opacity=0.5
        MaxParticles=1
        name="flash"
        SizeScale(0)=(RelativeSize=0.100000)
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=1.000000)
        StartSizeRange=(X=(Min=6.000000,Max=10.000000))
        InitialParticlesPerSecond=500.000000
        DrawStyle=PTDS_Brighten
        Texture=Texture'Effects_Tex.Weapons.muzzle_4frame3rd'
        TextureUSubdivisions=2
        TextureVSubdivisions=2
        LifetimeRange=(Min=0.100000,Max=0.100000)
    End Object
    Emitters(1)=SpriteEmitter'SpriteEmitter34'

    Begin Object Class=BeamEmitter Name=BeamEmitter7
        BeamDistanceRange=(Min=35.000000,Max=55.000000)
        DetermineEndPointBy=PTEP_Distance
        RotatingSheets=2
        UseColorScale=True
        FadeOut=True
        FadeIn=true
        RespawnDeadParticles=False
        AutoDestroy=True
        UseSizeScale=True
        UseRegularSizeScale=False
        AutomaticInitialSpawning=False
        ColorScale(0)=(Color=(R=79,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(R=79,A=255)))
        Opacity=1.0
        FadeOutStartTime=0.20
        FadeInEndTime=0.1
        MaxParticles=1
        name="impact"
        StartLocationOffset=(X=-20.000000)
        UseRotationFrom=PTRS_Actor
        SizeScale(0)=(RelativeSize=0.1)
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=2.000000)
        StartSizeRange=(X=(Min=30.000000,Max=35.000000),Y=(Min=30.000000,Max=35.000000),Z=(Min=35.000000))
        InitialParticlesPerSecond=200.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'DH_FX_Tex.Effects.Impact01'
        LifetimeRange=(Min=0.900000,Max=1.500000)
        StartVelocityRange=(X=(Min=0.000000,Max=0.000000),Y=(Min=-200.000000,Max=225.000000),Z=(Min=-225.000000,Max=200.000000))
    End Object
    Emitters(2)=BeamEmitter'BeamEmitter7'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter6
        FadeOut=True
        FadeIn=True
        RespawnDeadParticles=False
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        UseColorScale=true
        AutomaticInitialSpawning=False
        BlendBetweenSubdivisions=True
        UseRandomSubdivision=True
        UseVelocityScale=True
        Acceleration=(Z=-100.000000)
        ColorScale(0)=(Color=(R=79,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(R=79,A=255))
        Opacity=0.8
        FadeOutStartTime=0.35
        FadeInEndTime=0.150000
        MaxParticles=3
        name="red_puffbig"
        StartLocationOffset=(X=15.000000)
        UseRotationFrom=PTRS_Actor
        SpinsPerSecondRange=(X=(Min=0.050000,Max=0.050000))
        StartSpinRange=(X=(Min=0.025000,Max=0.750000))
        SizeScale(0)=(RelativeSize=0.500000)
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=2.000000)
        StartSizeRange=(X=(Min=30.000000,Max=40.000000))
        InitialParticlesPerSecond=100.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.BulletHits.snowfinal2'
        TextureUSubdivisions=2
        TextureVSubdivisions=2
        LifetimeRange=(Min=0.75,Max=1.5)
        StartVelocityRange=(X=(Min=100.000000,Max=175.000000),Y=(Min=-50.000000,Max=50.000000),Z=(Min=-50.000000,Max=50.000000))
        VelocityScale(0)=(RelativeVelocity=(X=1.000000,Y=1.000000,Z=1.000000))
        VelocityScale(1)=(RelativeTime=0.475000,RelativeVelocity=(X=0.100000,Y=0.200000,Z=0.200000))
        VelocityScale(2)=(RelativeTime=1.000000)
    End Object
    Emitters(3)=SpriteEmitter'SpriteEmitter6'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter45
        FadeOut=True
        FadeIn=True
        RespawnDeadParticles=False
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        UseColorScale=true
        AutomaticInitialSpawning=False
        BlendBetweenSubdivisions=True
        UseRandomSubdivision=True
        UseVelocityScale=True
        Acceleration=(Z=-100.000000)
        ColorScale(0)=(Color=(B=189,G=215,R=223,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=115,G=136,R=145,A=255))
        Opacity=0.8
        FadeOutStartTime=0.35
        MaxParticles=3
        name="dust_puff"
        UseRotationFrom=PTRS_Actor
        SpinsPerSecondRange=(X=(Min=0.050000,Max=0.050000))
        StartSpinRange=(X=(Min=0.025000,Max=0.750000))
        SizeScale(0)=(RelativeSize=0.500000)
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=2.000000)
        StartSizeRange=(X=(Min=20.000000,Max=30.000000))
        InitialParticlesPerSecond=100.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.BulletHits.snowfinal2'
        TextureUSubdivisions=2
        TextureVSubdivisions=2
        LifetimeRange=(Min=0.75,Max=2.0)
        StartVelocityRange=(X=(Min=50.000000,Max=100.000000),Y=(Min=-100.000000,Max=150.000000),Z=(Min=-100.000000,Max=150.000000))
        VelocityScale(0)=(RelativeVelocity=(X=1.000000,Y=1.000000,Z=1.000000))
        VelocityScale(1)=(RelativeTime=0.475000,RelativeVelocity=(X=0.100000,Y=0.200000,Z=0.200000))
        VelocityScale(2)=(RelativeTime=1.000000)
    End Object
    Emitters(4)=SpriteEmitter'SpriteEmitter45'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter1
        UseColorScale=True
        FadeOut=True
        RespawnDeadParticles=False
        SpinParticles=True
        DampRotation=True
        UniformSize=True
        AutomaticInitialSpawning=False
        UseRandomSubdivision=True
        Acceleration=(Z=-350.000000)
        MaxCollisions=(Min=1.000000,Max=1.000000)
        ColorScale(0)=(Color=(R=59,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(R=59,A=255))
        FadeOutStartTime=0.25
        MaxParticles=80
        name="blood_stream"
        UseRotationFrom=PTRS_Actor
        SpinsPerSecondRange=(X=(Min=0.100000,Max=0.200000))
        StartSpinRange=(X=(Min=0.500000,Max=0.500000))
        RotationDampingFactorRange=(X=(Min=1.000000,Max=1.000000),Y=(Min=1.000000,Max=1.000000),Z=(Min=1.000000,Max=1.000000))
        StartSizeRange=(X=(Min=0.500000,Max=1.000000))
        InitialParticlesPerSecond=500.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.BulletHits.snowchunksfinal'
        TextureUSubdivisions=2
        TextureVSubdivisions=2
        LifetimeRange=(Min=0.500000,Max=1.000000)
        StartVelocityRange=(X=(Min=75.000000,Max=100.000000),Y=(Min=0.000000,Max=0.000000),Z=(Min=0.000000,Max=0.000000))
    End Object
    Emitters(5)=SpriteEmitter'SpriteEmitter1'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter2
        UseColorScale=True
        FadeOut=True
        RespawnDeadParticles=False
        SpinParticles=True
        DampRotation=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        UseRandomSubdivision=True
        Acceleration=(Z=-800.000000)
        DampingFactorRange=(X=(Min=0.150000,Max=0.250000),Y=(Min=0.150000,Max=0.250000),Z=(Min=0.150000,Max=0.250000))
        ColorScale(0)=(Color=(R=59,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(R=59,A=255))
        FadeOutStartTime=0.150000
        MaxParticles=100
        name="blood_spray"
        StartLocationOffset=(X=10.000000)
        UseRotationFrom=PTRS_Actor
        SpinsPerSecondRange=(X=(Min=0.100000,Max=0.200000))
        StartSpinRange=(X=(Min=0.500000,Max=0.500000))
        RotationDampingFactorRange=(X=(Min=1.000000,Max=1.000000),Y=(Min=1.000000,Max=1.000000),Z=(Min=1.000000,Max=1.000000))
        SizeScale(0)=(RelativeTime=1.000000,RelativeSize=0.500000)
        StartSizeRange=(X=(Min=1.000000,Max=1.250000),Y=(Min=10.000000,Max=15.000000))
        InitialParticlesPerSecond=1000.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.BulletHits.snowchunksfinal'
        TextureUSubdivisions=2
        TextureVSubdivisions=2
        LifetimeRange=(Min=0.250000,Max=1.250000)
        StartVelocityRange=(X=(Min=50.000000,Max=325.000000),Y=(Min=-150.000000,Max=100.000000),Z=(Min=-150.000000,Max=200.000000))
        VelocityScale(0)=(RelativeVelocity=(X=1.000000,Y=1.000000,Z=1.000000))
        VelocityScale(1)=(RelativeTime=0.475000,RelativeVelocity=(X=0.100000,Y=0.200000,Z=0.200000))
        VelocityScale(2)=(RelativeTime=1.000000)
    End Object
    Emitters(6)=SpriteEmitter'SpriteEmitter2'

    AutoDestroy=True
    Style=STY_Alpha
    bDirectional=True
    bNoDelete=false
    //required because this is spawned on server during netplay.
    RemoteRole=ROLE_DumbProxy
    //make sure initial rotation is replicated
    bNetInitialRotation=true
    LifeSpan=6.0
}

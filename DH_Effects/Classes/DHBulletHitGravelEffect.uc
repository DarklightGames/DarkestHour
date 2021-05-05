//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2021
//==============================================================================

class DHBulletHitGravelEffect extends emitter;

defaultproperties
{
    Begin Object Class=SpriteEmitter Name=SpriteEmitter34
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
        StartSizeRange=(X=(Min=6.000000,Max=10.000000))
        InitialParticlesPerSecond=500.000000
        DrawStyle=PTDS_Brighten
        Texture=Texture'Effects_Tex.Weapons.muzzle_4frame3rd'
        TextureUSubdivisions=2
        TextureVSubdivisions=2
        LifetimeRange=(Min=0.100000,Max=0.100000)
    End Object
    Emitters(0)=SpriteEmitter'SpriteEmitter34'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter5
        FadeOut=True
        FadeIn=True
        RespawnDeadParticles=False
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        BlendBetweenSubdivisions=True
        UseRandomSubdivision=True
        UseVelocityScale=True
        Acceleration=(Z=-1500.000000)
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        Opacity=0.300000
        MaxParticles=5
        Name="SpriteEmitter29"
        UseRotationFrom=PTRS_Actor
        SizeScale(0)=(RelativeSize=1.000000)
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=2.200000)
        StartSizeRange=(X=(Min=3.500000,Max=5.000000))
        InitialParticlesPerSecond=60.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.BulletHits.snowfinal'
        TextureUSubdivisions=2
        TextureVSubdivisions=2
        LifetimeRange=(Min=0.400000,Max=0.400000)
        StartVelocityRange=(X=(Min=200.000000,Max=400.000000),Y=(Min=-30.000000,Max=30.000000),Z=(Min=-30.000000,Max=30.000000))
        VelocityScale(0)=(RelativeVelocity=(X=1.000000,Y=1.000000,Z=1.000000))
        VelocityScale(1)=(RelativeTime=0.205000,RelativeVelocity=(X=0.100000,Y=0.500000,Z=0.500000))
        VelocityScale(2)=(RelativeTime=1.000000,RelativeVelocity=(X=0.150000,Y=0.100000,Z=0.100000))
    End Object
    Emitters(1)=SpriteEmitter'SpriteEmitter5'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter6
        FadeOut=True
        FadeIn=True
        RespawnDeadParticles=False
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        BlendBetweenSubdivisions=True
        UseRandomSubdivision=True
        UseVelocityScale=True
        Acceleration=(Z=-100.000000)
        ColorScale(0)=(Color=(B=128,G=128,R=128,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        FadeOutStartTime=0.500000
        FadeInEndTime=0.150000
        Opacity=0.5
        MaxParticles=5
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
        LifetimeRange=(Min=1.000000,Max=1.500000)
        StartVelocityRange=(X=(Min=100.000000,Max=175.000000),Y=(Min=-50.000000,Max=50.000000),Z=(Min=-50.000000,Max=50.000000))
        VelocityScale(0)=(RelativeVelocity=(X=1.000000,Y=1.000000,Z=1.000000))
        VelocityScale(1)=(RelativeTime=0.475000,RelativeVelocity=(X=0.100000,Y=0.200000,Z=0.200000))
        VelocityScale(2)=(RelativeTime=1.000000)
    End Object
    Emitters(2)=SpriteEmitter'SpriteEmitter6'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter8
        UseCollision=True
        UseMaxCollisions=True
        FadeOut=True
        FadeIn=True
        RespawnDeadParticles=False
        SpinParticles=True
        DampRotation=True
        UniformSize=True
        AutomaticInitialSpawning=False
        UseRandomSubdivision=True
        Acceleration=(X=200.000000,Z=-600.000000)
        DampingFactorRange=(X=(Min=0.150000,Max=0.250000),Y=(Min=0.150000,Max=0.250000),Z=(Min=0.150000,Max=0.250000))
        ColorScale(0)=(Color=(B=128,G=128,R=128,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=128,G=128,R=128,A=255))
        FadeOutStartTime=0.25
        MaxParticles=50
        name="spray"
        UseRotationFrom=PTRS_Actor
        SpinsPerSecondRange=(X=(Min=0.100000,Max=0.200000))
        StartSpinRange=(X=(Min=0.500000,Max=0.500000))
        RotationDampingFactorRange=(X=(Min=1.000000,Max=1.000000),Y=(Min=1.000000,Max=1.000000),Z=(Min=1.000000,Max=1.000000))
        StartSizeRange=(X=(Min=0.50000,Max=0.850000))
        InitialParticlesPerSecond=10000.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.BulletHits.stonechunksfinal'
        TextureUSubdivisions=2
        TextureVSubdivisions=2
        LifetimeRange=(Min=0.100000,Max=0.75)
        StartVelocityRange=(X=(Min=20.000000,Max=75.000000),Y=(Min=-200.000000,Max=200.000000),Z=(Min=-200.000000,Max=200.000000))
    End Object
    Emitters(3)=SpriteEmitter'SpriteEmitter8'

    Begin Object Class=BeamEmitter Name=BeamEmitter1
        BeamDistanceRange=(Min=40.000000,Max=80.000000)
        DetermineEndPointBy=PTEP_Distance
        RotatingSheets=1
        FadeOut=True
        RespawnDeadParticles=False
        AutoDestroy=True
        AutomaticInitialSpawning=False
        UseRandomSubdivision=True
        ColorScale(0)=(Color=(B=90,G=90,R=90,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=200,G=200,R=200,A=255))
        FadeOutStartTime=0.150000
        MaxParticles=1
        name="mainimpact"
        StartLocationRange=(X=(Min=-5.000000,Max=-10.000000))
        UseRotationFrom=PTRS_Actor
        StartSizeRange=(X=(Min=10.000000,Max=15.000000),Y=(Min=10.000000,Max=15.000000),Z=(Min=35.000000,Max=75.000000))
        InitialParticlesPerSecond=200.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'DH_FX_Tex.Effects.Impact03'
        LifetimeRange=(Min=0.200000,Max=0.250000)
        StartVelocityRange=(X=(Min=300.000000,Max=500.000000),Y=(Min=-10.000000,Max=10.000000),Z=(Min=-10.000000,Max=10.000000))
    End Object
    Emitters(4)=BeamEmitter'BeamEmitter1'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter33
        UseCollision=True
        UseMaxCollisions=True
        FadeOut=True
        FadeIn=True
        RespawnDeadParticles=False
        SpinParticles=True
        DampRotation=True
        UniformSize=True
        AutomaticInitialSpawning=False
        UseRandomSubdivision=True
        Acceleration=(X=100.000000,Z=-800.000000)
        DampingFactorRange=(X=(Min=0.150000,Max=0.250000),Y=(Min=0.150000,Max=0.250000),Z=(Min=0.150000,Max=0.250000))
        ColorScale(0)=(Color=(B=128,G=128,R=128,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=128,G=128,R=128,A=255))
        FadeOutStartTime=0.500000
        MaxParticles=12
        name="lingeringchunks"
        UseRotationFrom=PTRS_Actor
        SpinsPerSecondRange=(X=(Min=0.100000,Max=0.200000))
        StartSpinRange=(X=(Min=0.500000,Max=0.500000))
        RotationDampingFactorRange=(X=(Min=1.000000,Max=1.000000),Y=(Min=1.000000,Max=1.000000),Z=(Min=1.000000,Max=1.000000))
        StartSizeRange=(X=(Min=1.000000,Max=1.500000))
        InitialParticlesPerSecond=10000.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.BulletHits.stonechunksfinal'
        TextureUSubdivisions=2
        TextureVSubdivisions=2
        LifetimeRange=(Min=0.100000,Max=2.000000)
        StartVelocityRange=(X=(Min=150.000000,Max=300.000000),Y=(Min=-50.000000,Max=50.000000),Z=(Min=-50.000000,Max=50.000000))
    End Object
    Emitters(5)=SpriteEmitter'SpriteEmitter33'

    Begin Object Class=BeamEmitter Name=BeamEmitter7
        BeamDistanceRange=(Min=40.000000,Max=100.000000)
        DetermineEndPointBy=PTEP_Distance
        RotatingSheets=1
        UseColorScale=True
        FadeOut=True
        FadeIn=true
        RespawnDeadParticles=False
        AutoDestroy=True
        UseSizeScale=True
        UseRegularSizeScale=False
        AutomaticInitialSpawning=False
        Acceleration=(X=100.000000)
        ColorScale(0)=(Color=(B=158,G=158,R=158,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=200,G=200,R=200,A=255))
        Opacity=0.8
        FadeOutStartTime=0.20
        FadeInEndTime=0.1
        MaxParticles=2
        name="lightdust"
        StartLocationOffset=(X=-20.000000)
        UseRotationFrom=PTRS_Actor
        SizeScale(0)=(RelativeSize=1.000000)
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=2.000000)
        StartSizeRange=(X=(Min=20.000000,Max=30.000000),Y=(Min=20.000000,Max=30.000000),Z=(Min=40.000000))
        InitialParticlesPerSecond=200.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'DH_FX_Tex.Effects.Impact01'
        LifetimeRange=(Min=0.900000,Max=1.500000)
        StartVelocityRange=(X=(Min=350.000000,Max=600.000000),Y=(Min=-100.000000,Max=150.000000),Z=(Min=-150.000000,Max=100.000000))
    End Object
    Emitters(6)=BeamEmitter'BeamEmitter7'

    Autodestroy=true
    bnodelete=false
}

//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2021
//==============================================================================

class DHBulletHitDirtEffect extends emitter;

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

    Begin Object Class=SpriteEmitter Name=SpriteEmitter19
        FadeOut=True
        RespawnDeadParticles=False
        SpinParticles=True
        DampRotation=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=False
        AutomaticInitialSpawning=False
        UseRandomSubdivision=True
        Acceleration=(Z=-1200.000000)
        DampingFactorRange=(X=(Min=0.150000,Max=0.250000),Y=(Min=0.150000,Max=0.250000),Z=(Min=0.150000,Max=0.250000))
        ColorScale(0)=(Color=(B=128,G=128,R=128,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=128,G=128,R=128,A=255))
        FadeOutStartTime=0.150000
        MaxParticles=200
        name="mainchunks"
        StartLocationOffset=(X=10.000000)
        UseRotationFrom=PTRS_Actor
        SpinsPerSecondRange=(X=(Min=0.100000,Max=0.200000))
        StartSpinRange=(X=(Min=0.500000,Max=0.500000))
        RotationDampingFactorRange=(X=(Min=1.000000,Max=1.000000),Y=(Min=1.000000,Max=1.000000),Z=(Min=1.000000,Max=1.000000))
        SizeScale(0)=(RelativeTime=1.000000,RelativeSize=1.0000)
        StartSizeRange=(X=(Min=1.000000,Max=1.2500000),Y=(Min=10.000000,Max=15.000000))
        InitialParticlesPerSecond=10000.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.BulletHits.groundchunksfinal'
        TextureUSubdivisions=2
        TextureVSubdivisions=2
        LifetimeRange=(Min=0.250000,Max=1.250000)
        StartVelocityRange=(X=(Min=50.000000,Max=500.000000),Y=(Min=-150.000000,Max=100.000000),Z=(Min=-150.000000,Max=200.000000))
        VelocityScale(0)=(RelativeVelocity=(X=1.000000,Y=1.000000,Z=1.000000))
        VelocityScale(1)=(RelativeTime=0.475000,RelativeVelocity=(X=0.100000,Y=0.200000,Z=0.200000))
        VelocityScale(2)=(RelativeTime=1.000000)
    End Object
    Emitters(1)=SpriteEmitter'SpriteEmitter19'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter36
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
        Acceleration=(Z=-150.000000)
        DampingFactorRange=(X=(Min=0.150000,Max=0.250000),Y=(Min=0.150000,Max=0.250000),Z=(Min=0.150000,Max=0.250000))
        ColorScale(0)=(Color=(B=128,G=128,R=128,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=128,G=128,R=128,A=255))
        FadeOutStartTime=0.500000
        MaxParticles=350
        name="sidechunks"
        StartLocationShape=PTLS_Sphere
        SphereRadiusRange=(Min=2.000000,Max=5.000000)
        UseRotationFrom=PTRS_Actor
        SpinsPerSecondRange=(X=(Min=0.100000,Max=0.200000))
        StartSpinRange=(X=(Min=0.500000,Max=0.500000))
        RotationDampingFactorRange=(X=(Min=1.000000,Max=1.000000),Y=(Min=1.000000,Max=1.000000),Z=(Min=1.000000,Max=1.000000))
        StartSizeRange=(X=(Min=0.500000,Max=1.000000))
        InitialParticlesPerSecond=10000.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.BulletHits.dirtchunks'
        TextureUSubdivisions=2
        TextureVSubdivisions=2
        LifetimeRange=(Min=0.500000,Max=1.000000)
        StartVelocityRange=(X=(Min=25.000000,Max=35.000000),Y=(Min=-100.000000,Max=75.000000),Z=(Min=-100.000000,Max=75.000000))
    End Object
    Emitters(2)=SpriteEmitter'SpriteEmitter36'

    Begin Object Class=BeamEmitter Name=BeamEmitter6
        BeamDistanceRange=(Min=50.000000,Max=85.000000)
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
        MaxParticles=16
        name="impact"
        StartLocationOffset=(X=-10.000000)
        UseRotationFrom=PTRS_Actor
        StartSizeRange=(X=(Min=5.000000,Max=15.000000),Y=(Min=5.000000,Max=15.000000),Z=(Min=50.000000,Max=60.000000))
        InitialParticlesPerSecond=200.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'DH_FX_Tex.Effects.Impact03'
        LifetimeRange=(Min=0.200000,Max=0.400000)
        StartVelocityRange=(X=(Min=300.000000,Max=600.000000),Y=(Min=-75.000000,Max=85.000000),Z=(Min=-85.000000,Max=75.000000))
    End Object
    Emitters(3)=BeamEmitter'BeamEmitter6'

    Begin Object Class=BeamEmitter Name=BeamEmitter7
        BeamDistanceRange=(Min=85.000000,Max=150.000000)
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
        ColorScale(0)=(Color=(B=84,G=96,R=101,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=115,G=136,R=145,A=255))
        Opacity=0.75
        FadeOutStartTime=0.20
        FadeInEndTime=0.1
        MaxParticles=2
        name="lightdust"
        StartLocationOffset=(X=-20.000000)
        UseRotationFrom=PTRS_Actor
        SizeScale(0)=(RelativeSize=1.000000)
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=2.000000)
        StartSizeRange=(X=(Min=30.000000,Max=35.000000),Y=(Min=30.000000,Max=35.000000),Z=(Min=85.000000))
        InitialParticlesPerSecond=200.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'DH_FX_Tex.Effects.Impact01'
        LifetimeRange=(Min=0.900000,Max=1.500000)
        StartVelocityRange=(X=(Min=350.000000,Max=600.000000),Y=(Min=-200.000000,Max=225.000000),Z=(Min=-200.000000,Max=225.000000))
    End Object
    Emitters(4)=BeamEmitter'BeamEmitter7'

    Begin Object Class=BeamEmitter Name=BeamEmitter8
        BeamDistanceRange=(Min=60.000000,Max=150.000000)
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
        ColorScale(0)=(Color=(B=34,G=46,R=51,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=65,G=86,R=95,A=255))
        Opacity=0.85
        FadeOutStartTime=0.450000
        FadeInEndTime=0.1
        MaxParticles=1
        name="darkdust"
        StartLocationOffset=(X=-10.000000)
        UseRotationFrom=PTRS_Actor
        SizeScale(0)=(RelativeSize=1.000000)
        SizeScale(1)=(RelativeSize=2.000000)
        StartSizeRange=(X=(Min=40.000000,Max=60.000000),Y=(Min=40.000000,Max=60.000000),Z=(Min=60.000000))
        InitialParticlesPerSecond=200.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'DH_FX_Tex.Effects.Impact01'
        LifetimeRange=(Min=1.000000,Max=1.500000)
        StartVelocityRange=(X=(Min=200.000000,Max=400.000000),Y=(Min=-200.000000,Max=225.000000),Z=(Min=-200.000000,Max=225.000000))
    End Object
    Emitters(5)=BeamEmitter'BeamEmitter8'

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
        name="dustcloud"
        StartLocationOffset=(Z=-25.000000)
        UseRotationFrom=PTRS_Actor
        StartLocationRange=(X=(Min=-10.000000,Max=10.000000),Y=(Min=-10.000000,Max=10.000000))
        RotationOffset=(Pitch=728,Yaw=4733,Roll=13107)
        SpinCCWorCW=(Y=1.000000,Z=1.000000)
        SpinsPerSecondRange=(X=(Min=0.025000,Max=0.050000),Y=(Max=0.100000),Z=(Min=1.000000,Max=1.000000))
        StartSpinRange=(X=(Min=-0.500000,Max=0.500000),Y=(Min=16000.000000,Max=20000.000000),Z=(Min=9000.000000,Max=12000.000000))
        SizeScale(1)=(RelativeTime=1.00,RelativeSize=3.000000)
        StartSizeRange=(X=(Min=25.000000,Max=35.000000),Y=(Min=25.000000,Max=35.000000),Z=(Min=75.000000,Max=150.000000))
        InitialParticlesPerSecond=50.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.explosions.LSmoke1'
        LifetimeRange=(Min=1.000000,Max=1.500000)
        StartVelocityRange=(X=(Min=25.000000,Max=75.000000),Y=(Min=-100.000000,Max=100.000000),Z=(Min=-20.0,Max=20.000000))
    End Object
    Emitters(6)=SpriteEmitter'SpriteEmitter3'

    Autodestroy=true
    bnodelete=false
}

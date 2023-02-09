//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHBulletHitDirtEffect extends emitter;

defaultproperties
{
    Begin Object Class=SpriteEmitter Name=SpriteEmitter31
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
    Emitters(0)=SpriteEmitter'SpriteEmitter31'

    Begin Object Class=BeamEmitter Name=BeamEmitter12
        BeamDistanceRange=(Min=50.000000,Max=85.000000)
        DetermineEndPointBy=PTEP_Distance
        RotatingSheets=1
        UseColorScale=True
        FadeOut=True
        RespawnDeadParticles=False
        AutoDestroy=True
        AutomaticInitialSpawning=False
        UseRandomSubdivision=True
        ColorScale(0)=(Color=(B=45,G=66,R=77,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=65,G=86,R=95,A=255))
        FadeOutStartTime=0.150000
        MaxParticles=6//10
        name="main_impact"
        StartLocationOffset=(X=-10.000000)
        UseRotationFrom=PTRS_Actor
        StartSizeRange=(X=(Min=5.000000,Max=15.000000),Y=(Min=5.000000,Max=15.000000),Z=(Min=50.000000))
        InitialParticlesPerSecond=200.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'DH_FX_Tex.Effects.Impact03'
        LifetimeRange=(Min=0.200000,Max=0.400000)
        StartVelocityRange=(X=(Min=300.000000,Max=600.000000),Y=(Min=-75.000000,Max=85.000000),Z=(Min=-85.000000,Max=75.000000))
    End Object
    Emitters(1)=BeamEmitter'BeamEmitter12'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter39
        UseColorScale=True
        FadeOut=True
        RespawnDeadParticles=False
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        UseVelocityScale=True
        Acceleration=(Y=-50.000000,Z=-200.000000)
        ColorScale(0)=(Color=(B=115,G=136,R=145,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=115,G=136,R=145,A=255))
        Opacity=0.85
        FadeOutStartTime=0.20000
        MaxParticles=4//6
        name="light_dust"
        StartLocationRange=(X=(Min=-10.000000),Y=(Min=-5.000000,Max=5.000000),Z=(Min=-5.000000,Max=5.000000))
        UseRotationFrom=PTRS_Actor
        StartSpinRange=(X=(Min=0.600000,Max=0.800000))
        SpinsPerSecondRange=(X=(Min=-0.200000,Max=0.20000))
        SizeScale(0)=(RelativeSize=0.100000)
        SizeScale(1)=(RelativeTime=0.140000,RelativeSize=1.000000)
        SizeScale(2)=(RelativeTime=1.000000,RelativeSize=3.250000)
        StartSizeRange=(X=(Min=20.000000,Max=35.000000))
        InitialParticlesPerSecond=20.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'DH_FX_Tex.Effects.Impact01'
        LifetimeRange=(Min=0.750000,Max=1.500000)
        StartVelocityRange=(X=(Min=75.000000,Max=250.000000),Y=(Min=-10.000000,Max=15.000000),Z=(Min=-15.000000,Max=10.000000))
        VelocityScale(0)=(RelativeVelocity=(X=1.000000,Y=1.000000,Z=1.000000))
        VelocityScale(1)=(RelativeTime=0.475000,RelativeVelocity=(X=0.100000,Y=0.200000,Z=0.200000))
        VelocityScale(2)=(RelativeTime=1.000000)
    End Object
    Emitters(2)=SpriteEmitter'SpriteEmitter39'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter40
        UseColorScale=True
        FadeOut=True
        RespawnDeadParticles=False
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        UseVelocityScale=True
        Acceleration=(Z=-200.000000)
        ColorScale(0)=(Color=(B=34,G=46,R=51,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=44,G=56,R=61,A=255))
        Opacity=0.7
        FadeOutStartTime=0.140000
        MaxParticles=2
        name="dark_dust"
        StartLocationOffset=(X=10.000000)
        SphereRadiusRange=(Min=15.000000,Max=20.000000)
        UseRotationFrom=PTRS_Actor
        StartSpinRange=(X=(Min=0.650000,Max=0.750000))
        SizeScale(0)=(RelativeSize=0.100000)
        SizeScale(1)=(RelativeTime=0.140000,RelativeSize=1.000000)
        SizeScale(2)=(RelativeTime=1.000000,RelativeSize=2.500000)
        StartSizeRange=(X=(Min=10.000000,Max=55.000000))
        InitialParticlesPerSecond=30.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'DH_FX_Tex.Effects.Impact03'
        LifetimeRange=(Min=0.510000,Max=1.000000)
        StartVelocityRange=(X=(Min=100.000000,Max=350.000000),Y=(Min=-10.000000,Max=15.000000),Z=(Min=-15.000000,Max=10.000000))
        VelocityScale(0)=(RelativeVelocity=(X=1.000000,Y=1.000000,Z=1.000000))
        VelocityScale(1)=(RelativeTime=0.475000,RelativeVelocity=(X=0.100000,Y=0.200000,Z=0.200000))
        VelocityScale(2)=(RelativeTime=1.000000)
    End Object
    Emitters(3)=SpriteEmitter'SpriteEmitter40'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter35
        UseDirectionAs=PTDU_Normal
        UseColorScale=True
        FadeOut=True
        RespawnDeadParticles=False
        SpinParticles=True
        DampRotation=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        Acceleration=(Z=-200.0)
        DampingFactorRange=(X=(Min=0.150000,Max=0.250000),Y=(Min=0.150000,Max=0.250000),Z=(Min=0.150000,Max=0.250000))
        ColorScale(0)=(Color=(B=73,G=108,R=118,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=69,G=101,R=118,A=255))
        FadeOutStartTime=0.05
        MaxParticles=3
        name="ground_chunks"
        StartLocationOffset=(X=3.000000)
        UseRotationFrom=PTRS_Normal
        SpinsPerSecondRange=(X=(Min=0.050000,Max=0.100000))
        StartSpinRange=(X=(Min=0.500000,Max=0.500000))
        RotationDampingFactorRange=(X=(Min=1.000000,Max=1.000000),Y=(Min=1.000000,Max=1.000000),Z=(Min=1.000000,Max=1.000000))
        RotationNormal=(Z=1.000000)
        SizeScale(0)=(RelativeSize=0.100000)
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=2.500000)
        StartSizeRange=(X=(Min=10.000000,Max=14.000000))
        InitialParticlesPerSecond=1000.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'DH_FX_Tex.debris.genericchunks'
        LifetimeRange=(Min=0.150000,Max=0.250000)
        StartVelocityRange=(Y=(Min=-10.000000,Max=12.000000),Z=(Min=-10.000000,Max=12.000000))
        VelocityScale(0)=(RelativeVelocity=(X=1.000000,Y=1.000000,Z=1.000000))
        VelocityScale(1)=(RelativeTime=0.475000,RelativeVelocity=(X=0.100000,Y=0.200000,Z=0.200000))
        VelocityScale(2)=(RelativeTime=1.000000)
    End Object
    Emitters(4)=SpriteEmitter'SpriteEmitter35'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter36
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
        MaxParticles=4//5
        name="random_dark"
        FadeOutStartTime=0.15
        UseRotationFrom=PTRS_Actor
        SpinsPerSecondRange=(X=(Min=0.100000,Max=0.250000))
        StartSpinRange=(X=(Min=0.500000,Max=0.500000))
        RotationDampingFactorRange=(X=(Min=1.000000,Max=1.000000),Y=(Min=1.000000,Max=1.000000),Z=(Min=1.000000,Max=1.000000))
        SizeScale(0)=(RelativeSize=0.300000)
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=1.000000)
        StartSizeRange=(X=(Min=10.000000,Max=20.000000),Y=(Min=10.000000,Max=20.000000),Z=(Min=300.000000,Max=300.000000))
        InitialParticlesPerSecond=100.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'DH_FX_Tex.debris.genericchunkssparse'
        LifetimeRange=(Min=0.350000,Max=0.750000)
        StartVelocityRange=(X=(Min=250.000000,Max=350.000000),Y=(Min=-100.000000,Max=75.000000),Z=(Min=-80.000000,Max=125.000000))
        VelocityScale(0)=(RelativeVelocity=(X=1.000000,Y=1.000000,Z=1.000000))
        VelocityScale(1)=(RelativeTime=0.475000,RelativeVelocity=(X=0.100000,Y=0.200000,Z=0.200000))
        VelocityScale(2)=(RelativeTime=1.000000)
    End Object
    Emitters(5)=SpriteEmitter'SpriteEmitter36'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter38
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
        ColorScale(0)=(Color=(B=115,G=138,R=149,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=115,G=138,R=149,A=255))
        MaxParticles=4//6
        FadeOutStartTime=0.15
        name="random_lite"
        UseRotationFrom=PTRS_Actor
        SpinsPerSecondRange=(X=(Min=0.100000,Max=0.250000))
        StartSpinRange=(X=(Min=0.500000,Max=0.500000))
        RotationDampingFactorRange=(X=(Min=1.000000,Max=1.000000),Y=(Min=1.000000,Max=1.000000),Z=(Min=1.000000,Max=1.000000))
        SizeScale(0)=(RelativeSize=0.100000)
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=1.500000)
        StartSizeRange=(X=(Min=10.000000,Max=20.000000),Y=(Min=10.000000,Max=20.000000),Z=(Min=300.000000,Max=300.000000))
        InitialParticlesPerSecond=100.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'DH_FX_Tex.debris.genericchunkssparse'
        LifetimeRange=(Min=0.250000,Max=0.455000)
        StartVelocityRange=(X=(Min=250.000000,Max=350.000000),Y=(Min=-100.000000,Max=115.000000),Z=(Min=-120.000000,Max=125.000000))
        VelocityScale(0)=(RelativeVelocity=(X=1.000000,Y=1.000000,Z=1.000000))
        VelocityScale(1)=(RelativeTime=0.475000,RelativeVelocity=(X=0.100000,Y=0.200000,Z=0.200000))
        VelocityScale(2)=(RelativeTime=1.000000)
    End Object
    Emitters(6)=SpriteEmitter'SpriteEmitter38'

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
        MaxParticles=4
        FadeOutStartTime=0.15
        name="random_big"
        UseRotationFrom=PTRS_Actor
        SpinsPerSecondRange=(X=(Min=0.100000,Max=0.250000))
        StartSpinRange=(X=(Min=0.500000,Max=0.500000))
        RotationDampingFactorRange=(X=(Min=1.000000,Max=1.000000),Y=(Min=1.000000,Max=1.000000),Z=(Min=1.000000,Max=1.000000))
        SizeScale(0)=(RelativeSize=0.700000)
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=1.500000)
        StartSizeRange=(X=(Min=10.000000,Max=20.000000),Y=(Min=10.000000,Max=20.000000),Z=(Min=300.000000,Max=300.000000))
        InitialParticlesPerSecond=100.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'DH_FX_Tex.debris.genericchunkssparse'
        LifetimeRange=(Min=0.350000,Max=0.950000)
        StartVelocityRange=(X=(Min=250.000000,Max=350.000000),Y=(Min=-100.000000,Max=75.000000),Z=(Min=-80.000000,Max=125.000000))
        VelocityScale(0)=(RelativeVelocity=(X=1.000000,Y=1.000000,Z=1.000000))
        VelocityScale(1)=(RelativeTime=0.475000,RelativeVelocity=(X=0.100000,Y=0.200000,Z=0.200000))
        VelocityScale(2)=(RelativeTime=1.000000)
    End Object
    Emitters(7)=SpriteEmitter'SpriteEmitter45'

    Autodestroy=true
    bnodelete=false
}

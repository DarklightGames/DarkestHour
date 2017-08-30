//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DHVehicleWarningEmitter extends DHVehicleEmitters;

defaultproperties
{
    AutoDestroy=True
    Style=STY_Masked
    bUnlit=true
    bDirectional=True
    bNoDelete=false
    RemoteRole=ROLE_SimulatedProxy
    bNetTemporary=true
    bHardAttach=true
    LifeSpan=10

    Begin Object Class=SpriteEmitter Name=SpriteEmitter129
        FadeOut=True
        FadeIn=True
        RespawnDeadParticles=False
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        TriggerDisabled=False
        ResetOnTrigger=True
        Acceleration=(Z=600.000000)
        ColorScale(0)=(Color=(B=82,G=82,R=82,A=255))
        ColorScale(1)=(RelativeTime=0.500000,Color=(B=128,G=128,R=128,A=255))
        ColorScale(2)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        Opacity=0.100000
        FadeOutStartTime=0.600000
        FadeInEndTime=0.400000
        MaxParticles=32
        StartLocationRange=(X=(Min=-10.000000,Max=10.000000),Y=(Min=-10.000000,Max=10.000000),Z=(Max=300.000000))
        SpinsPerSecondRange=(X=(Min=0.050000,Max=0.100000))
        StartSpinRange=(X=(Min=-0.500000,Max=0.500000))
        SizeScale(0)=(RelativeSize=0.500000)
        SizeScale(1)=(RelativeTime=0.140000,RelativeSize=2.000000)
        SizeScale(2)=(RelativeTime=1.000000,RelativeSize=10.000000)
        StartSizeRange=(X=(Min=30.000000,Max=60.000000),Y=(Min=30.000000,Max=60.000000),Z=(Min=45.000000,Max=50.000000))
        ParticlesPerSecond=16.000000
        InitialParticlesPerSecond=500.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.explosions.LSmoke3'
        SecondsBeforeInactive=0.000000
        LifetimeRange=(Min=3.000000,Max=6.000000)
        StartVelocityRange=(X=(Min=-250.000000,Max=250.000000),Y=(Min=-250.000000,Max=250.000000),Z=(Min=50.000000,Max=150.000000))
        VelocityLossRange=(X=(Min=1.000000,Max=1.000000),Y=(Min=1.000000,Max=1.000000),Z=(Min=3.000000,Max=3.000000))
    End Object
    Emitters(0)=SpriteEmitter'SpriteEmitter129'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter130
        UseColorScale=True
        FadeOut=True
        FadeIn=True
        RespawnDeadParticles=False
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        TriggerDisabled=False
        ResetOnTrigger=True
        Acceleration=(X=100.000000,Y=100.000000)
        ColorScale(0)=(Color=(B=35,G=35,R=35,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=128,G=128,R=128,A=255))
        Opacity=0.400000
        FadeOutStartTime=1.020000
        FadeInEndTime=0.510000
        MaxParticles=8
        StartLocationOffset=(Z=150.000000)
        StartLocationRange=(X=(Min=-10.000000,Max=10.000000),Y=(Min=-10.000000,Max=10.000000))
        SpinsPerSecondRange=(X=(Min=0.050000,Max=0.100000))
        StartSpinRange=(X=(Min=-0.500000,Max=0.500000))
        SizeScale(0)=(RelativeSize=2.000000)
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=8.000000)
        StartSizeRange=(X=(Max=120.000000),Y=(Max=120.000000),Z=(Min=45.000000,Max=50.000000))
        InitialParticlesPerSecond=300.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.explosions.DSmoke_2'
        SecondsBeforeInactive=0.000000
        LifetimeRange=(Max=6.000000)
        StartVelocityRange=(X=(Min=-300.000000,Max=300.000000),Y=(Min=-300.000000,Max=300.000000),Z=(Min=1000.000000,Max=1500.000000))
        VelocityLossRange=(X=(Min=1.000000,Max=1.000000),Y=(Min=1.000000,Max=1.000000),Z=(Min=1.000000,Max=1.000000))
    End Object
    Emitters(1)=SpriteEmitter'SpriteEmitter130'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter131
        FadeOut=True
        FadeIn=True
        RespawnDeadParticles=False
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        BlendBetweenSubdivisions=True
        Acceleration=(Z=1600.000000)
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        FadeOutStartTime=0.200000
        FadeInEndTime=0.050000
        MaxParticles=32
        StartLocationOffset=(Z=25.000000)
        SpinCCWorCW=(X=0.000000)
        StartSpinRange=(X=(Min=-0.500000,Max=0.500000))
        SizeScale(1)=(RelativeTime=0.140000,RelativeSize=0.100000)
        SizeScale(2)=(RelativeTime=1.000000,RelativeSize=0.500000)
        StartSizeRange=(X=(Min=200.000000,Max=200.000000),Y=(Min=200.000000,Max=200.000000),Z=(Min=200.000000,Max=200.000000))
        InitialParticlesPerSecond=30.000000
        DrawStyle=PTDS_Brighten
        Texture=Texture'Effects_Tex.explosions.impact_2frame'
        TextureUSubdivisions=2
        TextureVSubdivisions=1
        LifetimeRange=(Min=0.500000,Max=0.500000)
        InitialDelayRange=(Min=0.100000,Max=0.100000)
        StartVelocityRange=(Z=(Min=10.000000,Max=10.000000))
    End Object
    Emitters(2)=SpriteEmitter'SpriteEmitter131'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter132
        FadeOut=True
        RespawnDeadParticles=False
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        ColorScale(0)=(Color=(A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        FadeOutStartTime=0.300000
        MaxParticles=3
        StartSpinRange=(X=(Min=0.500000,Max=0.500000))
        SizeScale(0)=(RelativeSize=0.100000)
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=0.500000)
        StartSizeRange=(X=(Min=125.000000,Max=125.000000),Y=(Min=125.000000,Max=125.000000),Z=(Min=125.000000,Max=125.000000))
        InitialParticlesPerSecond=16.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.explosions.explosion_1frame'
        LifetimeRange=(Min=0.600000,Max=0.800000)
        StartVelocityRange=(Z=(Min=50.000000,Max=50.000000))
    End Object
    Emitters(3)=SpriteEmitter'SpriteEmitter132'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter133
        FadeOut=True
        FadeIn=True
        RespawnDeadParticles=False
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        FadeOutStartTime=0.200000
        FadeInEndTime=0.050000
        MaxParticles=64
        StartLocationOffset=(Z=50.000000)
        StartLocationShape=PTLS_Sphere
        SphereRadiusRange=(Max=64.000000)
        SizeScale(1)=(RelativeTime=0.300000,RelativeSize=0.040000)
        SizeScale(2)=(RelativeTime=1.000000,RelativeSize=0.080000)
        StartSizeRange=(X=(Min=250.000000,Max=250.000000),Y=(Min=250.000000,Max=250.000000),Z=(Min=250.000000,Max=250.000000))
        Sounds(0)=(Sound=SoundGroup'DH_ProjectileSounds.Bullets.Bullet_Snap',Radius=(Min=64.000000,Max=64.000000),Pitch=(Min=0.500000,Max=1.000000),Volume=(Min=128.000000,Max=255.000000),Probability=(Min=1.000000,Max=1.000000))
        SpawningSound=PTSC_LinearLocal
        SpawningSoundProbability=(Min=1.000000,Max=1.000000)
        InitialParticlesPerSecond=32.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'DH_FX_Tex.Effects.flak_flash'
        TextureUSubdivisions=1
        TextureVSubdivisions=1
        LifetimeRange=(Min=0.100000,Max=0.100000)
        StartVelocityRange=(Z=(Min=10.000000,Max=10.000000))
    End Object
    Emitters(4)=SpriteEmitter'SpriteEmitter133'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter134
        ProjectionNormal=(X=200.000000,Y=200.000000)
        FadeOut=True
        FadeIn=True
        RespawnDeadParticles=False
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        UseRandomSubdivision=True
        UseVelocityScale=True
        FadeOutStartTime=0.800000
        FadeInEndTime=0.100000
        MaxParticles=16
        UseRotationFrom=PTRS_Offset
        SpinsPerSecondRange=(X=(Min=-0.050000,Max=0.050000))
        StartSpinRange=(X=(Min=-0.500000,Max=0.500000),Y=(Min=0.500000,Max=1.000000),Z=(Min=0.500000,Max=1.000000))
        SizeScale(0)=(RelativeSize=0.500000)
        SizeScale(1)=(RelativeTime=0.300000,RelativeSize=3.000000)
        SizeScale(2)=(RelativeTime=1.000000,RelativeSize=16.000000)
        StartSizeRange=(X=(Min=10.000000,Max=20.000000),Y=(Min=10.000000,Max=20.000000),Z=(Min=10.000000,Max=20.000000))
        InitialParticlesPerSecond=100.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.BulletHits.metalsmokefinal'
        TextureUSubdivisions=2
        TextureVSubdivisions=2
        LifetimeRange=(Min=5.000000,Max=5.000000)
        StartVelocityRange=(X=(Min=-200.000000,Max=200.000000),Y=(Min=-200.000000,Max=200.000000))
        VelocityLossRange=(X=(Min=0.500000,Max=1.000000),Y=(Min=0.500000,Max=1.000000),Z=(Min=0.500000,Max=1.000000))
        VelocityScale(0)=(RelativeVelocity=(X=1.000000,Y=1.000000,Z=1.000000))
        VelocityScale(1)=(RelativeTime=0.100000,RelativeVelocity=(X=0.200000,Y=0.200000,Z=1.000000))
        VelocityScale(2)=(RelativeTime=1.000000)
    End Object
    Emitters(5)=SpriteEmitter'SpriteEmitter134'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter135
        UseCollision=True
        UseColorScale=True
        RespawnDeadParticles=False
        UseRevolution=True
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        Acceleration=(Z=-900.000000)
        ExtentMultiplier=(X=0.000000,Y=0.000000,Z=0.000000)
        DampingFactorRange=(X=(Min=0.100000,Max=0.100000),Y=(Min=0.100000,Max=0.100000),Z=(Min=0.100000,Max=0.100000))
        MaxCollisions=(Min=2.000000,Max=3.000000)
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        Opacity=0.500000
        MaxParticles=16
        StartMassRange=(Min=0.000000,Max=0.000000)
        SpinsPerSecondRange=(X=(Min=-0.005000,Max=0.005000))
        StartSpinRange=(X=(Min=-1.000000,Max=1.000000))
        SizeScale(0)=(RelativeSize=5.000000)
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=1.000000)
        StartSizeRange=(X=(Min=1.000000,Max=1.000000),Y=(Min=1.000000,Max=1.000000),Z=(Min=1.000000,Max=1.000000))
        InitialParticlesPerSecond=32.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.explosions.shrapnel3'
        StartVelocityRange=(X=(Min=-300.000000,Max=300.000000),Y=(Min=-300.000000,Max=300.000000),Z=(Min=120.000000,Max=300.000000))
    End Object
    Emitters(6)=SpriteEmitter'SpriteEmitter135'

    Begin Object Class=SparkEmitter Name=SparkEmitter5
        LineSegmentsRange=(Min=1.000000,Max=3.000000)
        TimeBetweenSegmentsRange=(Min=0.010000,Max=0.050000)
        UseColorScale=True
        FadeOut=True
        FadeIn=True
        RespawnDeadParticles=False
        AutomaticInitialSpawning=False
        Acceleration=(Z=-400.000000)
        ColorScale(0)=(Color=(B=120,G=120,R=120))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=150,G=255,R=254))
        FadeOutStartTime=0.800000
        FadeInEndTime=0.200000
        MaxParticles=128
        AddLocationFromOtherEmitter=4
        InitialParticlesPerSecond=64.000000
        DrawStyle=PTDS_Brighten
        Texture=Texture'SpecialEffects.Flares.SoftFlare'
        LifetimeRange=(Min=0.700000,Max=0.700000)
        StartVelocityRange=(X=(Min=-128.000000,Max=128.000000),Y=(Min=-128.000000,Max=128.000000),Z=(Max=300.000000))
        VelocityLossRange=(X=(Min=0.250000,Max=1.000000),Y=(Min=0.250000,Max=1.000000),Z=(Min=0.250000,Max=1.000000))
    End Object
    Emitters(7)=SparkEmitter'SparkEmitter5'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter154
        FadeOut=True
        FadeIn=True
        RespawnDeadParticles=False
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        FadeOutStartTime=0.800000
        FadeInEndTime=0.500000
        MaxParticles=8
        SpinsPerSecondRange=(X=(Min=-0.200000,Max=0.200000))
        StartSpinRange=(X=(Max=1.000000),Y=(Max=1.000000),Z=(Max=1.000000))
        SizeScale(0)=(RelativeSize=1.000000)
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=12.000000)
        StartSizeRange=(X=(Min=10.000000,Max=10.000000),Y=(Min=10.000000,Max=10.000000),Z=(Min=10.000000,Max=10.000000))
        InitialParticlesPerSecond=12.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.explosions.DSmoke_2'
        LifetimeRange=(Min=3.000000,Max=3.000000)
        StartVelocityRange=(X=(Min=-350.000000,Max=350.000000),Y=(Min=-350.000000,Max=350.000000))
        VelocityLossRange=(X=(Min=1.000000,Max=1.000000),Y=(Min=1.000000,Max=1.000000))
    End Object
    Emitters(8)=SpriteEmitter'SpriteEmitter154'
}

//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DHVehicleDestroyedEmitter extends Emitter; // this class is not used (as at December 2016) & vehicles use the 'ROVehicleDestroyedEmitter' effect

defaultproperties
{
    AutoDestroy=true
    bNoDelete=false
    LifeSpan=8.0
    Style=STY_Masked
    bHardAttach=true

    AmbientSound=Sound'DH_Ambience.Vehicles.Vehicle_cookoff2'
    bFullVolume=true
    SoundVolume=255
    SoundRadius=1200//experiment with this
    //TransientSoundVolume=255
    //TransientSoundRadius=1500

    Begin Object Class=SpriteEmitter Name=SpriteEmitter30
        UseColorScale=True
        FadeOut=True
        FadeIn=True
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        Acceleration=(X=20.000000,Y=50.000000,Z=50.000000)
        ColorScale(0)=(Color=(A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255))
        FadeOutStartTime=4.000000
        FadeInEndTime=0.320000
        MaxParticles=50
        StartLocationOffset=(Z=50.000000)
        StartLocationRange=(X=(Min=-50.000000,Max=50.000000),Y=(Min=-50.000000,Max=50.000000))
        RotationOffset=(Pitch=2184,Yaw=6189,Roll=13107)
        SpinCCWorCW=(Y=1.000000,Z=1.000000)
        SpinsPerSecondRange=(X=(Min=0.025000,Max=0.050000),Y=(Max=0.100000),Z=(Min=1.000000,Max=1.000000))
        StartSpinRange=(X=(Min=-0.500000,Max=0.500000),Y=(Min=16000.000000,Max=20000.000000),Z=(Min=9000.000000,Max=12000.000000))
        SizeScale(0)=(RelativeTime=1.000000,RelativeSize=6.000000)
        StartSizeRange=(X=(Min=150.000000,Max=300.000000),Y=(Min=150.000000,Max=300.000000),Z=(Min=150.000000,Max=300.000000))
        ParticlesPerSecond=3.000000
        InitialParticlesPerSecond=3.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.explosions.LSmoke3'
        LifetimeRange=(Min=16.000000,Max=16.000000)
        StartVelocityRange=(X=(Min=50.000000,Max=100.000000),Y=(Min=50.000000,Max=100.000000),Z=(Max=20.000000))
    End Object
    Emitters(0)=SpriteEmitter'SpriteEmitter30'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter31
        FadeOut=True
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        BlendBetweenSubdivisions=True
        UseRandomSubdivision=True
        UseVelocityScale=True
        Acceleration=(Z=150.000000)
        ColorScale(0)=(Color=(B=255,G=255,R=255))
        ColorScale(1)=(RelativeTime=0.250000,Color=(B=100,G=177,R=230,A=255))
        ColorScale(2)=(RelativeTime=0.750000,Color=(B=5,R=230,A=255))
        ColorScale(3)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        FadeOutStartTime=0.600000
        StartLocationRange=(X=(Min=20.000000,Max=20.000000),Y=(Min=20.000000,Max=20.000000),Z=(Min=30.000000,Max=50.000000))
        UseRotationFrom=PTRS_Actor
        StartSpinRange=(X=(Min=0.500000,Max=0.500000))
        SizeScale(0)=(RelativeSize=0.500000)
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=1.500000)
        StartSizeRange=(X=(Max=150.000000))
        ParticlesPerSecond=5.000000
        InitialParticlesPerSecond=3.000000
        DrawStyle=PTDS_Brighten
        Texture=Texture'Effects_Tex.explosions.fire_16frame'
        TextureUSubdivisions=4
        TextureVSubdivisions=4
        LifetimeRange=(Min=1.000000,Max=1.000000)
        StartVelocityRange=(X=(Min=-20.000000,Max=20.000000),Y=(Min=-20.000000,Max=20.000000))
        VelocityScale(0)=(RelativeTime=0.100000,RelativeVelocity=(X=0.100000,Y=0.100000,Z=0.100000))
        VelocityScale(1)=(RelativeTime=0.500000,RelativeVelocity=(X=1.000000,Y=1.000000,Z=1.000000))
        VelocityScale(2)=(RelativeTime=1.000000)
    End Object
    Emitters(1)=SpriteEmitter'SpriteEmitter31'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter32
        FadeOut=True
        FadeIn=True
        RespawnDeadParticles=False
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        Acceleration=(X=50.000000,Y=50.000000,Z=-100.000000)
        ColorScale(0)=(Color=(B=104,G=123,R=132,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        FadeOutStartTime=0.990000
        FadeInEndTime=0.250000
        StartLocationRange=(X=(Min=-25.000000,Max=25.000000),Y=(Min=-25.000000,Max=25.000000))
        StartLocationShape=PTLS_Sphere
        UseRotationFrom=PTRS_Actor
        SpinsPerSecondRange=(X=(Min=0.050000,Max=0.100000))
        StartSpinRange=(X=(Min=-0.500000,Max=0.500000))
        SizeScale(0)=(RelativeTime=1.000000,RelativeSize=7.000000)
        StartSizeRange=(X=(Min=10.000000,Max=50.000000),Y=(Min=10.000000,Max=50.000000),Z=(Min=20.000000,Max=20.000000))
        InitialParticlesPerSecond=100.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.explosions.DSmoke_2'
        SecondsBeforeInactive=0.000000
        LifetimeRange=(Min=2.500000,Max=3.000000)
        StartVelocityRange=(X=(Min=-100.000000,Max=300.000000),Y=(Min=-300.000000,Max=300.000000),Z=(Min=-200.000000,Max=200.000000))
        VelocityLossRange=(X=(Min=3.000000,Max=3.000000),Y=(Min=3.000000,Max=3.000000),Z=(Min=3.000000,Max=3.000000))
    End Object
    Emitters(2)=SpriteEmitter'SpriteEmitter32'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter35
        UseCollision=false
        UseColorScale=True
        FadeOut=True
        FadeIn=True
        RespawnDeadParticles=False
        UniformSize=True
        AutomaticInitialSpawning=False
        Acceleration=(X=-50.000000,Z=-600.000000)
        ColorScale(0)=(Color=(B=64,G=128,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        Opacity=0.1
        FadeOutStartTime=1.000000
        MaxParticles=60
        StartSizeRange=(X=(Min=2.000000,Max=3.000000))
        ParticlesPerSecond=30.000000
        InitialParticlesPerSecond=12.000000
        DrawStyle=PTDS_Brighten
        Texture=Texture'DH_FX_Tex.Effects.FlareWhite'
        LifetimeRange=(Min=1.500000,Max=2.500000)
        StartVelocityRange=(X=(Min=-150.000000,Max=150.000000),Y=(Min=-100.000000,Max=100.000000),Z=(Min=400.000000,Max=600.000000))
    End Object
    Emitters(3)=SpriteEmitter'SpriteEmitter35'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter36
        FadeOut=True
        FadeIn=True
        RespawnDeadParticles=False
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        BlendBetweenSubdivisions=True
        Acceleration=(Z=50.000000)
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        FadeOutStartTime=0.195000
        FadeInEndTime=0.097500
        MaxParticles=4
        StartLocationOffset=(Z=50.000000)
        StartLocationRange=(X=(Min=-80.000000,Max=80.000000),Y=(Min=-80.000000,Max=80.000000),Z=(Min=50.000000,Max=200.000000))
        SizeScale(1)=(RelativeTime=0.140000,RelativeSize=1.000000)
        SizeScale(2)=(RelativeTime=1.000000,RelativeSize=1.500000)
        StartSizeRange=(X=(Min=25.000000,Max=50.000000),Y=(Min=25.000000,Max=50.000000),Z=(Min=25.000000,Max=50.000000))
        ParticlesPerSecond=2.000000
        InitialParticlesPerSecond=10.000000
        DrawStyle=PTDS_Brighten
        Texture=Texture'Effects_Tex.explosions.impact_2frame'
        TextureUSubdivisions=2
        TextureVSubdivisions=1
        LifetimeRange=(Min=0.750000,Max=0.750000)
        StartVelocityRange=(Z=(Min=10.000000,Max=50.000000))
    End Object
    Emitters(4)=SpriteEmitter'SpriteEmitter36'

    Begin Object Class=SparkEmitter Name=SparkEmitter1
        LineSegmentsRange=(Min=1.000000,Max=2.000000)
        TimeBeforeVisibleRange=(Min=1.000000,Max=10.000000)
        TimeBetweenSegmentsRange=(Min=0.050000,Max=0.050000)
        FadeOut=True
        Acceleration=(Z=-200.000000)
        StartLocationOffset=(Z=50.000000)
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        FadeOutStartTime=1.600000
        MaxParticles=50
        AddLocationFromOtherEmitter=3
        InitialParticlesPerSecond=5.000000
        Texture=Texture'Effects_Tex.explosions.fire_quad'
        StartVelocityRange=(X=(Min=-100.000000,Max=100.000000),Y=(Min=-100.000000,Max=100.000000),Z=(Min=100.000000,Max=300.000000))
        AddVelocityFromOtherEmitter=3
    End Object
    Emitters(5)=SparkEmitter'SparkEmitter1'
}

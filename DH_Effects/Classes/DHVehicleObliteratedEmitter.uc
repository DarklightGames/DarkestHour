//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DHVehicleObliteratedEmitter extends Emitter; //

defaultproperties
{
    bLightChanged=True
    AutoDestroy=True
    Style=STY_Masked
    bUnlit=true
    bDirectional=True
    bNoDelete=false
    RemoteRole=ROLE_SimulatedProxy
    bNetTemporary=true
    bHardAttach=true
    LifeSpan = 8

    Begin Object Class=SpriteEmitter Name=SpriteEmitter0
        UseColorScale=True
        FadeOut=True
        FadeIn=True
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        Acceleration=(Y=-100.000000,Z=500.000000)
        ColorScale(0)=(Color=(B=198,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=0.100000,Color=(B=108,G=182,R=255,A=255))
        ColorScale(2)=(RelativeTime=0.157143,Color=(B=107,G=129,R=148,A=255))
        ColorScale(3)=(RelativeTime=0.600000,Color=(B=64,G=64,R=64,A=255))
        ColorScale(4)=(RelativeTime=1.000000,Color=(B=128,G=128,R=128,A=255))
        ColorScale(5)=(RelativeTime=1.000000,Color=(A=255))
        ColorScale(6)=(RelativeTime=1.000000,Color=(B=128,G=128,R=128,A=255))
        ColorScale(7)=(RelativeTime=1.000000,Color=(A=255))
        ColorScale(8)=(RelativeTime=1.000000,Color=(A=255))
        FadeOutStartTime=4.0
        FadeInEndTime=2.2
        MaxParticles=40
        StartLocationOffset=(Z=50.000000)
        StartLocationRange=(X=(Min=-50.000000,Max=50.000000),Y=(Min=-50.000000,Max=50.000000),Z=(Min=60.000000,Max=60.000000))
        SpinsPerSecondRange=(X=(Min=0.050000,Max=0.100000))
        StartSpinRange=(X=(Min=-0.500000,Max=0.500000))
        SizeScale(0)=(RelativeSize=0.400000)
        SizeScale(1)=(RelativeSize=2.000000)
        SizeScale(2)=(RelativeTime=1.000000,RelativeSize=6.000000)
        StartSizeRange=(X=(Min=50.000000,Max=200.000000),Y=(Min=50.000000,Max=200.000000),Z=(Min=50.000000,Max=200.000000))
        ParticlesPerSecond=3.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.Smoke.grenadesmoke_fill'
        LifetimeRange=(Min=10.000000,Max=15.000000)
        StartVelocityRange=(X=(Min=-5.000000,Max=5.000000),Y=(Min=-5.000000,Max=5.000000),Z=(Max=30.000000))
        MaxAbsVelocity=(X=10000.000000,Y=10000.000000,Z=10000.000000)
        VelocityLossRange=(X=(Min=0.250000,Max=1.000000),Y=(Min=0.250000,Max=1.000000),Z=(Min=0.250000,Max=1.000000))
    End Object
    Emitters(0)=SpriteEmitter'SpriteEmitter0'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter1
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
        Acceleration=(X=250.000000,Z=150.000000)
        ColorScale(0)=(Color=(B=255,G=255,R=255))
        ColorScale(1)=(RelativeTime=0.250000,Color=(B=100,G=177,R=230,A=255))
        ColorScale(2)=(RelativeTime=0.750000,Color=(B=5,R=230,A=255))
        ColorScale(3)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        FadeOutStartTime=0.600000
        FadeInEndTime=0.130000
        MaxParticles=20

        UseRotationFrom=PTRS_Actor
        StartSpinRange=(X=(Min=0.500000,Max=0.500000))
        SizeScale(0)=(RelativeSize=0.500000)
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=1.500000)
        StartSizeRange=(X=(Min=300.000000,Max=350.000000))
        ParticlesPerSecond=5.000000
        InitialParticlesPerSecond=5.000000
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
    Emitters(1)=SpriteEmitter'SpriteEmitter1'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter2
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
        ColorScale(0)=(Color=(A=255))
        ColorScale(1)=(RelativeTime=0.650000,Color=(B=128,G=128,R=128,A=255))
        ColorScale(2)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        Opacity=0.750000
        FadeOutStartTime=0.500000
        FadeInEndTime=0.200000
        MaxParticles=5

        StartLocationRange=(X=(Min=-10.000000,Max=10.000000),Y=(Min=-10.000000,Max=10.000000),Z=(Max=300.000000))
        SpinsPerSecondRange=(X=(Min=0.050000,Max=0.100000))
        StartSpinRange=(X=(Min=-0.500000,Max=0.500000))
        SizeScale(0)=(RelativeSize=2.000000)
        SizeScale(1)=(RelativeTime=0.140000,RelativeSize=6.000000)
        SizeScale(2)=(RelativeTime=1.000000,RelativeSize=14.000000)
        StartSizeRange=(X=(Min=50.000000,Max=120.000000),Y=(Min=50.000000,Max=120.000000),Z=(Min=45.000000,Max=50.000000))
        InitialParticlesPerSecond=500.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.explosions.LSmoke3'
        SecondsBeforeInactive=0.000000
        LifetimeRange=(Min=2.000000)
        StartVelocityRange=(X=(Min=-700.000000,Max=700.000000),Y=(Min=-700.000000,Max=700.000000),Z=(Min=50.000000,Max=50.000000))
        VelocityLossRange=(X=(Min=1.000000,Max=1.000000),Y=(Min=1.000000,Max=1.000000),Z=(Min=3.000000,Max=3.000000))
    End Object
    Emitters(2)=SpriteEmitter'SpriteEmitter2'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter3
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
        Acceleration=(X=50.000000,Y=100.000000,Z=300.0)
        ColorScale(0)=(Color=(G=0,R=255,A=255))
        ColorScale(1)=(RelativeTime=0.068,Color=(G=128,R=255,A=255))
        ColorScale(2)=(RelativeTime=0.086,Color=(G=128,R=255,A=255))
        ColorScale(3)=(RelativeTime=0.15,Color=(R=255,A=255))
        ColorScale(4)=(RelativeTime=0.218,Color=(B=128,G=128,R=128,A=255))
        ColorScale(5)=(RelativeTime=0.318,Color=(B=78,G=78,R=78,A=255))
        ColorScale(6)=(RelativeTime=1.0,Color=(A=255))
        FadeOutStartTime=1.100000
        FadeInEndTime=0.100000
        MaxParticles=10

        StartLocationRange=(X=(Min=-30.000000,Max=50.000000),Y=(Min=-30.000000,Max=50.000000))
        SpinsPerSecondRange=(X=(Min=0.050000,Max=0.100000))
        StartSpinRange=(X=(Min=-0.500000,Max=0.500000))
        SizeScale(0)=(RelativeSize=2.000000)
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=8.000000)
        StartSizeRange=(X=(Max=120.000000),Y=(Max=120.000000),Z=(Min=80.000000,Max=80.000000))
        InitialParticlesPerSecond=500.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.explosions.radialexplosion_1frame'
        SecondsBeforeInactive=0.000000
        LifetimeRange=(Min=3.000000)
        StartVelocityRange=(X=(Min=-300.000000,Max=300.000000),Y=(Min=-300.000000,Max=300.000000),Z=(Min=1000.000000,Max=1500.000000))
        VelocityLossRange=(X=(Min=1.000000,Max=1.000000),Y=(Min=1.000000,Max=1.000000),Z=(Min=1.000000,Max=1.000000))
    End Object
    Emitters(3)=SpriteEmitter'SpriteEmitter3'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter4
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
        FadeOutStartTime=0.200000
        FadeInEndTime=0.050000
        MaxParticles=1

        StartLocationOffset=(Z=50.000000)
        StartLocationRange=(Z=(Min=-50.000000,Max=200.000000))
        SizeScale(1)=(RelativeTime=0.140000,RelativeSize=1.000000)
        SizeScale(2)=(RelativeTime=1.000000,RelativeSize=1.500000)
        StartSizeRange=(X=(Min=300.000000,Max=500.000000),Y=(Min=300.000000,Max=500.000000),Z=(Min=300.000000,Max=500.000000))
        InitialParticlesPerSecond=10.000000
        DrawStyle=PTDS_Brighten
        Texture=Texture'Effects_Tex.explosions.impact_2frame'
        TextureUSubdivisions=2
        TextureVSubdivisions=1
        LifetimeRange=(Min=0.750000,Max=0.750000)
        StartVelocityRange=(Z=(Min=10.000000,Max=10.000000))
    End Object
    Emitters(4)=SpriteEmitter'SpriteEmitter4'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter5
        ProjectionNormal=(X=200.000000,Y=200.000000)
        UseColorScale=True
        FadeOut=True
        RespawnDeadParticles=False
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        UseVelocityScale=True
        Acceleration=(Z=5.000000)
        ColorScale(0)=(Color=(A=255))
        ColorScale(1)=(RelativeTime=0.003571,Color=(B=128,G=128,R=128,A=255))
        ColorScale(2)=(RelativeTime=1.000000,Color=(B=192,G=192,R=192))
        Opacity=0.450000
        FadeOutStartTime=3.480000
        MaxParticles=40

        StartLocationOffset=(Z=-50.000000)
        UseRotationFrom=PTRS_Offset
        SpinsPerSecondRange=(X=(Min=-0.100000,Max=0.100000))
        StartSpinRange=(X=(Min=-0.500000,Max=0.500000),Y=(Min=0.500000,Max=1.000000),Z=(Min=0.500000,Max=1.000000))
        SizeScale(0)=(RelativeSize=5.000000)
        SizeScale(1)=(RelativeTime=0.500000,RelativeSize=10.000000)
        SizeScale(2)=(RelativeTime=1.000000,RelativeSize=40.000000)
        StartSizeRange=(X=(Min=1.000000,Max=10.000000),Y=(Min=1.000000,Max=10.000000),Z=(Min=1.000000,Max=10.000000))
        InitialParticlesPerSecond=1000.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.explosions.LSmoke1'
        LifetimeRange=(Max=6.000000)
        StartVelocityRange=(X=(Min=-3000.000000,Max=3000.000000),Y=(Min=-3000.000000,Max=3000.000000))
        VelocityLossRange=(X=(Min=1.000000,Max=1.000000),Y=(Min=1.000000,Max=1.000000),Z=(Min=1.000000,Max=1.000000))
        VelocityScale(0)=(RelativeVelocity=(X=1.000000,Y=1.000000,Z=1.000000))
        VelocityScale(1)=(RelativeTime=0.100000,RelativeVelocity=(X=0.200000,Y=0.200000,Z=1.000000))
        VelocityScale(2)=(RelativeTime=1.000000)
    End Object
    Emitters(5)=SpriteEmitter'SpriteEmitter5'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter6
        FadeOut=True
        FadeIn=True
        UniformSize=True
        Acceleration=(X=50.000000,Y=-50.000000,Z=1.000000)
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        FadeOutStartTime=1.360000
        FadeInEndTime=0.200000
        MaxParticles=20

        StartLocationRange=(X=(Min=-200.000000,Max=200.000000),Y=(Min=-200.000000,Max=200.000000),Z=(Min=5.000000,Max=5.000000))
        StartSizeRange=(X=(Min=1.000000,Max=5.000000),Y=(Min=1.000000,Max=5.000000),Z=(Min=1.000000,Max=5.000000))
        InitialParticlesPerSecond=1.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'DH_FX_Tex.Effects.FlareOrange'
        LifetimeRange=(Min=1.000000,Max=3.000000)
        StartVelocityRange=(X=(Min=-60.000000,Max=60.000000),Y=(Min=-60.000000,Max=60.000000),Z=(Min=-300.000000,Max=600.000000))
        MaxAbsVelocity=(X=10000.000000,Y=10000.000000,Z=10000.000000)
    End Object
    Emitters(6)=SpriteEmitter'SpriteEmitter6'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter7
        UseCollision=True
        UseMaxCollisions=True
        FadeOut=True
        FadeIn=True
        RespawnDeadParticles=False
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        Acceleration=(Z=-300.000000)
        MaxCollisions=(Min=1.000000,Max=1.000000)
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        FadeOutStartTime=1.600000
        FadeInEndTime=0.200000

        StartLocationRange=(Z=(Min=100.000000,Max=100.000000))
        SizeScale(0)=(RelativeSize=4.000000)
        SizeScale(1)=(RelativeTime=0.500000,RelativeSize=2.000000)
        SizeScale(2)=(RelativeTime=1.000000,RelativeSize=1.000000)
        StartSizeRange=(X=(Min=2.000000,Max=5.000000),Y=(Min=2.000000,Max=5.000000),Z=(Min=2.000000,Max=5.000000))
        InitialParticlesPerSecond=50.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'DH_FX_Tex.Effects.FlareOrange'
        LifetimeRange=(Min=2.000000)
        StartVelocityRange=(X=(Min=-800.000000,Max=800.000000),Y=(Min=-800.000000,Max=800.000000),Z=(Min=200.000000,Max=1000.000000))
    End Object
    Emitters(7)=SpriteEmitter'SpriteEmitter7'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter8
        UseDirectionAs=PTDU_Normal
        FadeOut=True
        RespawnDeadParticles=False
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        Opacity=0.280000
        FadeOutStartTime=1.640000
        MaxParticles=2

        StartLocationOffset=(Z=5.000000)
        SizeScale(0)=(RelativeSize=1.000000)
        SizeScale(1)=(RelativeTime=0.500000,RelativeSize=5.000000)
        SizeScale(2)=(RelativeTime=1.000000,RelativeSize=10.000000)
        StartSizeRange=(X=(Min=100.000000,Max=300.000000),Y=(Min=100.000000,Max=300.000000),Z=(Min=100.000000,Max=300.000000))
        InitialParticlesPerSecond=500.000000
        Texture=Texture'Placeholder_T.Effects.splashring'
        StartVelocityRange=(Z=(Min=10.000000,Max=25.000000))
    End Object
    Emitters(8)=SpriteEmitter'SpriteEmitter8'
}

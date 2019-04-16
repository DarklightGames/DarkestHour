//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DHChickenExplosion extends Emitter;

defaultproperties
{
    Begin Object Class=SpriteEmitter Name=ExplosionEffect
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
        FadeOutStartTime=0.102500
        FadeInEndTime=0.050000
        MaxParticles=1
        SizeScale(1)=(RelativeTime=0.140000,RelativeSize=0.500000)
        SizeScale(2)=(RelativeTime=1.000000,RelativeSize=1.000000)
        StartSizeRange=(X=(Min=50.000000,Max=50.000000),Y=(Min=50.000000,Max=50.000000),Z=(Min=50.000000,Max=50.000000))
        Sounds(0)=(Sound=SoundGroup'DH_EventSounds.Easter.Chicken_Clucks',Radius=(Min=128.000000,Max=128.000000),Pitch=(Min=0.950000,Max=1.050000),Volume=(Min=250.000000,Max=255.000000),Probability=(Min=1.000000,Max=1.000000))
        SpawningSound=PTSC_LinearGlobal
        SpawningSoundProbability=(Min=1.000000,Max=1.000000)
        InitialParticlesPerSecond=30.000000
        DrawStyle=PTDS_Brighten
        Texture=Texture'Effects_Tex.explosions.impact_2frame'
        TextureUSubdivisions=2
        TextureVSubdivisions=1
        LifetimeRange=(Min=0.250000,Max=0.250000)
        StartVelocityRange=(Z=(Min=10.000000,Max=10.000000))
    End Object
    Emitters(0)=SpriteEmitter'ExplosionEffect'

    Begin Object Class=SpriteEmitter Name=FeathersHigh
        UseCollision=True
        FadeOut=True
        FadeIn=True
        RespawnDeadParticles=False
        UseRevolution=True
        SpinParticles=True
        DampRotation=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        UseRandomSubdivision=True
        Acceleration=(Z=-400.000000)
        DampingFactorRange=(X=(Min=0.200000,Max=0.500000),Y=(Min=0.200000,Max=0.500000),Z=(Min=0.200000,Max=0.500000))
        ColorScale(0)=(Color=(B=25,G=25,R=25,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=82,G=84,R=95,A=255))
        FadeOutStartTime=2.000000
        FadeInFactor=(X=0.000000,Y=0.000000,Z=0.000000)
        FadeInEndTime=1.000000
        MaxParticles=32
        SpinsPerSecondRange=(X=(Min=-1.000000,Max=1.000000))
        StartSpinRange=(X=(Min=-0.500000,Max=0.500000))
        SizeScale(0)=(RelativeSize=16.000000)
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=2.000000)
        StartSizeRange=(X=(Min=0.500000,Max=1.500000),Y=(Min=0.500000,Max=1.500000),Z=(Min=3.000000,Max=5.000000))
        InitialParticlesPerSecond=1024.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'DH_FX_Tex.Subdivision_Particles.Feathers'
        TextureUSubdivisions=2
        TextureVSubdivisions=2
        SecondsBeforeInactive=4.000000
        StartVelocityRange=(X=(Min=-100.000000,Max=100.000000),Y=(Min=-100.000000,Max=100.000000),Z=(Min=200.000000,Max=400.000000))
    End Object
    Emitters(1)=SpriteEmitter'FeathersHigh'

    Begin Object Class=SpriteEmitter Name=FeatherCloud
        UseDirectionAs=PTDU_Forward
        UseColorScale=True
        FadeOut=True
        RespawnDeadParticles=False
        UseRevolution=True
        SpinParticles=True
        DampRotation=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        UseRandomSubdivision=True
        UseVelocityScale=True
        Acceleration=(Z=-800.000000)
        DampingFactorRange=(X=(Min=0.200000,Max=0.200000),Y=(Min=0.200000,Max=0.200000),Z=(Min=0.200000,Max=0.200000))
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=200,G=200,R=200,A=255))
        FadeOutStartTime=2.000000
        MaxParticles=256
        StartLocationShape=PTLS_Sphere
        SphereRadiusRange=(Max=10.000000)
        UseRotationFrom=PTRS_Normal
        StartSpinRange=(X=(Min=0.500000,Max=1.000000),Y=(Min=0.500000,Max=1.000000),Z=(Min=0.500000,Max=1.000000))
        SizeScale(0)=(RelativeSize=3.000000)
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=1.000000)
        StartSizeRange=(X=(Min=0.500000,Max=2.500000),Y=(Min=0.500000,Max=2.500000),Z=(Min=0.500000,Max=2.500000))
        InitialParticlesPerSecond=4096.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'DH_FX_Tex.Subdivision_Particles.Feathers'
        TextureUSubdivisions=2
        TextureVSubdivisions=2
        SecondsBeforeInactive=4.000000
        StartVelocityRange=(X=(Min=-300.000000,Max=300.000000),Y=(Min=-300.000000,Max=300.000000),Z=(Min=200.000000,Max=600.000000))
        VelocityScale(0)=(RelativeVelocity=(X=1.000000,Y=1.000000,Z=1.000000))
        VelocityScale(1)=(RelativeTime=0.050000,RelativeVelocity=(X=0.100000,Y=0.100000,Z=0.050000))
        VelocityScale(2)=(RelativeTime=1.000000,RelativeVelocity=(X=0.050000,Y=0.050000,Z=0.001000))
    End Object
    Emitters(2)=SpriteEmitter'FeatherCloud'

    AutoDestroy=True
    Style=STY_Alpha
    bNoDelete=false
    //required because this is spawned on server during netplay.
    RemoteRole=ROLE_DumbProxy
    LifeSpan=4.5
}

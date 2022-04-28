//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DHMortarSmokeTrail extends Emitter;

defaultproperties
{
    Begin Object Class=SpriteEmitter Name=SpriteEmitter0
        FadeOut=True
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        UseVelocityScale=True
        Acceleration=(X=70.000000,Z=20.000000)
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        Opacity=0.25
        FadeOutStartTime=0.950000
        MaxParticles=200
        Name="SpriteEmitter2"
        UseRotationFrom=PTRS_Actor
        SpinsPerSecondRange=(X=(Min=-0.075000,Max=0.075000))
        SizeScale(0)=(RelativeSize=1.000000)
        SizeScale(1)=(RelativeTime=0.070000,RelativeSize=1.000000)
        SizeScale(2)=(RelativeTime=0.370000,RelativeSize=2.200000)
        SizeScale(3)=(RelativeTime=1.000000,RelativeSize=4.000000)
        StartSizeRange=(X=(Min=15.000000,Max=30.000000))
        ParticlesPerSecond=25.000000
        InitialParticlesPerSecond=25.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.explosions.DSmoke_2'
        LifetimeRange=(Max=5.000000)
        StartVelocityRange=(X=(Min=45.000000,Max=45.000000),Y=(Min=-45.000000,Max=45.000000),Z=(Min=-45.000000,Max=45.000000))
        VelocityLossRange=(X=(Min=1.000000,Max=1.000000),Y=(Min=1.000000,Max=1.000000),Z=(Min=1.000000,Max=1.000000))
        VelocityScale(0)=(RelativeVelocity=(X=1.000000,Y=1.000000,Z=1.000000))
        VelocityScale(1)=(RelativeTime=0.300000,RelativeVelocity=(X=0.200000,Y=1.000000,Z=1.000000))
        VelocityScale(2)=(RelativeTime=1.000000,RelativeVelocity=(Y=0.400000,Z=0.400000))
    End Object
    Emitters(0)=SpriteEmitter'SpriteEmitter0'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter1
        UseColorScale=True
        FadeOut=True
        AutoReset=True
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        UseVelocityScale=True
        Acceleration=(X=70.000000,Z=20.000000)
        ColorScale(0)=(Color=(B=60,G=60,R=60,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=117,G=117,R=117,A=255))
        Opacity=0.25
        FadeOutStartTime=1.200000
        MaxParticles=200
        AutoResetTimeRange=(Min=5.000000,Max=10.000000)
        Name="SpriteEmitter4"
        UseRotationFrom=PTRS_Actor
        SpinsPerSecondRange=(X=(Min=-0.075000,Max=0.075000))
        SizeScale(0)=(RelativeSize=1.000000)
        SizeScale(1)=(RelativeTime=0.070000,RelativeSize=1.000000)
        SizeScale(2)=(RelativeTime=0.370000,RelativeSize=2.200000)
        SizeScale(3)=(RelativeTime=1.000000,RelativeSize=3.000000)
        StartSizeRange=(X=(Min=11.000000,Max=21.000000))
        ParticlesPerSecond=25.000000
        InitialParticlesPerSecond=25.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.explosions.DSmoke_2'
        LifetimeRange=(Max=4.000000)
        StartVelocityRange=(X=(Min=40.000000,Max=80.000000),Y=(Min=-45.000000,Max=45.000000),Z=(Min=-45.000000,Max=45.000000))
        VelocityLossRange=(X=(Min=2.000000,Max=2.000000),Y=(Min=2.000000,Max=2.000000),Z=(Min=2.000000,Max=2.000000))
        VelocityScale(0)=(RelativeVelocity=(X=1.000000,Y=1.000000,Z=1.000000))
        VelocityScale(1)=(RelativeTime=0.400000,RelativeVelocity=(X=0.150000,Y=1.000000,Z=1.000000))
        VelocityScale(2)=(RelativeTime=1.000000,RelativeVelocity=(Y=0.400000,Z=0.400000))
    End Object
    Emitters(1)=SpriteEmitter'SpriteEmitter1'

    bNoDelete=false
    AutoDestroy=False
}

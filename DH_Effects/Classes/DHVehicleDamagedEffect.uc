//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHVehicleDamagedEffect extends VehicleDamagedEffect;

defaultproperties
{
    Begin Object Class=SpriteEmitter Name=SpriteEmitter0
        UseColorScale=true
        FadeOut=true
        FadeIn=true
        RespawnDeadParticles=false
        SpinParticles=true
        UseSizeScale=true
        UseRegularSizeScale=false
        UniformSize=true
        AutomaticInitialSpawning=false
        Acceleration=(X=10.0,Z=10.0)
        ColorScale(0)=(Color=(B=128,G=128,R=128,A=255))
        ColorScale(1)=(RelativeTime=1.0,Color=(B=192,G=192,R=192,A=255))
        ColorScale(2)=(RelativeTime=1.0,Color=(A=255))
        ColorScale(3)=(RelativeTime=1.0,Color=(A=255))
        FadeOutStartTime=2.0
        FadeInEndTime=1.0
        MaxParticles=100
        RotationOffset=(Yaw=1274,Roll=13107)
        SpinCCWorCW=(Y=1.0,Z=1.0)
        SpinsPerSecondRange=(X=(Min=0.05,Max=0.1),Y=(Max=0.1),Z=(Min=1.0,Max=1.0))
        StartSpinRange=(X=(Min=-0.5,Max=0.5),Y=(Min=16000.0,Max=20000.0),Z=(Min=9000.0,Max=12000.0))
        SizeScale(0)=(RelativeTime=1.0,RelativeSize=5.0)
        StartSizeRange=(X=(Min=25.0,Max=50.0),Y=(Min=25.0,Max=50.0),Z=(Min=25.0,Max=50.0))
        ParticlesPerSecond=3.0
        InitialParticlesPerSecond=3.0
        DrawStyle=PTDS_AlphaBlend
        Texture=texture'Effects_Tex.explosions.DSmoke_2'
        LifetimeRange=(Min=6.0,Max=6.0)
        StartVelocityRange=(Z=(Min=50.0,Max=100.0))
        VelocityLossRange=(X=(Max=0.05),Y=(Max=0.05),Z=(Max=0.05))
    End Object
    Emitters(0)=SpriteEmitter'SpriteEmitter0'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter1
        FadeOut=true
        RespawnDeadParticles=false
        SpinParticles=true
        UseSizeScale=true
        UseRegularSizeScale=false
        UniformSize=true
        AutomaticInitialSpawning=false
        BlendBetweenSubdivisions=true
        UseRandomSubdivision=true
        UseVelocityScale=true
        Acceleration=(Z=50.0)
        ColorScale(0)=(Color=(B=255,G=255,R=255))
        ColorScale(1)=(RelativeTime=0.25,Color=(B=100,G=177,R=230,A=255))
        ColorScale(2)=(RelativeTime=0.75,Color=(B=5,R=230,A=255))
        ColorScale(3)=(RelativeTime=1.0,Color=(B=255,G=255,R=255,A=255))
        FadeOutStartTime=0.598
        UseRotationFrom=PTRS_Actor
        StartSpinRange=(X=(Min=0.5,Max=0.5))
        SizeScale(0)=(RelativeSize=0.5)
        SizeScale(1)=(RelativeTime=1.0,RelativeSize=1.5)
        StartSizeRange=(X=(Min=50.0,Max=70.0))
        ParticlesPerSecond=5.0
        InitialParticlesPerSecond=5.0
        DrawStyle=PTDS_Brighten
        Texture=texture'Effects_Tex.explosions.fire_16frame'
        TextureUSubdivisions=4
        TextureVSubdivisions=4
        LifetimeRange=(Min=2.0,Max=2.5)
        VelocityScale(0)=(RelativeTime=1.0,RelativeVelocity=(X=0.1,Y=0.1,Z=0.1))
        VelocityScale(1)=(RelativeTime=1.75,RelativeVelocity=(X=2.0,Y=2.0,Z=6.0))
        VelocityScale(2)=(RelativeTime=2.0,RelativeVelocity=(X=1.0,Y=1.0,Z=1.0))
        VelocityScale(3)=(RelativeTime=2.25)
    End Object
    Emitters(1)=SpriteEmitter'SpriteEmitter1'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter2
        FadeOut=true
        FadeIn=true
        RespawnDeadParticles=false
        SpinParticles=true
        UseSizeScale=true
        UseRegularSizeScale=false
        UniformSize=true
        AutomaticInitialSpawning=false
        Acceleration=(X=10.0,Z=10.0)
        ColorScale(0)=(Color=(A=255))
        ColorScale(1)=(RelativeTime=1.0,Color=(A=255))
        ColorScale(2)=(RelativeTime=1.0,Color=(A=255))
        ColorScale(3)=(RelativeTime=1.0,Color=(A=255))
        FadeOutStartTime=3.18
        FadeInEndTime=0.42
        MaxParticles=100
        StartLocationOffset=(Z=30.0)
        RotationOffset=(Yaw=1092,Roll=13107)
        SpinCCWorCW=(Y=1.0,Z=1.0)
        SpinsPerSecondRange=(X=(Min=0.05,Max=0.1),Y=(Max=0.1),Z=(Min=1.0,Max=1.0))
        StartSpinRange=(X=(Min=-0.5,Max=0.5),Y=(Min=16000.0,Max=20000.0),Z=(Min=9000.0,Max=12000.0))
        SizeScale(0)=(RelativeTime=1.0,RelativeSize=5.0)
        StartSizeRange=(X=(Min=25.0,Max=50.0),Y=(Min=25.0,Max=50.0),Z=(Min=25.0,Max=50.0))
        ParticlesPerSecond=4.0
        InitialParticlesPerSecond=4.0
        DrawStyle=PTDS_AlphaBlend
        Texture=texture'Effects_Tex.explosions.DSmoke_1'
        LifetimeRange=(Min=8.0,Max=8.0)
        StartVelocityRange=(Z=(Min=50.0,Max=100.0))
        VelocityLossRange=(X=(Max=0.05),Y=(Max=0.05),Z=(Max=0.05))
    End Object
    Emitters(2)=SpriteEmitter'SpriteEmitter2'
}

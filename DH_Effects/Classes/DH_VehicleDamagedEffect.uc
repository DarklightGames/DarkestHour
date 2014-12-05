//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_VehicleDamagedEffect extends VehicleDamagedEffect;

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
        Acceleration=(X=10.000000,Z=10.000000)
        ColorScale(0)=(Color=(B=128,G=128,R=128,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=192,G=192,R=192,A=255))
        ColorScale(2)=(RelativeTime=1.000000,Color=(A=255))
        ColorScale(3)=(RelativeTime=1.000000,Color=(A=255))
        FadeOutStartTime=2.000000
        FadeInEndTime=1.000000
        MaxParticles=100
        RotationOffset=(Yaw=1274,Roll=13107)
        SpinCCWorCW=(Y=1.000000,Z=1.000000)
        SpinsPerSecondRange=(X=(Min=0.050000,Max=0.100000),Y=(Max=0.100000),Z=(Min=1.000000,Max=1.000000))
        StartSpinRange=(X=(Min=-0.500000,Max=0.500000),Y=(Min=16000.000000,Max=20000.000000),Z=(Min=9000.000000,Max=12000.000000))
        SizeScale(0)=(RelativeTime=1.000000,RelativeSize=5.000000)
        StartSizeRange=(X=(Min=25.000000,Max=50.000000),Y=(Min=25.000000,Max=50.000000),Z=(Min=25.000000,Max=50.000000))
        ParticlesPerSecond=3.000000
        InitialParticlesPerSecond=3.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.explosions.DSmoke_2'
        LifetimeRange=(Min=6.000000,Max=6.000000)
        StartVelocityRange=(Z=(Min=50.000000,Max=100.000000))
        VelocityLossRange=(X=(Max=0.050000),Y=(Max=0.050000),Z=(Max=0.050000))
    End Object
    Emitters(0)=SpriteEmitter'DH_Effects.DH_VehicleDamagedEffect.SpriteEmitter0'
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
        Acceleration=(Z=50.000000)
        ColorScale(0)=(Color=(B=255,G=255,R=255))
        ColorScale(1)=(RelativeTime=0.250000,Color=(B=100,G=177,R=230,A=255))
        ColorScale(2)=(RelativeTime=0.750000,Color=(B=5,R=230,A=255))
        ColorScale(3)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        FadeOutStartTime=0.598000
        UseRotationFrom=PTRS_Actor
        StartSpinRange=(X=(Min=0.500000,Max=0.500000))
        SizeScale(0)=(RelativeSize=0.500000)
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=1.500000)
        StartSizeRange=(X=(Min=50.000000,Max=70.000000))
        ParticlesPerSecond=5.000000
        InitialParticlesPerSecond=5.000000
        DrawStyle=PTDS_Brighten
        Texture=Texture'Effects_Tex.explosions.fire_16frame'
        TextureUSubdivisions=4
        TextureVSubdivisions=4
        LifetimeRange=(Min=2.000000,Max=2.500000)
        VelocityScale(0)=(RelativeTime=1.000000,RelativeVelocity=(X=0.100000,Y=0.100000,Z=0.100000))
        VelocityScale(1)=(RelativeTime=1.750000,RelativeVelocity=(X=2.000000,Y=2.000000,Z=6.000000))
        VelocityScale(2)=(RelativeTime=2.000000,RelativeVelocity=(X=1.000000,Y=1.000000,Z=1.000000))
        VelocityScale(3)=(RelativeTime=2.250000)
    End Object
    Emitters(1)=SpriteEmitter'DH_Effects.DH_VehicleDamagedEffect.SpriteEmitter1'
    Begin Object Class=SpriteEmitter Name=SpriteEmitter2
        FadeOut=true
        FadeIn=true
        RespawnDeadParticles=false
        SpinParticles=true
        UseSizeScale=true
        UseRegularSizeScale=false
        UniformSize=true
        AutomaticInitialSpawning=false
        Acceleration=(X=10.000000,Z=10.000000)
        ColorScale(0)=(Color=(A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(A=255))
        ColorScale(2)=(RelativeTime=1.000000,Color=(A=255))
        ColorScale(3)=(RelativeTime=1.000000,Color=(A=255))
        FadeOutStartTime=3.180000
        FadeInEndTime=0.420000
        MaxParticles=100
        StartLocationOffset=(Z=30.000000)
        RotationOffset=(Yaw=1092,Roll=13107)
        SpinCCWorCW=(Y=1.000000,Z=1.000000)
        SpinsPerSecondRange=(X=(Min=0.050000,Max=0.100000),Y=(Max=0.100000),Z=(Min=1.000000,Max=1.000000))
        StartSpinRange=(X=(Min=-0.500000,Max=0.500000),Y=(Min=16000.000000,Max=20000.000000),Z=(Min=9000.000000,Max=12000.000000))
        SizeScale(0)=(RelativeTime=1.000000,RelativeSize=5.000000)
        StartSizeRange=(X=(Min=25.000000,Max=50.000000),Y=(Min=25.000000,Max=50.000000),Z=(Min=25.000000,Max=50.000000))
        ParticlesPerSecond=4.000000
        InitialParticlesPerSecond=4.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.explosions.DSmoke_1'
        LifetimeRange=(Min=8.000000,Max=8.000000)
        StartVelocityRange=(Z=(Min=50.000000,Max=100.000000))
        VelocityLossRange=(X=(Max=0.050000),Y=(Max=0.050000),Z=(Max=0.050000))
    End Object
    Emitters(2)=SpriteEmitter'DH_Effects.DH_VehicleDamagedEffect.SpriteEmitter2'
}

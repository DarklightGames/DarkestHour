//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHBurningPlayerFlame extends Emitter;

simulated function PlayerDied()
{
    Emitters[0].StartLocationOffset.Z = 3;
    Emitters[1].StartLocationOffset.Z = 3;
    Emitters[1].StartSizeRange.X.Max -= 5;
    Emitters[2].StartLocationOffset.Z = 3;
}

simulated function DouseFlames()
{
    Emitters[0].StartSizeRange.X.Min -= 3;
    Emitters[0].StartSizeRange.X.Max -= 4;
    Emitters[1].StartSizeRange.X.Min -= 3;
    Emitters[1].StartSizeRange.X.Max -= 4;
    Emitters[2].StartSizeRange.X.Min -= 4;
    Emitters[2].StartSizeRange.X.Max -= 5;

    Emitters[0].Acceleration.Z -= 15;
    Emitters[1].Acceleration.Z -= 15;
}

defaultproperties
{
    LightType=LT_Flicker
    LightHue=30
    LightSaturation=100
    LightBrightness=200.0
    LightRadius=2.0
    bNoDelete=false
    bDynamicLight=true
    bOnlyDrawIfAttached=true
    AmbientSound=Sound'Amb_Destruction.Fire.Kessel_Fire_Small_Barrel'
    bFullVolume=true
    SoundVolume=255

    Begin Object Class=SpriteEmitter Name=SpriteEmitter0
        FadeOut=true
        FadeIn=true
        SpinParticles=true
        UseSizeScale=true
        UseRegularSizeScale=false
        UniformSize=true
        UseRandomSubdivision=true
        Acceleration=(Z=150.0)
        ColorScale(1)=(RelativeTime=0.3,Color=(B=255,G=255,R=255))
        ColorScale(2)=(RelativeTime=0.667857,Color=(B=89,G=172,R=247,A=255))
        ColorScale(3)=(RelativeTime=1.0,Color=(B=128,G=128,R=128,A=255))
        ColorScale(4)=(RelativeTime=1.0)
        ColorScale(5)=(RelativeTime=1.0)
        FadeOutStartTime=0.4
        FadeInEndTime=0.14
        StartLocationOffset=(Z=-34.0)
        StartLocationShape=PTLS_Sphere
        SpinsPerSecondRange=(X=(Max=0.075))
        StartSpinRange=(X=(Min=-0.1,Max=0.1))
        SizeScale(0)=(RelativeTime=1.0,RelativeSize=0.3)
        StartSizeRange=(X=(Min=16.0,Max=25.0),Y=(Min=0.0,Max=0.0),Z=(Min=0.0,Max=0.0))
        ScaleSizeByVelocityMultiplier=(X=0.0,Y=0.0,Z=0.0)
        ScaleSizeByVelocityMax=0.0
        RelativeBoneIndexRange=(Min=0.9)
        ParticlesPerSecond=10.0
        InitialParticlesPerSecond=10.0
        DrawStyle=PTDS_Brighten
        Texture=Texture'DH_FX_Tex.Fire.FireAnim16F'
        TextureUSubdivisions=4
        TextureVSubdivisions=4
        SecondsBeforeInactive=30.0
        LifetimeRange=(Min=0.5,Max=0.75)
        StartVelocityRange=(X=(Min=-3.0,Max=5.0),Y=(Min=-3.0,Max=5.0),Z=(Min=5.0,Max=10.0))
    End Object
    Emitters(0)=SpriteEmitter'SpriteEmitter0'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter1
        FadeOut=true
        FadeIn=true
        SpinParticles=true
        UseSizeScale=true
        UseRegularSizeScale=false
        UniformSize=true
        UseRandomSubdivision=true
        Acceleration=(Z=150.0)
        ColorScale(1)=(RelativeTime=0.3,Color=(B=255,G=255,R=255))
        ColorScale(2)=(RelativeTime=0.667857,Color=(B=89,G=172,R=247,A=255))
        ColorScale(3)=(RelativeTime=1.0,Color=(B=128,G=128,R=128,A=255))
        ColorScale(4)=(RelativeTime=1.0)
        ColorScale(5)=(RelativeTime=1.0)
        FadeOutStartTime=0.4
        FadeInEndTime=0.14
        MaxParticles=12
        StartLocationOffset=(Z=-34.0)
        StartLocationShape=PTLS_Sphere
        SpinsPerSecondRange=(X=(Max=0.075))
        StartSpinRange=(X=(Min=-0.1,Max=0.1))
        SizeScale(0)=(RelativeTime=1.0,RelativeSize=0.3)
        StartSizeRange=(X=(Min=16.0,Max=30.0),Y=(Min=0.0,Max=0.0),Z=(Min=0.0,Max=0.0))
        ScaleSizeByVelocityMultiplier=(X=0.0,Y=0.0,Z=0.0)
        ScaleSizeByVelocityMax=0.0
        RelativeBoneIndexRange=(Min=0.1,Max=0.8)
        ParticlesPerSecond=12.0
        InitialParticlesPerSecond=12.0
        DrawStyle=PTDS_Brighten
        Texture=Texture'DH_FX_Tex.Fire.FireAnim16F'
        TextureUSubdivisions=4
        TextureVSubdivisions=4
        SecondsBeforeInactive=30.0
        LifetimeRange=(Min=0.5,Max=0.75)
        StartVelocityRange=(X=(Min=-3.0,Max=5.0),Y=(Min=-3.0,Max=5.0),Z=(Min=5.0,Max=10.0))
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
        ColorScale(0)=(Color=(B=255,G=255,R=255))
        ColorScale(1)=(RelativeTime=0.25,Color=(B=100,G=177,R=230,A=255))
        ColorScale(2)=(RelativeTime=0.75,Color=(A=255))
        ColorScale(3)=(RelativeTime=1.0,Color=(A=255))
        FadeOutStartTime=0.65
        FadeInEndTime=0.15
        MaxParticles=100
        StartLocationOffset=(Z=-30.0)
        RotationOffset=(Yaw=1092,Roll=13107)
        SpinCCWorCW=(Y=1.0,Z=1.0)
        SpinsPerSecondRange=(X=(Min=0.05,Max=0.1),Y=(Max=0.1),Z=(Min=1.0,Max=1.0))
        StartSpinRange=(X=(Min=-0.5,Max=0.5),Y=(Min=16000.0,Max=20000.0),Z=(Min=9000.0,Max=12000.0))
        StartSizeRange=(X=(Min=25.0,Max=50.0),Y=(Min=25.0,Max=50.0),Z=(Min=25.0,Max=50.0))
        ParticlesPerSecond=4.0
        InitialParticlesPerSecond=4.0
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.explosions.DSmoke_1'
        LifetimeRange=(Min=0.7,Max=0.8)
        StartVelocityRange=(X=(Min=10.0,Max=10.0),Y=(Min=10.0,Max=10.0),Z=(Min=50.0,Max=100.0))
        VelocityLossRange=(X=(Max=0.05),Y=(Max=0.05),Z=(Max=0.05))
    End Object
    Emitters(2)=SpriteEmitter'SpriteEmitter2'
}

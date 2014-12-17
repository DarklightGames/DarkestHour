//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_PlayerFlame extends Emitter;

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
    Begin Object Class=SpriteEmitter Name=SpriteEmitter0
        FadeOut=true
        FadeIn=true
        SpinParticles=true
        UseSizeScale=true
        UseRegularSizeScale=false
        UniformSize=true
        UseRandomSubdivision=true
        Acceleration=(Z=150.000000)
        ColorScale(1)=(RelativeTime=0.300000,Color=(B=255,G=255,R=255))
        ColorScale(2)=(RelativeTime=0.667857,Color=(B=89,G=172,R=247,A=255))
        ColorScale(3)=(RelativeTime=1.000000,Color=(B=128,G=128,R=128,A=255))
        ColorScale(4)=(RelativeTime=1.000000)
        ColorScale(5)=(RelativeTime=1.000000)
        FadeOutStartTime=0.400000
        FadeInEndTime=0.140000
        StartLocationOffset=(Z=-34.000000)
        StartLocationShape=PTLS_Sphere
        SpinsPerSecondRange=(X=(Max=0.075000))
        StartSpinRange=(X=(Min=-0.100000,Max=0.100000))
        SizeScale(0)=(RelativeTime=1.000000,RelativeSize=0.300000)
        StartSizeRange=(X=(Min=16.000000,Max=25.000000),Y=(Min=0.000000,Max=0.000000),Z=(Min=0.000000,Max=0.000000))
        ScaleSizeByVelocityMultiplier=(X=0.000000,Y=0.000000,Z=0.000000)
        ScaleSizeByVelocityMax=0.000000
        RelativeBoneIndexRange=(Min=0.900000)
        ParticlesPerSecond=10.000000
        InitialParticlesPerSecond=10.000000
        DrawStyle=PTDS_Brighten
        Texture=texture'DH_FX_Tex.Fire.FireAnim16F'
        TextureUSubdivisions=4
        TextureVSubdivisions=4
        SecondsBeforeInactive=30.000000
        LifetimeRange=(Min=0.500000,Max=0.750000)
        StartVelocityRange=(X=(Min=-3.000000,Max=5.000000),Y=(Min=-3.000000,Max=5.000000),Z=(Min=5.000000,Max=10.000000))
    End Object
    Emitters(0)=SpriteEmitter'DH_Effects.DH_PlayerFlame.SpriteEmitter0'
    Begin Object Class=SpriteEmitter Name=SpriteEmitter1
        FadeOut=true
        FadeIn=true
        SpinParticles=true
        UseSizeScale=true
        UseRegularSizeScale=false
        UniformSize=true
        UseRandomSubdivision=true
        Acceleration=(Z=150.000000)
        ColorScale(1)=(RelativeTime=0.300000,Color=(B=255,G=255,R=255))
        ColorScale(2)=(RelativeTime=0.667857,Color=(B=89,G=172,R=247,A=255))
        ColorScale(3)=(RelativeTime=1.000000,Color=(B=128,G=128,R=128,A=255))
        ColorScale(4)=(RelativeTime=1.000000)
        ColorScale(5)=(RelativeTime=1.000000)
        FadeOutStartTime=0.400000
        FadeInEndTime=0.140000
        MaxParticles=12
        StartLocationOffset=(Z=-34.000000)
        StartLocationShape=PTLS_Sphere
        SpinsPerSecondRange=(X=(Max=0.075000))
        StartSpinRange=(X=(Min=-0.100000,Max=0.100000))
        SizeScale(0)=(RelativeTime=1.000000,RelativeSize=0.300000)
        StartSizeRange=(X=(Min=16.000000,Max=30.000000),Y=(Min=0.000000,Max=0.000000),Z=(Min=0.000000,Max=0.000000))
        ScaleSizeByVelocityMultiplier=(X=0.000000,Y=0.000000,Z=0.000000)
        ScaleSizeByVelocityMax=0.000000
        RelativeBoneIndexRange=(Min=0.100000,Max=0.800000)
        ParticlesPerSecond=12.000000
        InitialParticlesPerSecond=12.000000
        DrawStyle=PTDS_Brighten
        Texture=texture'DH_FX_Tex.Fire.FireAnim16F'
        TextureUSubdivisions=4
        TextureVSubdivisions=4
        SecondsBeforeInactive=30.000000
        LifetimeRange=(Min=0.500000,Max=0.750000)
        StartVelocityRange=(X=(Min=-3.000000,Max=5.000000),Y=(Min=-3.000000,Max=5.000000),Z=(Min=5.000000,Max=10.000000))
    End Object
    Emitters(1)=SpriteEmitter'DH_Effects.DH_PlayerFlame.SpriteEmitter1'
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
        ColorScale(0)=(Color=(B=255,G=255,R=255))
        ColorScale(1)=(RelativeTime=0.250000,Color=(B=100,G=177,R=230,A=255))
        ColorScale(2)=(RelativeTime=0.750000,Color=(A=255))
        ColorScale(3)=(RelativeTime=1.000000,Color=(A=255))
        FadeOutStartTime=0.650000
        FadeInEndTime=0.150000
        MaxParticles=100
        StartLocationOffset=(Z=-30.000000)
        RotationOffset=(Yaw=1092,Roll=13107)
        SpinCCWorCW=(Y=1.000000,Z=1.000000)
        SpinsPerSecondRange=(X=(Min=0.050000,Max=0.100000),Y=(Max=0.100000),Z=(Min=1.000000,Max=1.000000))
        StartSpinRange=(X=(Min=-0.500000,Max=0.500000),Y=(Min=16000.000000,Max=20000.000000),Z=(Min=9000.000000,Max=12000.000000))
        StartSizeRange=(X=(Min=25.000000,Max=50.000000),Y=(Min=25.000000,Max=50.000000),Z=(Min=25.000000,Max=50.000000))
        ParticlesPerSecond=4.000000
        InitialParticlesPerSecond=4.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=texture'Effects_Tex.explosions.DSmoke_1'
        LifetimeRange=(Min=0.700000,Max=0.800000)
        StartVelocityRange=(X=(Min=10.000000,Max=10.000000),Y=(Min=10.000000,Max=10.000000),Z=(Min=50.000000,Max=100.000000))
        VelocityLossRange=(X=(Max=0.050000),Y=(Max=0.050000),Z=(Max=0.050000))
    End Object
    Emitters(2)=SpriteEmitter'DH_Effects.DH_PlayerFlame.SpriteEmitter2'
    LightType=LT_Flicker
    LightHue=30
    LightSaturation=100
    LightBrightness=200.000000
    LightRadius=2.000000
    bNoDelete=false
    bDynamicLight=true
    bOnlyDrawIfAttached=true
    AmbientSound=sound'Amb_Destruction.Fire.Kessel_Fire_Small_Barrel'
    bFullVolume=true
    SoundVolume=255
    bNotOnDedServer=false
}

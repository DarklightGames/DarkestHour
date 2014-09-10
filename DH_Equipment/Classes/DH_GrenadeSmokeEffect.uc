//-----------------------------------------------------------
//
//-----------------------------------------------------------
class DH_GrenadeSmokeEffect extends Emitter;

//Overrided to support smoke brightness override and wind direction/speed in DHLevelInfo
simulated function PostBeginPlay()
{
    local color NewSmokeColor;
    local byte SmokeBrightnessValue;

    super.PostBeginPlay();

    //Lets change the smoke color if it's not set to default in DH_LevelInfo
    if( DarkestHourGame(Level.Game).DHLevelInfo.SmokeBrightnessOverride != 255 )
    {
        //Set the brightness value to the override in the level
        SmokeBrightnessValue = DarkestHourGame(Level.Game).DHLevelInfo.SmokeBrightnessOverride;

        //Create new smoke color based on new brightness
        NewSmokeColor.B = SmokeBrightnessValue;
        NewSmokeColor.G = SmokeBrightnessValue;
        NewSmokeColor.R = SmokeBrightnessValue;
        NewSmokeColor.A = 255; //Alpha shouldn't change

        //Sets the new smoke color (0-3 and each scale) (need to make this a loop)
        Emitters[0].ColorScale[0].Color = NewSmokeColor;
        Emitters[0].ColorScale[1].Color = NewSmokeColor;
        Emitters[1].ColorScale[0].Color = NewSmokeColor;
        Emitters[1].ColorScale[1].Color = NewSmokeColor;
        Emitters[2].ColorScale[0].color = NewSmokeColor;
        Emitters[2].ColorScale[1].color = NewSmokeColor;
        Emitters[3].ColorScale[0].Color = NewSmokeColor;
        Emitters[3].ColorScale[1].Color = NewSmokeColor;
    }

    //Lets get the wind direction and speed and set the first sprite emitter accordingly
}

DefaultProperties
{
    Begin Object Class=SpriteEmitter Name=SpriteEmitter0
        FadeOut=True
        FadeIn=True
        RespawnDeadParticles=False
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        UseColorScale=True
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        Opacity=0.900000
        FadeOutStartTime=2.560000
        FadeInEndTime=0.480000
        MaxParticles=150
        SpinsPerSecondRange=(X=(Min=0.050000,Max=0.050000))
        StartSpinRange=(X=(Min=-0.500000,Max=0.500000))
        SizeScale(0)=(RelativeSize=0.100000)
        SizeScale(1)=(RelativeTime=0.600000,RelativeSize=0.500000)
        SizeScale(2)=(RelativeTime=1.000000,RelativeSize=1.250000)
        StartSizeRange=(X=(Min=50.000000,Max=50.000000),Y=(Min=50.000000,Max=50.000000),Z=(Min=50.000000,Max=50.000000))
        InitialParticlesPerSecond=6.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.Smoke.grenadesmoke'
        LifetimeRange=(Max=5.000000)
        StartVelocityRange=(X=(Min=50.000000,Max=60.000000),Y=(Min=-5.000000,Max=5.000000),Z=(Min=5.000000,Max=15.000000))
        VelocityLossRange=(X=(Min=0.100000,Max=0.200000),Y=(Min=0.100000,Max=0.200000),Z=(Min=0.100000,Max=0.200000))
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
        Acceleration=(Z=-0.200000)
        UseColorScale=True
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        Opacity=0.800000
        FadeOutFactor=(W=3.000000)
        FadeOutStartTime=32.000000
        FadeInEndTime=15.000000
        MaxParticles=4
        StartLocationRange=(X=(Min=-64.000000,Max=64.000000),Y=(Min=-64.000000,Max=64.000000),Z=(Min=25.000000,Max=150.000000))
        AddLocationFromOtherEmitter=0
        SpinsPerSecondRange=(X=(Min=0.003000,Max=0.004000))
        StartSpinRange=(X=(Min=-0.750000,Max=0.750000))
        SizeScale(0)=(RelativeSize=0.250000)
        SizeScale(1)=(RelativeTime=0.280000,RelativeSize=0.750000)
        SizeScale(2)=(RelativeTime=0.870000,RelativeSize=1.500000)
        StartSizeRange=(X=(Min=300.000000,Max=400.000000),Y=(Min=300.000000,Max=400.000000),Z=(Min=300.000000,Max=400.000000))
        InitialParticlesPerSecond=10.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.Smoke.grenadesmoke'
        LifetimeRange=(Min=50.000000,Max=50.000000)
        InitialDelayRange=(Min=4.000000,Max=4.000000)
        StartVelocityRange=(Z=(Min=1.000000,Max=3.000000))
        VelocityLossRange=(X=(Min=0.100000,Max=0.200000),Y=(Min=0.100000,Max=0.200000),Z=(Min=0.300000,Max=0.400000))
        AddVelocityFromOtherEmitter=0
    End Object
    Emitters(1)=SpriteEmitter'SpriteEmitter1'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter2
        FadeOut=True
        FadeIn=True
        RespawnDeadParticles=False
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        Acceleration=(Z=-0.200000)
        UseColorScale=True
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        Opacity=0.800000
        FadeOutFactor=(W=3.000000)
        FadeOutStartTime=42.000000
        FadeInEndTime=4.800000
        StartLocationRange=(X=(Min=-200.000000,Max=200.000000),Y=(Min=-200.000000,Max=200.000000),Z=(Max=100.000000))
        AddLocationFromOtherEmitter=0
        SpinsPerSecondRange=(X=(Min=0.003000,Max=0.004000))
        StartSpinRange=(X=(Min=-0.090000,Max=0.090000))
        SizeScale(0)=(RelativeSize=0.330000)
        SizeScale(1)=(RelativeTime=0.500000,RelativeSize=0.900000)
        SizeScale(2)=(RelativeTime=0.870000,RelativeSize=1.500000)
        StartSizeRange=(X=(Min=150.000000,Max=400.000000),Y=(Min=150.000000,Max=400.000000),Z=(Min=150.000000,Max=400.000000))
        InitialParticlesPerSecond=10.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.Smoke.grenadesmoke'
        LifetimeRange=(Min=60.000000,Max=60.000000)
        InitialDelayRange=(Min=3.000000,Max=5.000000)
        StartVelocityRange=(X=(Min=-5.000000,Max=5.000000),Y=(Min=-5.000000,Max=5.000000),Z=(Min=2.000000,Max=5.000000))
        VelocityLossRange=(X=(Min=0.100000,Max=0.200000),Y=(Min=0.100000,Max=0.200000),Z=(Min=0.300000,Max=0.400000))
        AddVelocityFromOtherEmitter=0
    End Object
    Emitters(2)=SpriteEmitter'SpriteEmitter2'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter3
        FadeOut=True
        FadeIn=True
        RespawnDeadParticles=False
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        Acceleration=(X=1.000000,Y=1.000000)
        UseColorScale=True
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        Opacity=0.500000
        FadeOutStartTime=6.000000
        FadeInEndTime=2.000000
        MaxParticles=55
        StartLocationRange=(X=(Min=-350.000000,Max=350.000000),Y=(Min=-350.000000,Max=350.000000),Z=(Max=50.000000))
        AddLocationFromOtherEmitter=2
        SpinsPerSecondRange=(X=(Min=0.025000,Max=0.050000))
        StartSpinRange=(X=(Min=-0.500000,Max=0.500000))
        SizeScale(0)=(RelativeTime=1.000000,RelativeSize=3.000000)
        StartSizeRange=(X=(Min=50.000000),Y=(Min=50.000000),Z=(Min=50.000000))
        InitialParticlesPerSecond=1.500000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.Smoke.grenadesmoke_fill'
        SecondsBeforeInactive=0.000000
        LifetimeRange=(Min=8.000000,Max=9.000000)
        InitialDelayRange=(Min=10.000000,Max=15.000000)
        VelocityLossRange=(X=(Min=0.150000,Max=0.150000),Y=(Min=0.150000,Max=0.150000),Z=(Min=0.100000,Max=0.100000))
        AddVelocityFromOtherEmitter=2
    End Object
    Emitters(3)=SpriteEmitter'SpriteEmitter3'


    AutoDestroy=true
    Style=STY_Masked
    bUnlit=true
    bDirectional=true
    bNoDelete=false
    RemoteRole=ROLE_SimulatedProxy
    bNetTemporary=true
    bHardAttach=true
    LifeSpan=80
}

//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_GrenadeSmokeEffect extends Emitter;

//Overrided to support smoke brightness override and wind direction/speed in DHLevelInfo
simulated function PostBeginPlay()
{
    local color NewSmokeColor;
    local byte  SmokeBrightnessValue;

    super.PostBeginPlay();

    //Lets change the smoke color if it's not set to default in DH_LevelInfo
    /*
        //Set the brightness value to the override in the level
        SmokeBrightnessValue = DarkestHourGame(Level.Game).DHSharedInfo.SmokeBrightnessOverride;

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
    */

    //Lets get the wind direction and speed and set the first sprite emitter accordingly
}

// Modified so in single player this effect is removed if the ResetGame option is used (note this won't work on a net client as Reset is only called on the server)
simulated function Reset()
{
    Destroy();
}

defaultproperties
{
    Begin Object Class=SpriteEmitter Name=SpriteEmitter0
        FadeOut=true
        FadeIn=true
        RespawnDeadParticles=false
        SpinParticles=true
        UseSizeScale=true
        UseRegularSizeScale=false
        UniformSize=true
        AutomaticInitialSpawning=false
        UseColorScale=true
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.0,Color=(B=255,G=255,R=255,A=255))
        Opacity=0.9
        FadeOutStartTime=2.56
        FadeInEndTime=0.48
        MaxParticles=150
        SpinsPerSecondRange=(X=(Min=0.05,Max=0.05))
        StartSpinRange=(X=(Min=-0.5,Max=0.5))
        SizeScale(0)=(RelativeSize=0.1)
        SizeScale(1)=(RelativeTime=0.6,RelativeSize=0.5)
        SizeScale(2)=(RelativeTime=1.0,RelativeSize=1.25)
        StartSizeRange=(X=(Min=50.0,Max=50.0),Y=(Min=50.0,Max=50.0),Z=(Min=50.0,Max=50.0))
        InitialParticlesPerSecond=6.0
        DrawStyle=PTDS_AlphaBlend
        Texture=texture'Effects_Tex.Smoke.grenadesmoke'
        LifetimeRange=(Max=5.0)
        StartVelocityRange=(X=(Min=50.0,Max=60.0),Y=(Min=-5.0,Max=5.0),Z=(Min=5.0,Max=15.0))
        VelocityLossRange=(X=(Min=0.1,Max=0.2),Y=(Min=0.1,Max=0.2),Z=(Min=0.1,Max=0.2))
    End Object
    Emitters(0)=SpriteEmitter'SpriteEmitter0'
    Begin Object Class=SpriteEmitter Name=SpriteEmitter1
        FadeOut=true
        FadeIn=true
        RespawnDeadParticles=false
        SpinParticles=true
        UseSizeScale=true
        UseRegularSizeScale=false
        UniformSize=true
        AutomaticInitialSpawning=false
        Acceleration=(Z=-0.2)
        UseColorScale=true
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.0,Color=(B=255,G=255,R=255,A=255))
        Opacity=0.8
        FadeOutFactor=(W=3.0)
        FadeOutStartTime=32.0
        FadeInEndTime=15.0
        MaxParticles=4
        StartLocationRange=(X=(Min=-64.0,Max=64.0),Y=(Min=-64.0,Max=64.0),Z=(Min=25.0,Max=150.0))
        AddLocationFromOtherEmitter=0
        SpinsPerSecondRange=(X=(Min=0.003,Max=0.004))
        StartSpinRange=(X=(Min=-0.75,Max=0.75))
        SizeScale(0)=(RelativeSize=0.25)
        SizeScale(1)=(RelativeTime=0.28,RelativeSize=0.75)
        SizeScale(2)=(RelativeTime=0.87,RelativeSize=1.5)
        StartSizeRange=(X=(Min=300.0,Max=400.0),Y=(Min=300.0,Max=400.0),Z=(Min=300.0,Max=400.0))
        InitialParticlesPerSecond=10.0
        DrawStyle=PTDS_AlphaBlend
        Texture=texture'Effects_Tex.Smoke.grenadesmoke'
        LifetimeRange=(Min=50.0,Max=50.0)
        InitialDelayRange=(Min=4.0,Max=4.0)
        StartVelocityRange=(Z=(Min=1.0,Max=3.0))
        VelocityLossRange=(X=(Min=0.1,Max=0.2),Y=(Min=0.1,Max=0.2),Z=(Min=0.3,Max=0.4))
        AddVelocityFromOtherEmitter=0
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
        Acceleration=(Z=-0.2)
        UseColorScale=true
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.0,Color=(B=255,G=255,R=255,A=255))
        Opacity=0.8
        FadeOutFactor=(W=3.0)
        FadeOutStartTime=42.0
        FadeInEndTime=4.8
        StartLocationRange=(X=(Min=-200.0,Max=200.0),Y=(Min=-200.0,Max=200.0),Z=(Max=100.0))
        AddLocationFromOtherEmitter=0
        SpinsPerSecondRange=(X=(Min=0.003,Max=0.004))
        StartSpinRange=(X=(Min=-0.09,Max=0.09))
        SizeScale(0)=(RelativeSize=0.33)
        SizeScale(1)=(RelativeTime=0.5,RelativeSize=0.9)
        SizeScale(2)=(RelativeTime=0.87,RelativeSize=1.5)
        StartSizeRange=(X=(Min=150.0,Max=400.0),Y=(Min=150.0,Max=400.0),Z=(Min=150.0,Max=400.0))
        InitialParticlesPerSecond=10.0
        DrawStyle=PTDS_AlphaBlend
        Texture=texture'Effects_Tex.Smoke.grenadesmoke'
        LifetimeRange=(Min=60.0,Max=60.0)
        InitialDelayRange=(Min=3.0,Max=5.0)
        StartVelocityRange=(X=(Min=-5.0,Max=5.0),Y=(Min=-5.0,Max=5.0),Z=(Min=2.0,Max=5.0))
        VelocityLossRange=(X=(Min=0.1,Max=0.2),Y=(Min=0.1,Max=0.2),Z=(Min=0.3,Max=0.4))
        AddVelocityFromOtherEmitter=0
    End Object
    Emitters(2)=SpriteEmitter'SpriteEmitter2'
    Begin Object Class=SpriteEmitter Name=SpriteEmitter3
        FadeOut=true
        FadeIn=true
        RespawnDeadParticles=false
        SpinParticles=true
        UseSizeScale=true
        UseRegularSizeScale=false
        UniformSize=true
        AutomaticInitialSpawning=false
        Acceleration=(X=1.0,Y=1.0)
        UseColorScale=true
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.0,Color=(B=255,G=255,R=255,A=255))
        Opacity=0.5
        FadeOutStartTime=6.0
        FadeInEndTime=2.0
        MaxParticles=55
        StartLocationRange=(X=(Min=-350.0,Max=350.0),Y=(Min=-350.0,Max=350.0),Z=(Max=50.0))
        AddLocationFromOtherEmitter=2
        SpinsPerSecondRange=(X=(Min=0.025,Max=0.05))
        StartSpinRange=(X=(Min=-0.5,Max=0.5))
        SizeScale(0)=(RelativeTime=1.0,RelativeSize=3.0)
        StartSizeRange=(X=(Min=50.0),Y=(Min=50.0),Z=(Min=50.0))
        InitialParticlesPerSecond=1.5
        DrawStyle=PTDS_AlphaBlend
        Texture=texture'Effects_Tex.Smoke.grenadesmoke_fill'
        SecondsBeforeInactive=0.0
        LifetimeRange=(Min=8.0,Max=9.0)
        InitialDelayRange=(Min=10.0,Max=15.0)
        VelocityLossRange=(X=(Min=0.15,Max=0.15),Y=(Min=0.15,Max=0.15),Z=(Min=0.1,Max=0.1))
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
    LifeSpan=65.0
}

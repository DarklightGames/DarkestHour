//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHSmokeEffect_ColoredGrenade extends DHSmokeEffectBase
    abstract;

var(Color)  color   SmokeColor;          // allows the smoke colour to be set in default properties, so we don't need different coloured smoke textures
var(Time)   float   SmokeReductionDelay; // after this time, Timer() begins to reduce the velocity, size, lifetime & fade time of the smoke particles

// Set the SpriteEmitter colour properties based on designated SmokeColor, & set a timer to start reducing the smoke effect after the SmokeReductionDelay period
simulated function PostBeginPlay()
{
    Emitters[0].ColorMultiplierRange.X.Min = float(SmokeColor.R) / 255.0; // red
    Emitters[0].ColorMultiplierRange.X.Max = Emitters[0].ColorMultiplierRange.X.Min;

    Emitters[0].ColorMultiplierRange.Y.Min = float(SmokeColor.G) / 255.0; // green
    Emitters[0].ColorMultiplierRange.Y.Max = Emitters[0].ColorMultiplierRange.Y.Min;

    Emitters[0].ColorMultiplierRange.Z.Min = float(SmokeColor.B) / 255.0; // blue
    Emitters[0].ColorMultiplierRange.Z.Max = Emitters[0].ColorMultiplierRange.Z.Min;

    SetTimer(SmokeReductionDelay, false);
}

// After the SmokeReductionDelay period, this gradually reduces the velocity, size, lifetime & fade time of the smoke particles
simulated function Timer()
{
    Emitters[0].StartVelocityRange.X.Min += 1.0;
    Emitters[0].StartVelocityRange.X.Max -= 0.5;
    Emitters[0].StartVelocityRange.Y.Min += 1.0;
    Emitters[0].StartVelocityRange.Y.Max -= 1.0;
    Emitters[0].StartVelocityRange.Z.Min -= 3.5;
    Emitters[0].StartVelocityRange.Z.Max -= 5.0;
    Emitters[0].StartSizeRange.X.Min -= 2.5;
    Emitters[0].StartSizeRange.X.Max -= 2.5;
    Emitters[0].StartSizeRange.Y.Min -= 2.5;
    Emitters[0].StartSizeRange.Y.Max -= 2.5;
    Emitters[0].StartSizeRange.Z.Min -= 2.5;
    Emitters[0].StartSizeRange.Z.Max -= 2.5;
    Emitters[0].LifetimeRange.Min -= 1.0;
    Emitters[0].LifetimeRange.Max -= 1.0;
    Emitters[0].FadeOutStartTime -= 1.0;

    if (Emitters[0].StartVelocityRange.X.Min < 0.0)
    {
        SetTimer(1.0, false);
    }
}

defaultproperties
{
    LifeSpan=50.0
    SmokeReductionDelay=20.0

    Begin Object Class=SpriteEmitter Name=SpriteEmitter0
        FadeOut=true
        FadeIn=true
        RespawnDeadParticles=false
        SpinParticles=true
        UseSizeScale=true
        UseRegularSizeScale=false
        UniformSize=true
        AutomaticInitialSpawning=false
        Acceleration=(X=7.0)
        Opacity=0.6
        FadeOutStartTime=18.0
        FadeInEndTime=0.5
        MaxParticles=160
        SpinsPerSecondRange=(X=(Min=0.05,Max=0.05))
        StartSpinRange=(X=(Min=-0.5,Max=0.5))
        SizeScale(0)=(RelativeSize=0.1)
        SizeScale(1)=(RelativeTime=0.05,RelativeSize=0.5)
        SizeScale(2)=(RelativeTime=0.1,RelativeSize=1.0)
        SizeScale(3)=(RelativeTime=1.0,RelativeSize=4.0)
        StartSizeRange=(X=(Min=50.0,Max=50.0),Y=(Min=50.0,Max=50.0),Z=(Min=50.0,Max=50.0))
        InitialParticlesPerSecond=5.0
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.Smoke.grenadesmoke'
        LifetimeRange=(Min=25.0,Max=30.0)
        StartVelocityRange=(X=(Min=-15.0,Max=15.0),Y=(Min=-10.0,Max=10.0),Z=(Min=40.0,Max=70.0))
        VelocityLossRange=(X=(Min=0.2,Max=0.2),Y=(Min=0.05,Max=0.05),Z=(Min=0.1,Max=0.1))
    End Object
    Emitters(0)=SpriteEmitter'SpriteEmitter0'
}

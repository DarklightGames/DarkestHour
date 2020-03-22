//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DHRainEmitter extends Emitter;

// TODO: check if we're in a ran or no-rain zone!
var xWeatherEffect WeatherEffect;

function PostBeginPlay()
{
    local xWeatherEffect WE;

    super.PostBeginPlay();

    foreach AllActors(class'xWeatherEffect', WE)
    {
        if (WE.WeatherType == WT_Rain)
        {
            WeatherEffect = WE;
            break;
        }
    }

    if (WeatherEffect == none)
    {
        // No corresponding weather effect, just delete us.
        Destroy();
    }

    SetRainStrength(WeatherEffect.numParticles);
}

function

function SetRainStrength(int P)
{
    Emitters[0].ParticlesPerSecond = P;
    Emitters[0].InitialParticlesPerSecond = P;
}

defaultproperties
{
    Begin Object Class=SpriteEmitter Name=SpriteEmitter807
        UseCollision=True
        UseMaxCollisions=True
        UniformSize=True
        AutomaticInitialSpawning=False
        Acceleration=(Z=-4096.000000)
        ExtentMultiplier=(X=0.000000,Y=0.000000,Z=0.000000)
        DampingFactorRange=(X=(Min=0.000000,Max=0.000000),Y=(Min=0.000000,Max=0.000000),Z=(Min=0.000000,Max=0.000000))
        MaxCollisions=(Min=1.000000,Max=1.000000)
        SpawnFromOtherEmitter=1
        SpawnAmount=1
        MaxParticles=256
        StartLocationRange=(Y=(Min=-512.000000,Max=512.000000),X=(Min=-512.000000,Max=512.000000),Z=(Min=2048,Max=2048))c
        UseRotationFrom=PTRS_Actor
        StartSizeRange=(X=(Min=1.000000,Max=1.000000),Y=(Min=1.000000,Max=1.000000))
        ParticlesPerSecond=64.000000
        InitialParticlesPerSecond=64.000000
        Texture=None
        LifetimeRange=(Min=90.000000,Max=90.000000)
    End Object
    Emitters(0)=SpriteEmitter'DHRainEmitter.SpriteEmitter807'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter808
        ProjectionNormal=(Z=0.000000)
        UseColorScale=True
        FadeOut=True
        RespawnDeadParticles=False
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        Acceleration=(Z=1000.000000)
        ColorScale(0)=(Color=(B=200,G=190,R=190))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=100,G=100,R=100))
        Opacity=0.500000
        FadeOutFactor=(W=2.000000)
        MaxParticles=64
        SizeScale(0)=(RelativeSize=1.000000)
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=5.000000)
        StartSizeRange=(X=(Min=4.000000,Max=4.000000))
        Texture=Texture'DH_FX_tex.weather.WaterSplash'
        TextureUSubdivisions=1
        TextureVSubdivisions=1
        LifetimeRange=(Min=0.200000,Max=0.400000)
        StartVelocityRange=(X=(Min=-10.000000,Max=-20.000000),Z=(Min=-5.000000,Max=-10.000000))
    End Object
    Emitters(1)=SpriteEmitter'DHRainEmitter.SpriteEmitter808'

    DrawScale=2.000000

    AutoDestroy=false
    bNoDelete=false
}


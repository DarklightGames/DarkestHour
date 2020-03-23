//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DHRainEmitter extends Emitter;

// TODO: check if we're in a ran or no-rain zone!
var xWeatherEffect WeatherEffect;
var array<Volume> NoRainVolumes;
var int VolumeIndex;

function PostBeginPlay()
{
    local xWeatherEffect WE;
    local Volume V;

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
        return;
    }

    SetRainStrength(WeatherEffect.numParticles);

    // Accumulate all no-rain volumes
    foreach AllActors(class'Volume', V, WeatherEffect.Tag)
    {
        NoRainVolumes[NoRainVolumes.Length] = V;
    }

    SetTimer(1.0, true);
}

function Timer()
{
    UpdatedVolumeIndex();
}

function bool IsInNoRainVolume()
{
    return VolumeIndex != -1;
}

function UpdatedVolumeIndex()
{
    local int i;
    local int OldVolumeIndex;

    if (VolumeIndex != -1 && NoRainVolumes[VolumeIndex].Encompasses(self))
    {
        // We are in the same volume we were in before, nothing to see here.
        return;
    }

    OldVolumeIndex = VolumeIndex;

    VolumeIndex = -1;

    for (i = 0; i < NoRainVolumes.Length; ++i)
    {
        if (NoRainVolumes[i].Encompasses(self))
        {
            VolumeIndex = i;
            break;
        }
    }

    if (VolumeIndex != OldVolumeIndex)
    {
        VolumeIndexChanged();
    }
}

function VolumeIndexChanged()
{
    local bool bIsInNoRainVolume;
    local int i;

    bIsInNoRainVolume = IsInNoRainVolume();

    for (i = 0; i < Emitters.Length; ++i)
    {
        Emitters[i].Disabled = bIsInNoRainVolume;
    }

    Log("VolumeIndexChanged" @ VolumeIndex @ bIsInNoRainVolume);
}

function SetRainStrength(int P)
{
    Emitters[0].ParticlesPerSecond = P;
    Emitters[0].InitialParticlesPerSecond = P;
}

defaultproperties
{
    RemoteRole=ROLE_None
    bHidden=false

    VolumeIndex=-1

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
        StartLocationRange=(Y=(Min=-512.000000,Max=512.000000),X=(Min=-512.000000,Max=512.000000),Z=(Min=1024,Max=1024))
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


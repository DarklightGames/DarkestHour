//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DHMGSteam extends Emitter;

var     bool        bActive;

simulated function Trigger(Actor Other, Pawn EventInstigator)
{
    if (bActive)
    {
        StopSteam();
        bActive = false;
    }
    else
    {
        StartSteam();
        bActive = true;
    }
}

function StopSteam()
{
    Emitters[0].ParticlesPerSecond = 0;
    Emitters[0].InitialParticlesPerSecond = 0;
    Emitters[0].RespawnDeadParticles = false;
}

function StartSteam()
{
    Emitters[0].ParticlesPerSecond = 3.0;
    Emitters[0].InitialParticlesPerSecond = 3.0;
    Emitters[0].AllParticlesDead = false;
    Emitters[0].RespawnDeadParticles = false;
}

defaultproperties
{
    Begin Object Class=SpriteEmitter Name=SpriteEmitter0
        FadeOut=True
        FadeIn=True
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        Acceleration=(Z=25.0)
        FadeOutStartTime=1.0
        FadeInEndTime=0.2
        MaxParticles=64
        Name="SpriteEmitter2"
        SpinsPerSecondRange=(X=(Min=0.1,Max=0.2))
        StartSpinRange=(X=(Min=-0.5,Max=0.5))
        SizeScale(0)=(RelativeTime=1.0,RelativeSize=16.0)
        StartSizeRange=(X=(Min=1.5,Max=4.0),Y=(Min=1.5,Max=4.0),Z=(Min=1.5,Max=4.0))
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.explosions.DSmoke_2'
        SecondsBeforeInactive=0.0
        LifetimeRange=(Min=2.0)
        StartVelocityRange=(Z=(Min=8.0,Max=12.0))
    End Object
    Emitters(0)=SpriteEmitter'SpriteEmitter0'


    //use the following tag in an event to stop the steam
    Tag="mgSteam"
    bBlockActors=false
    bBlockPlayers=false
    RemoteRole=ROLE_None
    Physics=PHYS_None
    bHardAttach=true
    bNoDelete=false
    AutoDestroy=false
}

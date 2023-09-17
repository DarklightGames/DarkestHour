//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHMuzzleSmoke extends Emitter;

var float VarOpacity;

simulated function Trigger(Actor Other, Pawn EventInstigator)
{
    VarOpacity=FMax(0.50, 0.85);
    
    if (FRand()< 0.75)
    {
        Emitters[0].SpawnParticle(1);
    }
    else
    {
        Emitters[0].SpawnParticle(2);
    } 

    Emitters[0].Opacity=VarOpacity;
}

defaultproperties
{
    Begin Object Class=SpriteEmitter Name=SpriteEmitter0
    FadeOut=True
    RespawnDeadParticles=False
    SpinParticles=True
    UseSizeScale=True
    UseRegularSizeScale=False
    UniformSize=True
    AutomaticInitialSpawning=false
    UseRandomSubdivision=True
    BlendBetweenSubdivisions=True
    UseVelocityScale=True
    Acceleration=(Z=25.000000)
    ColorScale(0)=(Color=(A=255))
    ColorScale(1)=(RelativeTime=1.000000,Color=(A=255))
    FadeOutStartTime=0.2
    MaxParticles=64
    StartLocationRange=(X=(Min=-10.000000,Max=10.000000),Y=(Min=-5.0,Max=5.0),Z=(Min=-5.0,Max=5.0))
    UseRotationFrom=PTRS_Actor
    SpinsPerSecondRange=(X=(Min=0.040000,Max=0.060000))
    StartSpinRange=(X=(Min=-0.500000,Max=0.500000))
    SizeScale(0)=(RelativeSize=0.500000)
    SizeScale(1)=(RelativeTime=0.15000,RelativeSize=4.000000)
    SizeScale(2)=(RelativeTime=1.000000,RelativeSize=3.5000000)
    StartSizeRange=(X=(Min=10.000000,Max=15.000000))
    DrawStyle=PTDS_AlphaBlend
    Texture=Texture'Effects_Tex.BulletHits.metalsmokefinal'
    TextureUSubdivisions=2
    TextureVSubdivisions=2
    LifetimeRange=(Min=0.75,Max=0.75)
    StartVelocityRange=(Y=(Min=-15.000000,Max=15.000000),Z=(Min=-15.000000,Max=15.000000))
    VelocityScale(0)=(RelativeVelocity=(X=1.000000,Y=1.000000,Z=1.000000))
    VelocityScale(1)=(RelativeTime=0.475000,RelativeVelocity=(X=0.100000,Y=0.200000,Z=0.200000))
    VelocityScale(2)=(RelativeTime=1.000000)
    End Object
    Emitters(0)=SpriteEmitter'SpriteEmitter0'

    Style=STY_Particle
    bUnlit=true
    bDirectional=True
    bNoDelete=false
    RemoteRole=ROLE_None
    bNetTemporary=true
    bHardAttach=false
    bOnlyOwnerSee=true
}

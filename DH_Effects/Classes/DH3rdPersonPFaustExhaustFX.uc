//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2021
//==============================================================================

class DH3rdPersonPFaustExhaustFX extends ROMuzzleFlash3rd;

simulated function Trigger(Actor Other, Pawn EventInstigator)
{
    Emitters[0].SpawnParticle(15);
    Emitters[0].InitialParticlesPerSecond=100;
    Emitters[1].SpawnParticle(1); //8
}

defaultproperties
{

    Begin Object Class=SpriteEmitter Name=SpriteEmitter0
        FadeOut=true
        UseColorScale=True
        RespawnDeadParticles=False
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        UseRandomSubdivision=True
        ColorScale(0)=(Color=(B=192,G=192,R=192,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=192,G=192,R=192))
        MaxParticles=15
        Opacity=0.25
        FadeOutStartTime=1.5
        Name="Smoke"
        StartLocationOffset=(X=-50.000000)
        StartLocationRange=(X=(Min=-5.000000,Max=5.000000))
        UseRotationFrom=PTRS_Actor
        SpinsPerSecondRange=(X=(Max=0.050000))
        StartSpinRange=(X=(Max=1.000000))
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=3.000000)
        DrawStyle=PTDS_Brighten
        Texture=Texture'Effects_Tex.BulletHits.metalsmokefinal'
        TextureUSubdivisions=2
        TextureVSubdivisions=2
        LifetimeRange=(Min=2.500000,Max=3.500000)
        StartVelocityRange=(X=(Min=-300.000000,Max=-1500.000000),Y=(Min=-100.000000,Max=100.000000),Z=(Min=-100.000000,Max=100.000000))
        VelocityLossRange=(X=(Min=1.000000,Max=5.000000),Y=(Min=1.000000,Max=5.000000),Z=(Min=1.000000,Max=5.000000))
        VelocityScale(0)=(RelativeVelocity=(X=1.000000,Y=1.000000,Z=1.000000))
        VelocityScale(1)=(RelativeTime=0.125000,RelativeVelocity=(X=0.200000,Y=0.200000,Z=0.200000))
        VelocityScale(2)=(RelativeTime=1.000000)
    End Object
    Emitters(0)=SpriteEmitter'SpriteEmitter0'

    Begin Object Class=BeamEmitter Name=BeamEmitter0
        BeamDistanceRange=(Min=100.000000,Max=200.000000)
        DetermineEndPointBy=PTEP_Distance
        RotatingSheets=3
        UseColorScale=True
        FadeOut=True
        RespawnDeadParticles=False
        UniformSize=True
        AutomaticInitialSpawning=False
        StartLocationOffset=(X=-20.000000)
        ColorScale(0)=(Color=(B=0,G=0,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        Opacity=0.1
        FadeOutStartTime=0.05
        MaxParticles=1
        UseRotationFrom=PTRS_Actor
        StartSizeRange=(X=(Min=100.0,Max=200.000000),Y=(Min=100.0,Max=200.000000),Z=(Min=100.0))
        Texture=Texture'DH_FX_Tex.Effects.Spotlight'
        LifetimeRange=(Min=0.100000,Max=0.150000)
        StartVelocityRange=(X=(Min=-50.000000,Max=-100.000000))
    End Object
    Emitters(1)=BeamEmitter'BeamEmitter0'
}

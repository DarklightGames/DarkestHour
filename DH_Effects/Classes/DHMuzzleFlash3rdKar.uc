//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2021
//==============================================================================

class DHMuzzleFlash3rdKar extends ROMuzzleFlash3rd;

simulated function Trigger(Actor Other, Pawn EventInstigator)
{
    Emitters[0].SpawnParticle(1);
    Emitters[1].SpawnParticle(1);
    Emitters[2].SpawnParticle(8);
    Emitters[2].InitialParticlesPerSecond=100;
    Emitters[3].SpawnParticle(6);
}

defaultproperties
{  
    Begin Object Class=BeamEmitter Name=BeamEmitter6
        BeamDistanceRange=(Min=30.000000,Max=50.000000)
        DetermineEndPointBy=PTEP_Distance
        RotatingSheets=2
        FadeOut=True
        RespawnDeadParticles=False
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        ColorScale(0)=(Color=(B=200,G=200,R=200,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=200,G=200,R=200,A=255))
        Opacity=0.6
        FadeOutStartTime=0.050000
        MaxParticles=1
        name="flash"
        StartLocationOffset=(X=-2.000000)
        UseRotationFrom=PTRS_Actor
        SizeScale(0)=(RelativeSize=0.100000)
        SizeScale(1)=(RelativeTime=0.140000,RelativeSize=2.000000)
        SizeScale(2)=(RelativeTime=1.000000,RelativeSize=0.500000)
        StartSizeRange=(X=(Min=5.000000,Max=8.000000),Y=(Min=5.000000,Max=8.000000),Z=(Min=30.000000))
        InitialParticlesPerSecond=100.000000
        Texture=Texture'DH_FX_Tex.Weapons.50calmuzzleflash'
        LifetimeRange=(Min=0.150000,Max=0.200000)
        StartVelocityRange=(X=(Min=50.000000,Max=100.000000))
    End Object
    Emitters(0)=BeamEmitter'BeamEmitter6'

    Begin Object Class=BeamEmitter Name=BeamEmitter1
        FadeOut=true
        BeamDistanceRange=(Min=40.000000,Max=75.000000)
        DetermineEndPointBy=PTEP_Distance
        RotatingSheets=2
        RespawnDeadParticles=False
        UseSizeScale=True
        AutomaticInitialSpawning=False
        ColorScale(0)=(Color=(B=200,G=200,R=200,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=200,G=200,R=200,A=255))
        FadeOutStartTime=0.150000
        Opacity=0.25
        MaxParticles=1
        name="spike_smoke"
        StartLocationOffset=(X=-4.000000)
        UseRotationFrom=PTRS_Actor
        SizeScale(0)=(RelativeSize=0.1)
        SizeScale(1)=(RelativeTime=0.140000,RelativeSize=1.000000)
        SizeScale(2)=(RelativeTime=1.000000,RelativeSize=2.5000000)
        StartSizeRange=(X=(Min=5.000000,Max=8.000000),Y=(Min=5.000000,Max=8.000000),Z=(Min=40.000000))
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'DH_FX_Tex.Effects.Impact03'
        LifetimeRange=(Min=0.1500000,Max=0.20000)
        StartVelocityRange=(X=(Min=300.000000,Max=500.000000))
    End Object
    Emitters(1)=BeamEmitter'BeamEmitter1'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter6
        FadeOut=True
        RespawnDeadParticles=False
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        UseRandomSubdivision=True
        UseVelocityScale=True
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        Opacity=0.75
        FadeOutStartTime=0.25
        MaxParticles=64
        Name="gun_smoke"
        StartLocationRange=(X=(Min=-15.0,Max=20.000000))
        UseRotationFrom=PTRS_Actor
        SpinsPerSecondRange=(X=(Min=-0.500000,Max=0.500000),Y=(Min=-0.500000,Max=0.500000),Z=(Min=-0.500000,Max=0.500000))
        SizeScale(0)=(RelativeSize=0.1)
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=2.500000)
        StartSizeRange=(X=(Min=8.000000,Max=12.000000))
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.BulletHits.stonesmokefinal'
        TextureUSubdivisions=2
        TextureVSubdivisions=2
        LifetimeRange=(Min=0.55,Max=0.95)
        StartVelocityRange=(X=(Min=100.000000,Max=200.0),Y=(Min=-10.0000,Max=15.000),Z=(Min=-15.000,Max=10.000))
        VelocityScale(0)=(RelativeVelocity=(X=1.000000,Y=1.000000,Z=1.000000))
        VelocityScale(1)=(RelativeTime=0.500000,RelativeVelocity=(X=0.200000,Y=0.700000,Z=0.700000))
        VelocityScale(2)=(RelativeTime=1.000000)
    End Object
    Emitters(2)=SpriteEmitter'SpriteEmitter6'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter80
        UseDirectionAs=PTDU_UpAndNormal
        ProjectionNormal=(X=1.000000,Y=0.500000)
        UseColorScale=True
        RespawnDeadParticles=False
        SpinParticles=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        UseRandomSubdivision=True
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=64,G=128,R=255,A=255))
        ColorScaleRepeats=4
        MaxParticles=64
        name="sparks"
        UseRotationFrom=PTRS_Actor
        SpinsPerSecondRange=(X=(Min=5.00000,Max=10.000000))
        StartSpinRange=(X=(Min=-0.500000,Max=1.000000))
        StartSizeRange=(X=(Min=0.85,Max=1.25))
        DrawStyle=PTDS_Brighten
        Texture=Texture'Effects_Tex.Smoke.Sparks'
        TextureUSubdivisions=2
        TextureVSubdivisions=2
        LifetimeRange=(Min=0.15,Max=0.2)
        StartVelocityRange=(X=(Min=150.000000,Max=250.000000),Y=(Min=-10.000000,Max=15.000000),Z=(Min=-15.000000,Max=10.000000))
    End Object
    Emitters(3)=SpriteEmitter'SpriteEmitter80'
}

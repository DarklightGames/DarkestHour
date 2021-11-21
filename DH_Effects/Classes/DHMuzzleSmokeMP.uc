//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2021
//==============================================================================

class DHMuzzleSmokeMP extends Emitter;

simulated function Trigger(Actor Other, Pawn EventInstigator)
{
    Emitters[0].SpawnParticle(1);
    Emitters[1].SpawnParticle(1);
    Emitters[2].SpawnParticle(1);
}

defaultproperties
{
    Begin Object Class=SpriteEmitter Name=SpriteEmitter0
        UseColorScale=true
        FadeOut=True
        FadeIn=True
        RespawnDeadParticles=False
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        //UseRandomSubdivision=True
        //BlendBetweenSubdivisions=True
        UseVelocityScale=True
        Acceleration=(Z=40.0)
        ColorScale(0)=(Color=(B=128,G=128,R=128,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=128,G=128,R=128,A=255))
        Opacity=0.5
        FadeOutStartTime=0.25
        FadeInEndTime=0.10
        MaxParticles=64
        Name="gun_smoke"
        StartLocationRange=(X=(Min=100.0,Max=150.000000),Y=(Min=-10.0,Max=10.000000),Z=(Min=-10.0,Max=10.000000))
        UseRotationFrom=PTRS_Actor
        StartSpinRange=(X=(Min=-1.000000,Max=1.000000))
        SpinsPerSecondRange=(X=(Min=-0.050000,Max=0.050000))
        SizeScale(0)=(RelativeSize=6.000000)
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=8.000000)
        StartSizeRange=(X=(Min=10.000000,Max=15.000000))
        DrawStyle=PTDS_Brighten
        Texture=Texture'DH_FX_Tex.dust.gunsmoke02'
        LifetimeRange=(Min=1.0,Max=1.2)
        InitialDelayRange=(Max=0.2)
        StartVelocityRange=(X=(Min=100.0000,Max=135.000),Y=(Min=-10.0000,Max=15.000),Z=(Min=-15.000,Max=10.000))
    End Object
    Emitters(0)=SpriteEmitter'SpriteEmitter0'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter1
        RespawnDeadParticles=False
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        //BlendBetweenSubdivisions=True
        UseRandomSubdivision=True
        Acceleration=(Z=25.000000)
        ColorScale(0)=(Color=(A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(A=255))
        Opacity=0.85
        MaxParticles=64
        Name="smoke_flash"
        StartLocationRange=(X=(Min=10.0,Max=10.000000))
        UseRotationFrom=PTRS_Actor
        SpinsPerSecondRange=(X=(Min=0.080000,Max=0.100000))
        StartSpinRange=(X=(Min=-0.500000,Max=0.500000))
        SizeScale(0)=(RelativeSize=5.00000)
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=4.000000)
        StartSizeRange=(X=(Min=9.000000,Max=12.000000))
        DrawStyle=PTDS_Brighten
        Texture=Texture'Effects_Tex.Weapons.MP3rdPmuzzle_smoke1frame'
        LifetimeRange=(Min=0.1,Max=0.1)
    End Object
    Emitters(1)=SpriteEmitter'SpriteEmitter1'

    Begin Object Class=BeamEmitter Name=BeamEmitter1
        FadeOut=true
        BeamDistanceRange=(Min=160.000000,Max=325.000000)
        DetermineEndPointBy=PTEP_Distance
        RotatingSheets=2
        RespawnDeadParticles=False
        UseSizeScale=True
        AutomaticInitialSpawning=False
        ColorScale(0)=(Color=(B=200,G=200,R=200,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=200,G=200,R=200,A=255))
        FadeOutStartTime=0.150000
        Opacity=0.35
        MaxParticles=1
        name="spike_smoke"
        StartLocationOffset=(X=-4.000000)
        UseRotationFrom=PTRS_Actor
        SizeScale(0)=(RelativeSize=0.1)
        SizeScale(1)=(RelativeTime=0.140000,RelativeSize=1.000000)
        SizeScale(2)=(RelativeTime=1.000000,RelativeSize=2.5000000)
        StartSizeRange=(X=(Min=12.000000,Max=18.000000),Y=(Min=12.000000,Max=18.000000),Z=(Min=160.000000))
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'DH_FX_Tex.Effects.Impact03'
        LifetimeRange=(Min=0.1500000,Max=0.20000)
        StartVelocityRange=(X=(Min=100.000000,Max=200.000000))
    End Object
    Emitters(2)=BeamEmitter'BeamEmitter1'

    Style=STY_Masked
    bUnlit=true
    bDirectional=True
    bNoDelete=false
    RemoteRole=ROLE_None
    bNetTemporary=true
    bHardAttach=false
    bOnlyOwnerSee=true
}

//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHMuzzleSmokePPSH extends Emitter;

//var float VarOpacity;

/*
simulated function Trigger(Actor Other, Pawn EventInstigator)
{
    VarOpacity=FMax(0.25, 0.45);
    
    if (FRand()< 0.75)
    {
        Emitters[0].SpawnParticle(1);
        Emitters[1].SpawnParticle(1);
    }
    else
    {
        Emitters[0].SpawnParticle(2);
        Emitters[1].SpawnParticle(1);
    } 

    Emitters[0].Opacity=VarOpacity;
}
*/

defaultproperties
{
    Begin Object Class=SpriteEmitter Name=SpriteEmitter0
        FadeOut=True
        RespawnDeadParticles=False
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        UseRandomSubdivision=True
        Acceleration=(Y=100.000000)
        ColorScale(0)=(Color=(B=95,G=95,R=95,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=150,G=150,R=150))
        Opacity=0.45000000
        FadeOutStartTime=0.975000
        Name="muzzle_smoke"
        //StartLocationOffset=(X=-56.000000)
        UseRotationFrom=PTRS_Actor
        SpinsPerSecondRange=(X=(Max=0.050000))
        StartSpinRange=(X=(Max=1.000000))
        StartSizeRange=(X=(Min=75.00000,Max=85.00000))
        SizeScale(0)=(RelativeSize=0.500000)
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=3.000000)
        //InitialParticlesPerSecond=50000.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.BulletHits.metalsmokefinal'
        TextureUSubdivisions=2
        TextureVSubdivisions=2
        LifetimeRange=(Min=2.00000,Max=2.500000)
        StartVelocityRange=(X=(Min=300.000000,Max=1500.000000),Y=(Min=-100.000000,Max=125.000000),Z=(Min=-125.000000,Max=100.000000))
        VelocityLossRange=(X=(Min=1.000000,Max=1.75000000),Y=(Min=1.000000,Max=1.750000),Z=(Min=1.000000,Max=1.7500000))
        VelocityScale(0)=(RelativeVelocity=(X=1.000000,Y=1.000000,Z=1.000000))
        VelocityScale(1)=(RelativeTime=0.125000,RelativeVelocity=(X=0.200000,Y=0.200000,Z=0.200000))
        VelocityScale(2)=(RelativeTime=1.000000)
    End Object
    Emitters(0)=SpriteEmitter'SpriteEmitter0'

    Begin Object Class=BeamEmitter Name=BeamEmitter1
        UseColorScale=false   
        BeamDistanceRange=(Min=80.000000,Max=100.000000)
        DetermineEndPointBy=PTEP_Distance
        RotatingSheets=2
        RespawnDeadParticles=False
        AutomaticInitialSpawning=False
        ColorScale(0)=(Color=(G=128,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=64,G=128,R=255,A=255))
        StartLocationOffset=(X=-2.000000)
        Opacity=0.25
        UseRotationFrom=PTRS_Actor
        StartSizeRange=(X=(Min=60.000000,Max=80.000000),Y=(Min=60.000000,Max=80.000000),Z=(Min=60.000000,Max=80.000000))
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'DH_FX_Tex.Effects.Impact01'
        LifetimeRange=(Min=0.1150000,Max=0.1150000)
        StartVelocityRange=(Y=(Min=100.000000,Max=250.000000))
    End Object
    Emitters(1)=BeamEmitter'BeamEmitter1'

    Style=STY_Particle
    bUnlit=true
    bDirectional=True
    bNoDelete=false
    RemoteRole=ROLE_None
    bNetTemporary=true
    bHardAttach=false
    bOnlyOwnerSee=true
}

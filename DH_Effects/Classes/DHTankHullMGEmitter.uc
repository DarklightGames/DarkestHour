//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2021
//==============================================================================

//General muzzle flash effect class for all DH tank/AFV hull and external mg's

class DHTankHullMGEmitter extends WeaponAmbientEmitter;

simulated function SetEmitterStatus(bool bEnabled)
{
    if(bEnabled)
    {
        Emitters[0].ParticlesPerSecond = 30.0;
        Emitters[0].InitialParticlesPerSecond = 30.0;
        Emitters[0].AllParticlesDead = false;
        Emitters[1].ParticlesPerSecond = 30.0;
        Emitters[1].InitialParticlesPerSecond = 30.0;
        Emitters[1].AllParticlesDead = false;
        Emitters[2].ParticlesPerSecond = 30.0;
        Emitters[2].InitialParticlesPerSecond = 30.0;
        Emitters[2].AllParticlesDead = false;
    }
    else
    {
        Emitters[0].ParticlesPerSecond = 0.0;
        Emitters[0].InitialParticlesPerSecond = 0.0;
        Emitters[1].ParticlesPerSecond = 0.0;
        Emitters[1].InitialParticlesPerSecond = 0.0;
        Emitters[2].ParticlesPerSecond = 0.0;
        Emitters[2].InitialParticlesPerSecond = 0.0;
    }
}

/*
simulated function Trigger(Actor Other, Pawn EventInstigator)
{
    Emitters[0].SpawnParticle(1);
    Emitters[1].SpawnParticle(1);
    Emitters[2].SpawnParticle(2);
}
*/

defaultproperties
{
   Begin Object Class=SpriteEmitter Name=SpriteEmitter0
        FadeOut=False
        RespawnDeadParticles=False
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        BlendBetweenSubdivisions=True
        UseRandomSubdivision=True
        Opacity=0.35
        CoordinateSystem=PTCS_Relative
        Name="muzzle_flash"
        StartLocationOffset=(X=10.500000)
        StartLocationShape=PTLS_Sphere
        UseRotationFrom=PTRS_Normal
        StartSpinRange=(X=(Min=-1.000000,Max=1.000000),Y=(Min=-1.000000,Max=1.000000),Z=(Min=-1.000000,Max=1.000000))
        SizeScale(0)=(RelativeSize=1.000000)
        SizeScale(1)=(RelativeTime=0.500000,RelativeSize=2.500000)
        SizeScale(2)=(RelativeTime=1.000000,RelativeSize=1.000000)
        StartSizeRange=(X=(Min=0.0,Max=3.500000))
        DrawStyle=PTDS_Brighten
        Texture=Texture'Effects_Tex.Weapons.STGmuzzleflash_4frame'
        TextureUSubdivisions=2
        TextureVSubdivisions=2
        LifetimeRange=(Min=0.100000,Max=0.100000)
        End Object
    Emitters(0)=SpriteEmitter'SpriteEmitter0'

    //we should replace this with an actual dynamic light flash like the infantry weps
    Begin Object Class=SpriteEmitter Name=SpriteEmitter1
        RespawnDeadParticles=False
        UniformSize=True
        AutomaticInitialSpawning=False
        Opacity=0.100000
        DrawStyle=PTDS_Brighten
        MaxParticles=1
        Name="strobe"
        StartLocationOffset=(X=11.000000)
        StartLocationShape=PTLS_Sphere
        StartSizeRange=(X=(Min=50.000000,Max=50.000000))
        Texture=Texture'Effects_Tex.Smoke.MuzzleCorona1stP'
        LifetimeRange=(Min=0.100000,Max=0.100000)
    End Object
    Emitters(1)=SpriteEmitter'SpriteEmitter1'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter6
        FadeOut=True
        RespawnDeadParticles=False
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        BlendBetweenSubdivisions=True
        UseRandomSubdivision=True
        //Acceleration=(Z=-50.0)
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        Opacity=0.35
        FadeOutStartTime=0.25
        MaxParticles=64 //2
        Name="gun_smoke"
        //StartLocationOffset=(X=15.000000)
        StartLocationRange=(X=(Min=15.0,Max=50.000000))
        UseRotationFrom=PTRS_Actor
        SpinsPerSecondRange=(X=(Min=-0.500000,Max=0.500000),Y=(Min=-0.500000,Max=0.500000),Z=(Min=-0.500000,Max=0.500000))
        SizeScale(0)=(RelativeSize=0.1)
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=3.500000)
        StartSizeRange=(X=(Min=10.000000,Max=15.000000))
        DrawStyle=PTDS_Brighten
        Texture=Texture'Effects_Tex.Weapons.MP3rdPmuzzle_smoke1frame'
        LifetimeRange=(Min=0.55,Max=1.200000)
        StartVelocityRange=(X=(Min=100.000000,Max=200.0),Y=(Min=-15.0000,Max=10.000),Z=(Min=-10.000,Max=15.000))
        VelocityLossRange=(X=(Max=2.000000))
    End Object
    Emitters(2)=SpriteEmitter'SpriteEmitter6'

    DrawScale3D=(X=1.000000,Y=1.000000,Z=1.000000)
    bUnlit=False
    bNoDelete=False
    bHardAttach=True
    RemoteRole=ROLE_None
    Physics=PHYS_None
    bBlockActors=False
    CullDistance=20000.0  //about 330m...increasing from 4000uu (or 50m!)
}



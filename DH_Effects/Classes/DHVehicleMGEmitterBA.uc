//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2021
//==============================================================================

class DHVehicleMGEmitterBA extends WeaponAmbientEmitter;

simulated function SetEmitterStatus(bool bEnabled)
{
    Emitters[0].UseCollision = ( !Level.bDropDetail && (Level.DetailMode != DM_Low) && (VSize(Level.GetLocalPlayerController().ViewTarget.Location - Location) < 1600));
    if(bEnabled)
    {
        //600 rpm
        Emitters[0].ParticlesPerSecond = 10.0;
        Emitters[0].InitialParticlesPerSecond = 10.0;
        Emitters[0].AllParticlesDead = false;

        Emitters[1].ParticlesPerSecond = 30.0;
        Emitters[1].InitialParticlesPerSecond = 30.0;
        Emitters[1].AllParticlesDead = false;

        Emitters[2].ParticlesPerSecond = 10.0;
        Emitters[2].InitialParticlesPerSecond = 10.0;
        Emitters[2].AllParticlesDead = false;

        Emitters[3].ParticlesPerSecond = 30.0;
        Emitters[3].InitialParticlesPerSecond = 30.0;
        Emitters[3].AllParticlesDead = false;

        Emitters[4].ParticlesPerSecond = 30.0;
        Emitters[4].InitialParticlesPerSecond = 30.0;
        Emitters[4].AllParticlesDead = false;

        Emitters[5].ParticlesPerSecond = 30.0;
        Emitters[5].InitialParticlesPerSecond = 30.0;
        Emitters[5].AllParticlesDead = false;
    }
    else
    {
        Emitters[0].ParticlesPerSecond = 0.0;
        Emitters[0].InitialParticlesPerSecond = 0.0;
        Emitters[1].ParticlesPerSecond = 0.0;
        Emitters[1].InitialParticlesPerSecond = 0.0;
        Emitters[2].ParticlesPerSecond = 0.0;
        Emitters[2].InitialParticlesPerSecond = 0.0;
        Emitters[3].ParticlesPerSecond = 0.0;
        Emitters[3].InitialParticlesPerSecond = 0.0;
        Emitters[4].ParticlesPerSecond = 0.0;
        Emitters[4].InitialParticlesPerSecond = 0.0;
        Emitters[5].ParticlesPerSecond = 0.0;
        Emitters[5].InitialParticlesPerSecond = 0.0;
    }
}

defaultproperties
{
    Begin Object Class=MeshEmitter Name=MeshEmitter0
        StaticMesh=StaticMesh'WeaponPickupSM.shells.S762_Rifle_MG'
        UseCollision=True
        RespawnDeadParticles=False
        SpawnOnlyInDirectionOfNormal=True
        SpinParticles=True
        AutomaticInitialSpawning=False
        Acceleration=(Z=-500.000000)
        DampingFactorRange=(X=(Min=0.500000,Max=0.500000),Y=(Min=0.500000,Max=0.500000),Z=(Min=0.500000,Max=0.500000))
        MaxParticles=30
        StartLocationOffset=(X=-35.000000,Z=1.0)
        MeshNormal=(Z=0.000000)
        UseRotationFrom=PTRS_Actor
        SpinsPerSecondRange=(X=(Min=0.100000,Max=1.000000),Y=(Min=0.100000,Max=1.000000),Z=(Min=0.100000,Max=1.000000))
        LifetimeRange=(Min=0.95,Max=0.95)
        StartVelocityRange=(X=(Min=-1.000000,Max=1.000000),Y=(Min=-1.000000,Max=1.000000),Z=(Min=1.000000,Max=1.000000))
        StartVelocityRadialRange=(Min=-250.000000,Max=250.000000)
        Sounds(0)=(Sound=SoundGroup'Inf_Weapons.shells.ShellRifleConcrete',Radius=(Min=100.000000,Max=100.000000),Volume=(Min=1.000000,Max=1.000000),Probability=(Min=1.000000,Max=1.000000))
        CollisionSound=PTSC_Random
        CollisionSoundProbability=(Min=1.000000,Max=1.000000)
    End Object
    Emitters(0)=MeshEmitter'MeshEmitter0'

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
        //StartLocationOffset=(X=10.500000)
        StartLocationShape=PTLS_Sphere
        UseRotationFrom=PTRS_Normal
        StartSpinRange=(X=(Min=-1.000000,Max=1.000000),Y=(Min=-1.000000,Max=1.000000),Z=(Min=-1.000000,Max=1.000000))
        SizeScale(0)=(RelativeSize=1.000000)
        SizeScale(1)=(RelativeTime=0.500000,RelativeSize=2.500000)
        SizeScale(2)=(RelativeTime=1.000000,RelativeSize=1.000000)
        StartSizeRange=(X=(Min=0.0,Max=5.00000))
        DrawStyle=PTDS_Brighten
        Texture=Texture'Effects_Tex.Weapons.STGmuzzleflash_4frame'
        TextureUSubdivisions=2
        TextureVSubdivisions=2
        LifetimeRange=(Min=0.100000,Max=0.100000)
        End Object
    Emitters(1)=SpriteEmitter'SpriteEmitter0'

    //we should replace this with an actual dynamic light flash like the infantry weps
    Begin Object Class=SpriteEmitter Name=SpriteEmitter1
        RespawnDeadParticles=False
        UniformSize=True
        AutomaticInitialSpawning=False
        Opacity=0.100000
        DrawStyle=PTDS_Brighten
        MaxParticles=30// 1
        Name="strobe"
        UseRotationFrom=PTRS_Actor
        StartLocationOffset=(X=8.000000)
        //StartLocationShape=PTLS_Sphere
        StartSizeRange=(X=(Min=5.000000,Max=25.000000))
        Texture=Texture'Effects_Tex.Smoke.MuzzleCorona1stP'
        LifetimeRange=(Min=0.100000,Max=0.100000)
    End Object
    Emitters(2)=SpriteEmitter'SpriteEmitter1'

    Begin Object Class=BeamEmitter Name=BeamEmitter1
        FadeOut=true
        BeamDistanceRange=(Min=0.000000,Max=150.000000)
        DetermineEndPointBy=PTEP_Distance
        RotatingSheets=2
        RespawnDeadParticles=False
        UseSizeScale=True
        AutomaticInitialSpawning=False
        ColorScale(0)=(Color=(B=200,G=200,R=200,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=200,G=200,R=200,A=255))
        FadeOutStartTime=0.150000
        Opacity=0.4
        MaxParticles=1
        name="spike_smoke"
        UseRotationFrom=PTRS_Actor
        SizeScale(0)=(RelativeSize=0.1)
        SizeScale(1)=(RelativeTime=0.140000,RelativeSize=1.000000)
        SizeScale(2)=(RelativeTime=1.000000,RelativeSize=2.5000000)
        StartSizeRange=(X=(Min=10.000000,Max=20.000000),Y=(Min=10.000000,Max=20.000000),Z=(Min=0.000000))
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'DH_FX_Tex.Effects.Impact03'
        LifetimeRange=(Min=0.1500000,Max=0.20000)
        StartVelocityRange=(X=(Min=300.000000,Max=500.000000),Y=(Min=-5.000000,Max=10.000000),Z=(Min=-10.000000,Max=5.000000))
    End Object
    Emitters(3)=BeamEmitter'BeamEmitter1'

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
        MaxParticles=100//64
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
        LifetimeRange=(Min=0.55,Max=0.85)
        StartVelocityRange=(X=(Min=100.000000,Max=200.0),Y=(Min=-15.0000,Max=10.000),Z=(Min=-10.000,Max=15.000))
        VelocityLossRange=(X=(Max=2.000000))
    End Object
    Emitters(4)=SpriteEmitter'SpriteEmitter6'

    Begin Object Class=BeamEmitter Name=BeamEmitter0
        BeamDistanceRange=(Min=0.000000,Max=150.000000)
        DetermineEndPointBy=PTEP_Distance
        RotatingSheets=2
        RespawnDeadParticles=False
        UseSizeScale=True
        AutomaticInitialSpawning=False
        //ColorMultiplierRange=(X=(Min=1.000000,Max=1.000000),Y=(Min=0.400000,Max=0.400000),Z=(Min=0.300000,Max=0.300000))
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        Opacity=0.45
        MaxParticles=1
        name="spike_flash"
        //StartLocationOffset=(X=15.000000)
        StartLocationRange=(X=(Min=5.0,Max=30.000000))
        UseRotationFrom=PTRS_Actor
        SizeScale(0)=(RelativeSize=0.1)
        SizeScale(1)=(RelativeTime=0.140000,RelativeSize=1.000000)
        SizeScale(2)=(RelativeTime=1.000000,RelativeSize=2.5000000)
        StartSizeRange=(X=(Min=1.000000,Max=4.000000),Y=(Min=1.000000,Max=4.000000),Z=(Min=0.000000))
        DrawStyle=PTDS_Brighten
        Texture=Texture'Effects_Tex.explosions.fire_quad'
        LifetimeRange=(Min=0.05,Max=0.10000)
        StartVelocityRange=(X=(Min=300.000000,Max=500.000000),Y=(Min=-5.000000,Max=8.000000),Z=(Min=-8.000000,Max=5.000000))
    End Object
    Emitters(5)=BeamEmitter'BeamEmitter0'

    DrawScale3D=(X=1.000000,Y=1.000000,Z=1.000000)
    bUnlit=False
    bNoDelete=False
    bHardAttach=True
    RemoteRole=ROLE_None
    Physics=PHYS_None
    bBlockActors=False
    CullDistance=20000.0 //about 330m...increasing from 4000uu (or 50m!)
}



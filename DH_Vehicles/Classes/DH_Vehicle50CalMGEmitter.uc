//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_Vehicle50CalMGEmitter extends WeaponAmbientEmitter;

simulated function SetEmitterStatus(bool bEnabled)
{
    Emitters[0].UseCollision = !Level.bDropDetail && Level.DetailMode != DM_Low && VSizeSquared(Level.GetLocalPlayerController().ViewTarget.Location - Location) < 2560000.0;

    if (bEnabled) // 450 rpm
    {
        Emitters[0].ParticlesPerSecond = 7.5;
        Emitters[0].InitialParticlesPerSecond = 7.5;
        Emitters[0].AllParticlesDead = false;

        Emitters[1].ParticlesPerSecond = 7.5;
        Emitters[1].InitialParticlesPerSecond = 7.5;
        Emitters[1].AllParticlesDead = false;
    }
    else
    {
        Emitters[0].ParticlesPerSecond = 0.0;
        Emitters[0].InitialParticlesPerSecond = 0.0;

        Emitters[1].ParticlesPerSecond = 0.0;
        Emitters[1].InitialParticlesPerSecond = 0.0;
    }
}

defaultproperties
{
    Begin Object Class=MeshEmitter Name=MeshEmitter0
        StaticMesh=StaticMesh'DH_WeaponPickups.Ammo.50calShellCase'
        UseCollision=true
        RespawnDeadParticles=false
        SpinParticles=true
        AutomaticInitialSpawning=false
        Acceleration=(Z=-500.0)
        DampingFactorRange=(X=(Min=0.5,Max=0.5),Y=(Min=0.5,Max=0.5),Z=(Min=0.5,Max=0.5))
        MaxParticles=30
        StartLocationOffset=(X=-66.0,Y=3.5,Z=2.66)
        MeshNormal=(Z=0.0)
        UseRotationFrom=PTRS_Actor
        SpinsPerSecondRange=(X=(Min=0.1,Max=1.0),Y=(Min=0.1,Max=1.0),Z=(Min=0.1,Max=1.0))
        LifetimeRange=(Min=1.5,Max=1.5)
        StartVelocityRange=(X=(Min=-1.0,Max=1.0),Y=(Min=25.0,Max=100.0),Z=(Min=0.1,Max=1.0))
        StartVelocityRadialRange=(Min=-250.0,Max=250.0)
    End Object
    Emitters(0)=MeshEmitter'DH_Vehicles.DH_Vehicle50CalMGEmitter.MeshEmitter0'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter1
        RespawnDeadParticles=false
        SpinParticles=true
        UseSizeScale=true
        UseRegularSizeScale=false
        UniformSize=true
        AutomaticInitialSpawning=false
        BlendBetweenSubdivisions=true
        UseRandomSubdivision=true
        Opacity=0.45
        CoordinateSystem=PTCS_Relative
        StartLocationOffset=(X=8.0,Y=0.0,Z=0.0)
        StartLocationShape=PTLS_Sphere
        UseRotationFrom=PTRS_Normal
        StartSpinRange=(X=(Min=-1.0,Max=1.0),Y=(Min=-1.0,Max=1.0),Z=(Min=-1.0,Max=1.0))
        SizeScale(0)=(RelativeSize=1.0)
        SizeScale(1)=(RelativeTime=0.5,RelativeSize=2.5)
        SizeScale(2)=(RelativeTime=1.0,RelativeSize=1.0)
        StartSizeRange=(X=(Min=4.0,Max=5.0))
        DrawStyle=PTDS_Brighten
        Texture=Texture'Effects_Tex.Weapons.STGmuzzleflash_4frame'
        TextureUSubdivisions=2
        TextureVSubdivisions=2
        LifetimeRange=(Min=0.1,Max=0.1)
    End Object
    Emitters(1)=SpriteEmitter'DH_Vehicles.DH_Vehicle50CalMGEmitter.SpriteEmitter1'

    bUnlit=false
    bNoDelete=false
    bHardAttach=true
    CullDistance=4000.0
}

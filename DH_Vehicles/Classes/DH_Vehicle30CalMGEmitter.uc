//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_Vehicle30CalMGEmitter extends WeaponAmbientEmitter;

simulated function SetEmitterStatus(bool bEnabled)
{
    Emitters[0].UseCollision = !Level.bDropDetail && Level.DetailMode != DM_Low && VSizeSquared(Level.GetLocalPlayerController().ViewTarget.Location - Location) < 2560000.0;

    if (bEnabled) // 500 rpm
    {
        Emitters[0].ParticlesPerSecond = 8.333;
        Emitters[0].InitialParticlesPerSecond = 8.333;
        Emitters[0].AllParticlesDead = false;

        Emitters[1].ParticlesPerSecond = 8.333;
        Emitters[1].InitialParticlesPerSecond = 8.333;
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
        StaticMesh=StaticMesh'WeaponPickupSM.shells.S762_Rifle_MG'
        UseCollision=true
        RespawnDeadParticles=false
        SpawnOnlyInDirectionOfNormal=true
        SpinParticles=true
        AutomaticInitialSpawning=false
        Acceleration=(Z=-500.0)
        DampingFactorRange=(X=(Min=0.5,Max=0.5),Y=(Min=0.5,Max=0.5),Z=(Min=0.5,Max=0.5))
        MaxParticles=30
        StartLocationOffset=(X=-52.0,Y=5.0)
        MeshNormal=(Z=0.0)
        UseRotationFrom=PTRS_Actor
        SpinsPerSecondRange=(X=(Min=0.1,Max=1.0),Y=(Min=0.1,Max=1.0),Z=(Min=0.1,Max=1.0))
        LifetimeRange=(Min=1.5,Max=1.5)
        StartVelocityRange=(X=(Min=-1.0,Max=1.0),Y=(Min=25.0,Max=100.0),Z=(Min=1.0,Max=1.0))
        StartVelocityRadialRange=(Min=-250.0,Max=250.0)
    End Object
    Emitters(0)=MeshEmitter'DH_Vehicles.DH_Vehicle30CalMGEmitter.MeshEmitter0'

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
        StartLocationOffset=(X=10.5)
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
    Emitters(1)=SpriteEmitter'DH_Vehicles.DH_Vehicle30CalMGEmitter.SpriteEmitter1'

    CullDistance=4000.0
    bNoDelete=false
    bUnlit=false
    bHardAttach=true
}

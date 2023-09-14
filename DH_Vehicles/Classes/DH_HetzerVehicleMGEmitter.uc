//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_HetzerVehicleMGEmitter extends WeaponAmbientEmitter; // TODO: after next DH release extend DHVehicleMGFlashAndShellEmitter

simulated function SetEmitterStatus(bool bEnabled)
{
    Emitters[0].UseCollision = !Level.bDropDetail && Level.DetailMode != DM_Low && VSizeSquared(Level.GetLocalPlayerController().ViewTarget.Location - Location) < 2560000.0;

    if (bEnabled)
    {
        Emitters[0].ParticlesPerSecond = 14.17; // ejected shell casings to match 850 RPM firing rate
        Emitters[0].InitialParticlesPerSecond = 14.17;
        Emitters[0].AllParticlesDead = false;

        Emitters[1].ParticlesPerSecond = 30.0;
        Emitters[1].InitialParticlesPerSecond = 30.0;
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
     Begin Object Class=MeshEmitter Name=ShellCaseEmitter
         StaticMesh=StaticMesh'WeaponPickupSM.shells.S762_Rifle_MG'
         UseCollision=True
         RespawnDeadParticles=False
         SpawnOnlyInDirectionOfNormal=True
         SpinParticles=True
         AutomaticInitialSpawning=False
         Acceleration=(Z=-500.000000)
         DampingFactorRange=(X=(Min=0.500000,Max=0.500000),Y=(Min=0.500000,Max=0.500000),Z=(Min=0.500000,Max=0.500000))
         MaxParticles=30
         StartLocationOffset=(X=-46.000000,Y=1.500000)
         MeshNormal=(Z=0.000000)
         UseRotationFrom=PTRS_Actor
         SpinsPerSecondRange=(X=(Min=0.100000,Max=1.000000),Y=(Min=0.100000,Max=1.000000),Z=(Min=0.100000,Max=1.000000))
         LifetimeRange=(Min=1.500000,Max=1.500000)
         StartVelocityRange=(X=(Min=-1.000000,Max=1.000000),Y=(Min=5.000000,Max=20.000000),Z=(Min=1.000000,Max=1.000000))
         StartVelocityRadialRange=(Min=-250.000000,Max=250.000000)
     End Object
     Emitters(0)=MeshEmitter'DH_Vehicles.DH_HetzerVehicleMGEmitter.ShellCaseEmitter'

     Begin Object Class=SpriteEmitter Name=FlashEmitter
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         BlendBetweenSubdivisions=True
         UseRandomSubdivision=True
         Opacity=0.300000
         CoordinateSystem=PTCS_Relative
         StartLocationOffset=(X=3.000000)
         StartLocationShape=PTLS_Sphere
         UseRotationFrom=PTRS_Normal
         StartSpinRange=(X=(Min=-1.000000,Max=1.000000),Y=(Min=-1.000000,Max=1.000000),Z=(Min=-1.000000,Max=1.000000))
         SizeScale(0)=(RelativeSize=1.000000)
         SizeScale(1)=(RelativeTime=0.500000,RelativeSize=2.500000)
         SizeScale(2)=(RelativeTime=1.000000,RelativeSize=1.000000)
         StartSizeRange=(X=(Min=4.000000,Max=5.000000))
         DrawStyle=PTDS_Brighten
         Texture=Texture'Effects_Tex.Weapons.STGmuzzleflash_4frame'
         TextureUSubdivisions=2
         TextureVSubdivisions=2
         LifetimeRange=(Min=0.100000,Max=0.100000)
     End Object
     Emitters(1)=SpriteEmitter'DH_Vehicles.DH_HetzerVehicleMGEmitter.FlashEmitter'

     CullDistance=4000.000000
     bNoDelete=False
     bUnlit=False
     bHardAttach=True
}

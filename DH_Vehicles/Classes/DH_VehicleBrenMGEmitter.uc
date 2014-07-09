//-----------------------------------------------------------
//   VehicleMGEmitter - Ambient Emitter class for RO vehicle MGs
//	Muzzle flash and shell ejection
//-----------------------------------------------------------
class DH_VehicleBrenMGEmitter extends WeaponAmbientEmitter;

simulated function SetEmitterStatus(bool bEnabled)
{

	if(bEnabled)
	{
		Emitters[0].ParticlesPerSecond = 20.0; //500 RPM
		Emitters[0].InitialParticlesPerSecond = 20.0; //500 RPM
		Emitters[0].AllParticlesDead = false;
    }
    else
	{
		Emitters[0].ParticlesPerSecond = 0.0;
		Emitters[0].InitialParticlesPerSecond = 0.0;

	}
}

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter0
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         BlendBetweenSubdivisions=True
         UseRandomSubdivision=True
         Opacity=0.450000
         CoordinateSystem=PTCS_Relative
         StartLocationOffset=(X=10.500000)
         StartLocationShape=PTLS_Sphere
         UseRotationFrom=PTRS_Normal
         StartSpinRange=(X=(Min=-1.000000,Max=1.000000),Y=(Min=-1.000000,Max=1.000000),Z=(Min=-1.000000,Max=1.000000))
         SizeScale(0)=(RelativeSize=1.000000)
         SizeScale(1)=(RelativeTime=0.500000,RelativeSize=2.500000)
         SizeScale(2)=(RelativeTime=1.000000,RelativeSize=1.000000)
         StartSizeRange=(X=(Min=1.500000,Max=2.500000))
         DrawStyle=PTDS_Brighten
         Texture=Texture'Effects_Tex.Weapons.STGmuzzleflash_4frame'
         TextureUSubdivisions=2
         TextureVSubdivisions=2
         LifetimeRange=(Min=0.100000,Max=0.100000)
     End Object
     Emitters(0)=SpriteEmitter'ROVehicles.TankMGEmitter.SpriteEmitter0'

     CullDistance=4000.000000
     bNoDelete=False
     bUnlit=False
     bHardAttach=True
}

//-----------------------------------------------------------
//   TankMGEmitter - Ambient Emitter class for RO tanks
//	Muzzle flash
//-----------------------------------------------------------
class DH_GapAltEmitter extends WeaponAmbientEmitter;

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
        Opacity=1
        CoordinateSystem=PTCS_Relative
        Name="SpriteEmitter0"
        StartLocationOffset=(X=10.500000)
        StartLocationShape=PTLS_Sphere
        UseRotationFrom=PTRS_Normal
        StartSpinRange=(X=(Min=-1.000000,Max=1.000000),Y=(Min=-1.000000,Max=1.000000),Z=(Min=-1.000000,Max=1.000000))
        SizeScale(0)=(RelativeSize=1.000000)
        SizeScale(1)=(RelativeTime=0.500000,RelativeSize=2.500000)
        SizeScale(2)=(RelativeTime=1.000000,RelativeSize=1.000000)
        StartSizeRange=(X=(Min=1.500000,Max=2.500000))
	DrawStyle=PTDS_Brighten
        Texture=Texture'DH_UFO_tex.GAP.gapeye_A00'
        TextureUSubdivisions=1
        TextureVSubdivisions=1
        LifetimeRange=(Min=0.2,Max=0.3)
        End Object
    Emitters(0)=SpriteEmitter'SpriteEmitter0'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter1
        RespawnDeadParticles=False
        UniformSize=True
        AutomaticInitialSpawning=False
        Opacity=1
	DrawStyle=STY_Masked
        MaxParticles=1
        Name="SpriteEmitter60"
        StartLocationOffset=(X=11.000000)
        StartLocationShape=PTLS_Sphere
        StartSizeRange=(X=(Min=50.000000,Max=50.000000))
        Texture=Texture'DH_UFO_tex.GAP.gapeye_A00'
        LifetimeRange=(Min=0.2,Max=0.3)
    End Object
    Emitters(1)=SpriteEmitter'SpriteEmitter1'

    DrawScale3D=(X=1.000000,Y=1.000000,Z=1.000000)
    bUnlit=False
    bNoDelete=False
    bHardAttach=True
	RemoteRole=ROLE_None
	Physics=PHYS_None
	bBlockActors=False
	CullDistance=4000.0
}



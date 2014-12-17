//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_Vehicle30CalMGEmitter extends WeaponAmbientEmitter;

simulated function SetEmitterStatus(bool bEnabled)
{
    Emitters[0].UseCollision = (!Level.bDropDetail && (Level.DetailMode != DM_Low) && (VSize(Level.GetLocalPlayerController().ViewTarget.Location - Location) < 1600));
    if (bEnabled)
    {
        Emitters[0].ParticlesPerSecond = 7.0; //400 RPM
        Emitters[0].InitialParticlesPerSecond = 7.0; //400 RPM
        Emitters[0].AllParticlesDead = false;

        Emitters[1].ParticlesPerSecond = 14.0;
        Emitters[1].InitialParticlesPerSecond = 14.0;
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
        Acceleration=(Z=-500.000000)
        DampingFactorRange=(X=(Min=0.500000,Max=0.500000),Y=(Min=0.500000,Max=0.500000),Z=(Min=0.500000,Max=0.500000))
        MaxParticles=30
        StartLocationOffset=(X=-52.000000,Y=5.000000)
        MeshNormal=(Z=0.000000)
        UseRotationFrom=PTRS_Actor
        SpinsPerSecondRange=(X=(Min=0.100000,Max=1.000000),Y=(Min=0.100000,Max=1.000000),Z=(Min=0.100000,Max=1.000000))
        LifetimeRange=(Min=1.500000,Max=1.500000)
        StartVelocityRange=(X=(Min=-1.000000,Max=1.000000),Y=(Min=25.000000,Max=100.000000),Z=(Min=1.000000,Max=1.000000))
        StartVelocityRadialRange=(Min=-250.000000,Max=250.000000)
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
        Opacity=0.450000
        CoordinateSystem=PTCS_Relative
        StartLocationOffset=(X=10.500000)
        StartLocationShape=PTLS_Sphere
        UseRotationFrom=PTRS_Normal
        StartSpinRange=(X=(Min=-1.000000,Max=1.000000),Y=(Min=-1.000000,Max=1.000000),Z=(Min=-1.000000,Max=1.000000))
        SizeScale(0)=(RelativeSize=1.000000)
        SizeScale(1)=(RelativeTime=0.500000,RelativeSize=2.500000)
        SizeScale(2)=(RelativeTime=1.000000,RelativeSize=1.000000)
        StartSizeRange=(X=(Min=4.000000,Max=5.000000))
        DrawStyle=PTDS_Brighten
        Texture=texture'Effects_Tex.Weapons.STGmuzzleflash_4frame'
        TextureUSubdivisions=2
        TextureVSubdivisions=2
        LifetimeRange=(Min=0.100000,Max=0.100000)
    End Object
    Emitters(1)=SpriteEmitter'DH_Vehicles.DH_Vehicle30CalMGEmitter.SpriteEmitter1'
    CullDistance=4000.000000
    bNoDelete=false
    bUnlit=false
    bHardAttach=true
}

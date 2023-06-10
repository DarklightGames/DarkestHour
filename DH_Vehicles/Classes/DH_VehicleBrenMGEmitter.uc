//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_VehicleBrenMGEmitter extends WeaponAmbientEmitter;

simulated function SetEmitterStatus(bool bEnabled)
{
    if (bEnabled) // 500 rpm
    {
        Emitters[0].ParticlesPerSecond = 8.333;
        Emitters[0].InitialParticlesPerSecond = 8.333;
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
        StartSizeRange=(X=(Min=1.5,Max=2.5))
        DrawStyle=PTDS_Brighten
        Texture=Texture'Effects_Tex.Weapons.STGmuzzleflash_4frame'
        TextureUSubdivisions=2
        TextureVSubdivisions=2
        LifetimeRange=(Min=0.1,Max=0.1)
    End Object
    Emitters(0)=SpriteEmitter'ROVehicles.TankMGEmitter.SpriteEmitter0'

    CullDistance=4000.0
    bNoDelete=false
    bUnlit=false
    bHardAttach=true
}

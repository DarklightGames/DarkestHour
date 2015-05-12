//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_Tiger2BMountedMGPawn extends DHMountedTankMGPawn;

defaultproperties
{
    OverlayCenterSize=0.7
    MGOverlay=texture'DH_VehicleOptics_tex.German.KZF2_MGSight'
    WeaponFOV=41.0
    GunClass=class'DH_Vehicles.DH_Tiger2BMountedMG'
    bHasAltFire=false
    CameraBone="mg_yaw"
    bDrawDriverInTP=false
    FPCamViewOffset=(X=10.0,Y=-5.0,Z=1.0)
    TPCamDistance=300.0
    TPCamLookat=(X=-25.0,Z=0.0)
    TPCamWorldOffset=(Z=120.0)
    PitchUpLimit=3000
    PitchDownLimit=63000
}

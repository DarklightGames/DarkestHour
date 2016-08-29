//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_T34MountedMGPawn extends DHVehicleMGPawn;

defaultproperties
{
    bDrawDriverinTP=false
    bDrawMeshInFP=false
    bStationary=true
    DrawType=DT_None

    GunClass=class'DH_Vehicles.DH_T34MountedMG'
    GunsightOverlay=texture'Vehicle_Optic.MG_sight'
    HUDOverlayClass=class'ROVehicles.ROVehDTOverlay'
    HUDOverlayOffset=(X=-40,Y=0,Z=0)
    HUDOverlayFOV=45
    OverlayCenterSize=0.40
    WeaponFov=72
    FPCamPos=(X=0,Y=0,Z=0)
    //PitchUpLimit=3000
    //PitchDownLimit=64000
    CameraBone=T34_mg
    FPCamViewOffset=(X=5,Y=0,Z=10)
    bFPNoZFromCameraPitch=False
    TPCamLookat=(X=-25,Y=0,Z=0)
    TPCamWorldOffset=(X=0,Y=0,Z=120)
    TPCamDistance=300
    DrivePos=(X=0.0,Y=0.0,Z=130.0)
    DriverDamageMult=0.0
}


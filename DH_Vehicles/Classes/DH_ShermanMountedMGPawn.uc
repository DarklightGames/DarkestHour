//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_ShermanMountedMGPawn extends DHVehicleMGPawn;

defaultproperties
{
    OverlayCenterSize=0.7
    MGOverlay=texture'DH_VehicleOptics_tex.Common.MG_sight'
    WeaponFOV=72.0
    GunClass=class'DH_Vehicles.DH_ShermanMountedMG'
    bHasAltFire=false
    CameraBone="mg_yaw"
    bDrawDriverInTP=false
    EntryRadius=130.0
    FPCamPos=(X=-0.5,Y=0.0,Z=3.5)
    PitchUpLimit=3000
    PitchDownLimit=63500
}

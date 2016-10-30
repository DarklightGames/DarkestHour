//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_T34MountedMGPawn extends DHVehicleMGPawn;

// TODO: I believe this MG had no sights & was aimed by looking through a simple hole, most similar to a jagdpanzer IV, so I think the current view is very unrealistic
// So probably going to add the same generic 'keyhole' view overlay as the JPIV (sadly I think that means the HUDOverlay & reload anim have to go)

defaultproperties
{
    GunClass=class'DH_Vehicles.DH_T34MountedMG'
    GunsightOverlay=texture'Vehicle_Optic.MG_sight'
    OverlayCenterSize=0.40
    WeaponFOV=90.0
    CameraBone="T34_mg"
    FPCamPos=(X=5.0,Y=0.0,Z=10.0)
    bDrawMeshInFP=false // as uses HUD overlay in 1st person
    HUDOverlayClass=class'DH_Vehicles.DH_VehHUDOverlay_DTmg'
    HUDOverlayOffset=(X=-40.0,Y=0.0,Z=0.0)
    HUDOverlayFOV=45.0
    PitchUpLimit=3000
    PitchDownLimit=64000
    VehicleMGReloadTexture=texture'DH_InterfaceArt_tex.Tank_Hud.DT_ammo_reload'
}

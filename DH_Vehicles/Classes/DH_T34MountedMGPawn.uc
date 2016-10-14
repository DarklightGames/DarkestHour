//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_T34MountedMGPawn extends DHVehicleMGPawn;

defaultproperties
{
    GunClass=class'DH_Vehicles.DH_T34MountedMG'
    GunsightOverlay=texture'Vehicle_Optic.MG_sight'
    OverlayCenterSize=0.40
    WeaponFOV=72.0
    CameraBone="T34_mg"
    FPCamPos=(X=5.0,Y=0.0,Z=10.0)
    bDrawMeshInFP=false // as uses HUD overlay in 1st person
    HUDOverlayClass=class'ROVehicles.ROVehDTOverlay'
    HUDOverlayOffset=(X=-40.0,Y=0.0,Z=0.0)
    HUDOverlayFOV=45.0
	PitchUpLimit=3000
   	PitchDownLimit=64000
//  VehicleMGReloadTexture=texture'DH_InterfaceArt_tex.Tank_Hud.DP27_ammo_reload' // TODO: make this (may need to adjust HUDProportions in ReloadStages - see BrenCarrier MG)
}

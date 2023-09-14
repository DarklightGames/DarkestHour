//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_T3476MountedMGPawn extends DHVehicleMGPawn;

defaultproperties
{
    GunClass=class'DH_Vehicles.DH_T3476MountedMG'

    WeaponFOV=72.0 //zoom level outside tank through peep
    GunsightOverlay=Texture'DH_VehicleOptics_tex.General.MG_sight'
    GunsightSize=0.35 //size of peephole

    HUDOverlayClass=class'DH_DTmg_VehHUDOverlay'
    HUDOverlayOffset=(X=-40,Y=0,Z=0) //distance from your face
    HUDOverlayFOV=45 //size of DT mesh in your face

    CameraBone="T34_mg"
    FPCamPos=(X=4.0,Y=0.0,Z=3.5)
    PitchUpLimit=3000
    PitchDownLimit=63500
    VehicleMGReloadTexture=Texture'DH_InterfaceArt_tex.Tank_Hud.DT_ammo_reload'
    FirstPersonGunShakeScale=0.1 //1.0
}

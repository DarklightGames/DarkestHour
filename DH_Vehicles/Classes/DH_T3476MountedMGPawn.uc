//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_T3476MountedMGPawn extends DHVehicleMGPawn;

defaultproperties
{
    GunClass=Class'DH_T3476MountedMG'

    WeaponFOV=72.0 //zoom level outside tank through peep
    GunsightOverlay=Texture'DH_VehicleOptics_tex.MG_sight'
    GunsightSize=0.35 //size of peephole

    HUDOverlayClass=Class'DH_DTmg_VehHUDOverlay'
    HUDOverlayOffset=(X=-40,Y=0,Z=0) //distance from your face
    HUDOverlayFOV=45 //size of DT mesh in your face

    CameraBone="T34_mg"
    FPCamPos=(X=4.0,Y=0.0,Z=3.5)
    PitchUpLimit=3000
    PitchDownLimit=63500
    VehicleMGReloadTexture=Texture'DH_InterfaceArt_tex.DT_ammo_reload'
    FirstPersonGunShakeScale=0.1 //1.0
}

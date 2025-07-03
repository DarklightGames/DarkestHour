//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_ZiS2CannonPawn extends DHATGunCannonPawn;

defaultproperties
{
    GunClass=Class'DH_ZiS2Cannon'
    DriverPositions(0)=(ViewFOV=22.97,TransitionUpAnim="com_open",DriverTransitionAnim="crouch_idle_binoc",ViewPositiveYawLimit=20000,ViewNegativeYawLimit=-20000,bDrawOverlays=true,bExposed=true) // view limits only relevant during transition down, to avoid snap to front at start
    DriverPositions(1)=(TransitionDownAnim="com_close",DriverTransitionAnim="stand_idlehip_ptrd",ViewPitchUpLimit=6000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=20000,ViewNegativeYawLimit=-20000,bExposed=true)
    DriverPositions(2)=(ViewFOV=12.0,DriverTransitionAnim="stand_idleiron_binoc",ViewPitchUpLimit=6000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=20000,ViewNegativeYawLimit=-20000,bDrawOverlays=true,bExposed=true)
    DriveAnim="crouch_idle_binoc"
    GunsightOverlay=Texture'DH_VehicleOptics_tex.PG1_sight_background'
    GunsightSize=0.441 // 10.5 degrees visible FOV at 3.7x magnification (PG1 sight)
    DestroyedGunsightOverlay=Texture'DH_VehicleOpticsDestroyed_tex.PZ4_sight_destroyed' // matches size of gunsight
    AmmoShellTexture=Texture'InterfaceArt_tex.T3476_SU76_Kv1shell'
    AmmoShellReloadTexture=Texture'InterfaceArt_tex.T3476_SU76_Kv1shell_reload'
    CameraBone="GUNSIGHT_CAMERA_ZIS2"
    PlayerCameraBone="CAMERA_COM_ZIS2"
}

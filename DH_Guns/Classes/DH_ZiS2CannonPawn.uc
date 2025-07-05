//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_ZiS2CannonPawn extends DHATGunCannonPawn;

defaultproperties
{
    GunClass=Class'DH_ZiS2Cannon'
    DriverPositions(0)=(ViewFOV=22.97,TransitionUpAnim="overlay_out",DriverTransitionAnim="crouch_idle_binoc",ViewPositiveYawLimit=20000,ViewNegativeYawLimit=-20000,bDrawOverlays=true,bExposed=true)
    DriverPositions(1)=(TransitionDownAnim="overlay_in",TransitionUpAnim="raise",DriverTransitionAnim="stand_idlehip_ptrd",ViewPitchUpLimit=6000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=20000,ViewNegativeYawLimit=-20000,bExposed=true)
    DriverPositions(2)=(TransitionDownAnim="lower",DriverTransitionAnim="stand_idleiron_binoc",ViewPitchUpLimit=6000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=20000,ViewNegativeYawLimit=-20000,bExposed=true)
    DriverPositions(3)=(ViewFOV=12.0,DriverTransitionAnim="45mm_gunner_binocs",ViewPitchUpLimit=6000,ViewPitchDownLimit=49152,ViewPositiveYawLimit=20000,ViewNegativeYawLimit=-20000,bDrawOverlays=true,bExposed=true)
    BinocPositionIndex=3
    DriveAnim="crouch_idle_binoc"
    GunsightOverlay=Texture'DH_VehicleOptics_tex.PG1_sight_background'
    GunsightSize=0.441 // 10.5 degrees visible FOV at 3.7x magnification (PG1 sight)
    DestroyedGunsightOverlay=Texture'DH_VehicleOpticsDestroyed_tex.PZ4_sight_destroyed' // matches size of gunsight
    AmmoShellTexture=Texture'InterfaceArt_tex.T3476_SU76_Kv1shell'
    AmmoShellReloadTexture=Texture'InterfaceArt_tex.T3476_SU76_Kv1shell_reload'
    CameraBone="GUNSIGHT_CAMERA_ZIS2"
    PlayerCameraBone="CAMERA_COM_ZIS2"
}

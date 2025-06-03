//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_Pak36CannonPawn extends DHATGunCannonPawn;

defaultproperties
{
    //Gun Class
    GunClass=class'DH_Guns.DH_Pak36Cannon'

    //Driver's position and animations
    DriverPositions(0)=(ViewFOV=25.0,TransitionUpAnim="overlay_out",DriverTransitionAnim="crouch_idle_binoc",ViewPitchUpLimit=4005,ViewPitchDownLimit=64623,ViewPositiveYawLimit=5825,ViewNegativeYawLimit=-5825,bDrawOverlays=true,bExposed=true)
    DriverPositions(1)=(TransitionDownAnim="overlay_in",TransitionUpAnim="raise",DriverTransitionAnim="crouch_idle_binoc",ViewPitchUpLimit=6000,ViewPitchDownLimit=49152,ViewPositiveYawLimit=20000,ViewNegativeYawLimit=-20000,bExposed=true)
    DriverPositions(2)=(TransitionDownAnim="lower",DriverTransitionAnim="crouch_idle_binoc",ViewPitchUpLimit=6000,ViewPitchDownLimit=49152,ViewPositiveYawLimit=20000,ViewNegativeYawLimit=-20000,bExposed=true)
    DriverPositions(3)=(ViewFOV=12.0,DriverTransitionAnim="crouch_idleiron_binoc",ViewPitchUpLimit=6000,ViewPitchDownLimit=49152,ViewPositiveYawLimit=20000,ViewNegativeYawLimit=-20000,bDrawOverlays=true,bExposed=true)

    BinocPositionIndex=3
    DrivePos=(Z=58)
    DriveAnim="crouch_idle_binoc"

    //Gunsight
    GunsightOverlay=Texture'DH_Pak36_tex.PAK36_SIGHT'
    GunsightSize=0.32 // 11 degrees FOV, 1x mag
    OverlayCorrectionX=0
    OverlayCorrectionY=12

    //HUD
    AmmoShellTexture=Texture'InterfaceArt_tex.Tank_Hud.Panzer3shell'
    AmmoShellReloadTexture=Texture'InterfaceArt_tex.Tank_Hud.Panzer3shell_reload'

    CameraBone="GUNSIGHT_CAMERA"
}

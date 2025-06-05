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
    DriverPositions(0)=(ViewFOV=25.0,TransitionUpAnim="overlay_out",ViewPitchUpLimit=4005,ViewPitchDownLimit=64623,ViewPositiveYawLimit=5825,ViewNegativeYawLimit=-5825,bDrawOverlays=true,bExposed=true)
    DriverPositions(1)=(TransitionDownAnim="overlay_in",TransitionUpAnim="raise",DriverTransitionAnim="pak36_gunner_lower",ViewPitchUpLimit=6000,ViewPitchDownLimit=49152,ViewPositiveYawLimit=20000,ViewNegativeYawLimit=-20000,bExposed=true)
    DriverPositions(2)=(TransitionDownAnim="lower",DriverTransitionAnim="pak36_gunner_raise",ViewPitchUpLimit=6000,ViewPitchDownLimit=49152,ViewPositiveYawLimit=20000,ViewNegativeYawLimit=-20000,bExposed=true)
    DriverPositions(3)=(ViewFOV=12.0,DriverTransitionAnim="pak36_gunner_binocs",ViewPitchUpLimit=6000,ViewPitchDownLimit=49152,ViewPositiveYawLimit=20000,ViewNegativeYawLimit=-20000,bDrawOverlays=true,bExposed=true)

    BinocPositionIndex=3
    DrivePos=(Z=58)
    DriveAnim="pak36_gunner_idle"

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

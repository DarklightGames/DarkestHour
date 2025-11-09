//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_Pak43CannonPawn extends DHATGunCannonPawn;

defaultproperties
{
    GunClass=Class'DH_Pak43Cannon'
    DriverPositions(0)=(ViewFOV=28.33,TransitionUpAnim="overlay_out",ViewPitchUpLimit=4005,ViewPitchDownLimit=64623,ViewPositiveYawLimit=5825,ViewNegativeYawLimit=-5825,bDrawOverlays=true,bExposed=true)
    DriverPositions(1)=(TransitionUpAnim="raise",TransitionDownAnim="overlay_in",DriverTransitionAnim="pak43_gunner_lower",ViewPitchUpLimit=6000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=20000,ViewNegativeYawLimit=-20000,bExposed=true)
    DriverPositions(2)=(TransitionDownAnim="lower",DriverTransitionAnim="pak43_gunner_raise",ViewPitchUpLimit=6000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=20000,ViewNegativeYawLimit=-20000,bExposed=true)
    DriverPositions(3)=(ViewFOV=12.0,DriverTransitionAnim="pak43_gunner_binocs",ViewPitchUpLimit=6000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=20000,ViewNegativeYawLimit=-20000,bDrawOverlays=true,bExposed=true)
    UnbuttonedPositionIndex=0
    RaisedPositionIndex=2
    BinocPositionIndex=3
    DrivePos=(Z=58)
    DriveAnim="pak43_gunner_idle"
    GunsightOverlay=Texture'DH_VehicleOptics_tex.German.ZF_II_3x8_Pak'
    GunsightSize=0.282 // 8 degrees visible FOV at 3x magnification (ZF 3x8 Pak sight)
    AmmoShellTexture=Texture'DH_InterfaceArt_tex.Tank_Hud.KingTigerShell'
    AmmoShellReloadTexture=Texture'DH_InterfaceArt_tex.Tank_Hud.KingTigerShell_reload'
    CameraBone="GUNSIGHT_CAMERA"
    PlayerCameraBone="CAMERA_COM"
}

//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_Pak40CannonPawn extends DHATGunCannonPawn;

defaultproperties
{
    CameraBone="GUNSIGHT_CAMERA"
    GunClass=Class'DH_Guns.DH_Pak40Cannon'
    DriverPositions(0)=(ViewFOV=28.33,TransitionUpAnim="overlay_out",ViewPitchUpLimit=4005,ViewPitchDownLimit=64623,ViewPositiveYawLimit=5825,ViewNegativeYawLimit=-5825,bDrawOverlays=true,bExposed=true)
    DriverPositions(1)=(TransitionUpAnim="raise",TransitionDownAnim="overlay_in",DriverTransitionAnim="pak40_gunner_lower",ViewPitchUpLimit=6000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=20000,ViewNegativeYawLimit=-20000,bExposed=true)
    DriverPositions(2)=(TransitionDownAnim="lower",DriverTransitionAnim="pak40_gunner_raise",ViewPitchUpLimit=6000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=20000,ViewNegativeYawLimit=-20000,bExposed=true)
    DriverPositions(3)=(ViewFOV=12.0,DriverTransitionAnim="pak40_gunner_binocs",ViewPitchUpLimit=6000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=20000,ViewNegativeYawLimit=-20000,bDrawOverlays=true,bExposed=true)
    UnbuttonedPositionIndex=0
    RaisedPositionIndex=2
    BinocPositionIndex=3
    DrivePos=(Z=58)
    DriveAnim="pak40_gunner_idle"
    GunsightOverlay=Texture'DH_VehicleOptics_tex.German.ZF_II_3x8_Pak'
    GunsightSize=0.282 // 8 degrees visible FOV at 3x magnification (ZF 3x8 Pak sight)
    AmmoShellTexture=Texture'InterfaceArt_tex.Tank_Hud.panzer4F2shell'
    AmmoShellReloadTexture=Texture'InterfaceArt_tex.Tank_Hud.panzer4F2shell_reload'
    TPCamLookat=(Z=-50)
    OverlayCorrectionX=8
}

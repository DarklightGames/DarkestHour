//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_Breda35CannonPawn extends DHATGunCannonPawn;

defaultproperties
{
    //Gun Class
    GunClass=class'DH_Breda35Cannon'

    //Driver's positions & anims
    DriverPositions(0)=(ViewLocation=(X=25.0,Y=0.0,Z=0.0),ViewFOV=25.0,TransitionUpAnim="optic_out",bDrawOverlays=true,bExposed=true)
    DriverPositions(1)=(TransitionUpAnim="lookover_up",TransitionDownAnim="optic_in",bExposed=true)
    DriverPositions(2)=(TransitionDownAnim="lookover_down",ViewPitchUpLimit=6000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=20000,ViewNegativeYawLimit=-20000,bExposed=true)
    DriverPositions(3)=(ViewFOV=12.0,ViewPitchUpLimit=6000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=20000,ViewNegativeYawLimit=-20000,bDrawOverlays=true,bExposed=true)

    IntermediatePositionIndex=1 // the open sights position (used to play a special 'intermediate' firing anim in that position)
    RaisedPositionIndex=2
    BinocPositionIndex=3
    DriveAnim="VIS2_driver_idle_close"
    DrivePos=(X=-35.0,Y=26.0,Z=13.0)
    CameraBone="CAMERA_COM"
    // TODO: gunsight camera bone? why is it not in this subclass tree?

    //Gunsight
    GunsightOverlay=Texture'DH_VehicleOptics_tex.German.ZF_3x8_Flak2cm'
    GunsightSize=0.32 // 8 degrees visible FOV at 3x magnification (ZF 3x8 Flak sight)
    OverlayCorrectionX=-6

    //HUD   // TODO: same tray as the one in the AB41?
    AmmoShellTexture=Texture'DH_InterfaceArt_tex.Tank_Hud.2341Mag'
    AmmoShellReloadTexture=Texture'DH_InterfaceArt_tex.Tank_Hud.2341Mag_reload'
}

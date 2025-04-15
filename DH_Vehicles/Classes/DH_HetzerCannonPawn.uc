//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_HetzerCannonPawn extends DHAssaultGunCannonPawn;

var() int PeriscopeRotation;

replication
{
    reliable if (bNetDirty && Role == ROLE_Authority)
        PeriscopeRotation;
}

defaultproperties
{
    //Gun Class
    GunClass=Class'DH_HetzerCannon'

    CameraBone="GUNSIGHT_CAMERA"
    PeriscopeCameraBone="PERISCOPE_CAMERA"
    PlayerCameraBone="COM_CAMERA"

    // gunsight
    DriverPositions(0)=(ViewFOV=15.0,bDrawOverlays=true,TransitionUpAnim="overlay_in")
    // periscope
    DriverPositions(1)=(ViewFOV=30.0,TransitionUpAnim="raise",TransitionDownAnim="overlay_out",DriverTransitionAnim="VStug3_com_close",ViewPitchUpLimit=1200,ViewPitchDownLimit=64500,ViewPositiveYawLimit=12000,ViewNegativeYawLimit=-12000,bDrawOverlays=true)
    // exposed
    DriverPositions(2)=(TransitionDownAnim="lower",DriverTransitionAnim="VStug3_com_open",ViewPitchUpLimit=5000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=65535,ViewNegativeYawLimit=-65535,bExposed=true)
    // binoculars
    DriverPositions(3)=(ViewFOV=12.000000,DriverTransitionAnim="stand_idleiron_binoc",ViewPitchUpLimit=5000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=65535,ViewNegativeYawLimit=-65535,bDrawOverlays=true,bExposed=true)

    GunsightPositions=1
    PeriscopePositionIndex=1
    BinocPositionIndex=3
    DrivePos=(X=0,Y=0,Z=58.0)
    bHasAltFire=false
    DriveAnim="VStug3_com_idle_close"

    //Gunsight
    GunsightOverlay=Texture'DH_VehicleOptics_tex.German.stug3_SflZF1a_sight'
    GunsightSize=0.533 // 8 degrees visible FOV at 5x magnification (Sfl.ZF1a sight)

    //HUD
    AmmoShellTexture=Texture'InterfaceArt_tex.Tank_Hud.panzer4F2shell'
    AmmoShellReloadTexture=Texture'InterfaceArt_tex.Tank_Hud.panzer4F2shell_reload'

    FireImpulse=(X=-200000.000000)

    OverlayCorrectionX=8    // The gunsight is offset by a pretty significant amount from the cannon.
    OverlayCorrectionY=8
}

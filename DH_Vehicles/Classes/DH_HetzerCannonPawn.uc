//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_HetzerCannonPawn extends DHAssaultGunCannonPawn;

defaultproperties
{
    //Gun Class
    GunClass=Class'DH_HetzerCannon'

    CameraBone="GUNSIGHT_CAMERA"
    PeriscopeCameraBone="PERISCOPE_CAMERA"
    PlayerCameraBone="COM_CAMERA"

    // gunsight
    DriverPositions(0)=(PositionMesh=SkeletalMesh'DH_Hetzer_anm.HETZER_TURRET_EARLY_INT',ViewFOV=15.0,bDrawOverlays=true,TransitionUpAnim="overlay_in")
    // periscope
    DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_Hetzer_anm.HETZER_TURRET_EARLY_INT',ViewFOV=30.0,TransitionUpAnim="raise",TransitionDownAnim="overlay_out",DriverTransitionAnim="hetzer_gunner_lower",ViewPitchUpLimit=1200,ViewPitchDownLimit=64500,ViewPositiveYawLimit=12000,ViewNegativeYawLimit=-12000,bDrawOverlays=true,ViewLocation=(Z=8))
    // exposed
    DriverPositions(2)=(PositionMesh=SkeletalMesh'DH_Hetzer_anm.HETZER_TURRET_EARLY_INT',TransitionDownAnim="lower",DriverTransitionAnim="hetzer_gunner_raise",ViewPitchUpLimit=5000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=65535,ViewNegativeYawLimit=-65535,bExposed=true)
    // binoculars
    DriverPositions(3)=(PositionMesh=SkeletalMesh'DH_Hetzer_anm.HETZER_TURRET_EARLY_INT',ViewFOV=12.000000,DriverTransitionAnim="hetzer_gunner_binocs",ViewPitchUpLimit=5000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=65535,ViewNegativeYawLimit=-65535,bDrawOverlays=true,bExposed=true)

    GunsightPositions=1
    PeriscopePositionIndex=1
    BinocPositionIndex=3
    DrivePos=(X=0,Y=0,Z=58.0)
    bHasAltFire=false
    DriveAnim="hetzer_gunner_idle"

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

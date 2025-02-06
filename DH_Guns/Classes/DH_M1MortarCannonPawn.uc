//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================
class DH_M1MortarCannonPawn extends DH_Model35MortarCannonPawn;

defaultproperties
{
    GunClass=class'DH_Guns.DH_M1MortarCannon'

    AmmoShellTextures(0)=Texture'DH_Model35Mortar_tex.interface.US_HE_M43A1_ICON'
    AmmoShellTextures(1)=Texture'DH_Model35Mortar_tex.interface.US_WP_M56_ICON'
    AmmoShellTextures(2)=Texture'DH_Model35Mortar_tex.interface.US_HE_M56_ICON'

    AmmoShellReloadTextures(0)=Texture'DH_Model35Mortar_tex.interface.US_HE_M43A1_ICON_RELOAD'
    AmmoShellReloadTextures(1)=Texture'DH_Model35Mortar_tex.interface.US_WP_M56_ICON_RELOAD'
    AmmoShellReloadTextures(2)=Texture'DH_Model35Mortar_tex.interface.US_HE_M56_ICON_RELOAD'

    PlayerCameraBone="US_CAMERA_COM"
    CameraBone="US_GUNSIGHT_CAMERA"

    ArtillerySpottingScopeClass=class'DH_Guns.DHArtillerySpottingScope_Model35Mortar'

    // Spotting Scope
    DriverPositions(0)=(PositionMesh=SkeletalMesh'DH_Model35Mortar_anm.m1mortar_tube_ext',DriverTransitionAnim="crouch_idle_binoc",TransitionUpAnim="overlay_out",ViewFOV=40.0,ViewPitchUpLimit=2731,ViewPitchDownLimit=64626,ViewPositiveYawLimit=6000,ViewNegativeYawLimit=-6000,bDrawOverlays=true,bExposed=true)
    DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_Model35Mortar_anm.m1mortar_tube_ext',DriverTransitionAnim="crouch_idle_binoc",TransitionUpAnim="com_open",TransitionDownAnim="overlay_in",ViewPitchUpLimit=8192,ViewPitchDownLimit=55000,ViewPositiveYawLimit=20000,ViewNegativeYawLimit=-20000,bExposed=true)
    DriverPositions(2)=(PositionMesh=SkeletalMesh'DH_Model35Mortar_anm.m1mortar_tube_ext',DriverTransitionAnim="stand_idlehip_binoc",TransitionDownAnim="com_close",ViewPitchUpLimit=6000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=20000,ViewNegativeYawLimit=-20000,bExposed=true)
    DriverPositions(3)=(PositionMesh=SkeletalMesh'DH_Model35Mortar_anm.m1mortar_tube_ext',DriverTransitionAnim="stand_idleiron_binoc",ViewFOV=12.0,ViewPitchUpLimit=6000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=20000,ViewNegativeYawLimit=-20000,bDrawOverlays=true,bExposed=true)
}

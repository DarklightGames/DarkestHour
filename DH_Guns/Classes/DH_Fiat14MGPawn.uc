//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_Fiat14MGPawn extends DH_Fiat1435MGPawn;

defaultproperties
{
    GunClass=Class'DH_Fiat14MG'
    HandsReloadSequence="RELOAD_WC"

    DriverPositions(0)=(PositionMesh=SkeletalMesh'DH_Fiat1435_anm.FIAT1435_GUN_WC_1ST',bExposed=true,ViewFOV=72.5/*,TransitionUpAnim="RAISE"*/)
    DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_Fiat1435_anm.FIAT1435_GUN_WC_1ST',bExposed=true,ViewFOV=72.5/*,TransitionDownAnim="LOWER"*/)
    DriverPositionsExtra(0)=(CameraBone="GUNSIGHT_CAMERA_WC")
    DriverPositionsExtra(1)=(CameraBone="GUNSIGHT_CAMERA_WC")
    GunsightCameraBone="GUNSIGHT_CAMERA_WC"
    VehicleMGReloadTexture=Texture'DH_Fiat1435_tex.fiat14_ammo_reload'

    
}
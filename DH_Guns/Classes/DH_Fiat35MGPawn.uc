//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_Fiat35MGPawn extends DH_Fiat1435MGPawn;

defaultproperties
{
    GunClass=Class'DH_Fiat35MG'
    HandsReloadSequence="RELOAD_AC" // TODO: replace
    DriverPositions(0)=(PositionMesh=SkeletalMesh'DH_Fiat1435_anm.FIAT1435_GUN_AC_1ST',bExposed=true,ViewFOV=72.5/*,TransitionUpAnim="RAISE"*/)
    DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_Fiat1435_anm.FIAT1435_GUN_AC_1ST',bExposed=true,ViewFOV=72.5/*,TransitionDownAnim="LOWER"*/)
    DriverPositionsExtra(0)=(CameraBone="GUNSIGHT_CAMERA_AC")
    DriverPositionsExtra(1)=(CameraBone="GUNSIGHT_CAMERA_AC")
    GunsightCameraBone="GUNSIGHT_CAMERA_AC"
}

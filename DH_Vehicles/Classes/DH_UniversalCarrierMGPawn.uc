//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_UniversalCarrierMGPawn extends DHVehicleMGPawn;

defaultproperties
{
    GunClass=Class'DH_UniversalCarrierMG'
    PositionInArray=0
    bMustBeTankCrew=false
    bKeepDriverAuxCollision=true // necessary for new player hit detection system, which basically uses normal hit detection as for an infantry player pawn
    bMultiPosition=true
    DriverPositions(0)=(ViewFOV=72.0,PositionMesh=SkeletalMesh'allies_carrier_anm.Carrier_mg_int',TransitionUpAnim="com_open",DriverTransitionAnim="VUC_com_close",ViewPitchUpLimit=4000,ViewPitchDownLimit=60000,ViewPositiveYawLimit=9000,ViewNegativeYawLimit=-9000,bDrawOverlays=true,bExposed=true)
    DriverPositions(1)=(PositionMesh=SkeletalMesh'allies_carrier_anm.Carrier_mg_int',TransitionDownAnim="com_close",DriverTransitionAnim="VUC_com_open",ViewPitchUpLimit=4000,ViewPitchDownLimit=60000,ViewPositiveYawLimit=9000,ViewNegativeYawLimit=-9000,bDrawOverlays=true,bExposed=true)
    UnbuttonedPositionIndex=0
    bDrawDriverInTP=true
    DriveRot=(Pitch=0,Roll=0,Yaw=16384)
    DriveAnim="VUC_com_idle_close"
    CameraBone="Camera_com"
    HUDOverlayClass=Class'ROVehDTOverlay'
    HUDOverlayOffset=(X=-30.0,Y=0.0,Z=0.0)
    HUDOverlayFOV=45.0
    FirstPersonGunRefBone="1stperson_wep"
    FirstPersonGunShakeScale=2.5
    FirstPersonOffsetZScale=3.0
    bHideMuzzleFlashAboveSights=true
    VehicleMGReloadTexture=Texture'DH_InterfaceArt_tex.DT_ammo_reload'
}

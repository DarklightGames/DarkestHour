//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DH_BrenCarrierMGPawn extends DHVehicleMGPawn;

defaultproperties
{
    GunClass=class'DH_Vehicles.DH_BrenCarrierMG'
    PositionInArray=0
    bMustBeTankCrew=false
    bKeepDriverAuxCollision=true // necessary for new player hit detection system, which basically uses normal hit detection as for an infantry player pawn
    bMultiPosition=true
    DriverPositions(0)=(ViewFOV=72.0,PositionMesh=SkeletalMesh'DH_BrenCarrier_anm.Bren_mg_int',TransitionUpAnim="com_open",DriverTransitionAnim="VUC_com_close",ViewPitchUpLimit=4000,ViewPitchDownLimit=60000,ViewPositiveYawLimit=7500,ViewNegativeYawLimit=-7500,bDrawOverlays=true,bExposed=true)
    DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_BrenCarrier_anm.Bren_mg_int',TransitionDownAnim="com_close",DriverTransitionAnim="VUC_com_open",ViewPitchUpLimit=4000,ViewPitchDownLimit=60000,ViewPositiveYawLimit=7500,ViewNegativeYawLimit=-7500,bDrawOverlays=true,bExposed=true)
    UnbuttonedPositionIndex=0
    bDrawDriverInTP=true
    DrivePos=(X=-6.0,Y=-4.0,Z=33.0)
    DriveRot=(Yaw=16384)
    DriveAnim="VUC_com_idle_close"
    CameraBone="Camera_com"
    HUDOverlayClass=class'DH_Vehicles.DH_Bren_VehHUDOverlay'
    HUDOverlayFOV=65.0
    FirstPersonGunRefBone="1stperson_wep"
    FirstPersonGunShakeScale=1.5
    FirstPersonOffsetZScale=3.0
    bHideMuzzleFlashAboveSights=true
    VehicleMGReloadTexture=Texture'DH_InterfaceArt_tex.Tank_Hud.Bren_ammo_reload'
}

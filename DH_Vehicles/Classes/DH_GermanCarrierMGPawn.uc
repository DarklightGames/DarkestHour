//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_GermanCarrierMGPawn extends DHVehicleMGPawn;

defaultproperties
{
    GunClass=class'DH_Vehicles.DH_GermanCarrierMG'
    PositionInArray=0
    bMustBeTankCrew=false
    bKeepDriverAuxCollision=true // necessary for new player hit detection system, which basically uses normal hit detection as for an infantry player pawn
    bMultiPosition=true
    DriverPositions(0)=(ViewFOV=72,PositionMesh=SkeletalMesh'allies_carrier_anm.Carrier_mg_int',TransitionUpAnim="com_open",DriverTransitionAnim="VUC_com_close",ViewPitchUpLimit=4000,ViewPitchDownLimit=60000,ViewPositiveYawLimit=9000,ViewNegativeYawLimit=-9000,bDrawOverlays=true,bExposed=true)
    DriverPositions(1)=(PositionMesh=SkeletalMesh'allies_carrier_anm.Carrier_mg_int',TransitionDownAnim="com_close",DriverTransitionAnim="VUC_com_open",ViewPitchUpLimit=4000,ViewPitchDownLimit=60000,ViewPositiveYawLimit=9000,ViewNegativeYawLimit=-9000,bDrawOverlays=true,bExposed=true)
    UnbuttonedPositionIndex=0
    bDrawDriverInTP=true
    DrivePos=(X=-12.0,Y=-2.0,Z=-7.0)
    DriveRot=(Pitch=0,Roll=0,Yaw=16384)
    DriveAnim="VUC_com_idle_close"
    CameraBone="camera_com"

    PitchUpLimit=4000
    PitchDownLimit=60000

    //HUD
    HUDOverlayClass=class'DH_Vehicles.DH_MG34_VehHUDOverlay'
    HUDOverlayFOV=45.0

    //Shake and effects
    FirstPersonGunRefBone="1stperson_wep"
    FirstPersonGunShakeScale=2.0
    FirstPersonOffsetZScale=3.0
    bHideMuzzleFlashAboveSights=true
}

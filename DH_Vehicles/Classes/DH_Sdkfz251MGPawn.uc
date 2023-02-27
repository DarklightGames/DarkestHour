//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_Sdkfz251MGPawn extends DHVehicleMGPawn;

defaultproperties
{
    GunClass=class'DH_Vehicles.DH_Sdkfz251MG'
    PositionInArray=0
    bMustBeTankCrew=false
    bKeepDriverAuxCollision=true // necessary for new player hit detection system, which basically uses normal hit detection as for an infantry player pawn
    bMultiPosition=true
    DriverPositions(0)=(ViewFOV=72.0,PositionMesh=SkeletalMesh'DH_Sdkfz251Halftrack_anm.halftrack_gun_int',TransitionUpAnim="com_open",DriverTransitionAnim="Vhalftrack_com_close",ViewPitchUpLimit=2000,ViewPitchDownLimit=63000,ViewPositiveYawLimit=10000,ViewNegativeYawLimit=-10000,bDrawOverlays=true,bExposed=true)
    DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_Sdkfz251Halftrack_anm.halftrack_gun_int',TransitionDownAnim="com_close",DriverTransitionAnim="Vhalftrack_com_open",ViewPitchUpLimit=2000,ViewPitchDownLimit=63000,ViewPositiveYawLimit=10000,ViewNegativeYawLimit=-10000,bDrawOverlays=true,bExposed=true)
    UnbuttonedPositionIndex=0
    bDrawDriverInTP=true
    DrivePos=(X=13.0,Y=0.0,Z=7.0)
    DriveRot=(Yaw=16384)
    DriveAnim="VHalftrack_com_idle"
    CameraBone="Camera_com"
    HUDOverlayClass=class'ROVehicles.ROVehMG34Overlay'
    HUDOverlayFOV=45.0
    FirstPersonGunRefBone="1stperson_wep"
    FirstPersonGunShakeScale=2.0
    FirstPersonOffsetZScale=3.0
    bHideMuzzleFlashAboveSights=true
}

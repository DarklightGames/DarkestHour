//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_M7PriestMGPawn extends DHVehicleMGPawn;

defaultproperties
{
    GunClass=class'DH_Vehicles.DH_M7PriestMG'
    PositionInArray=1
    bMustBeTankCrew=false
    GunsightCameraBone="com_camera"
    bKeepDriverAuxCollision=true // necessary for new player hit detection system, which basically uses normal hit detection as for an infantry player pawn
    bMultiPosition=false
    DriverPositions(0)=(ViewFOV=60.0,PositionMesh=SkeletalMesh'DH_50cal_1st.50cal_1st',TransitionUpAnim="com_open",DriverTransitionAnim="Vhalftrack_com_close",ViewPitchUpLimit=5000,ViewPitchDownLimit=63000,bDrawOverlays=true,bExposed=true)
    DriverPositions(1)=(ViewFOV=90.0,PositionMesh=SkeletalMesh'DH_50cal_1st.50cal_1st',TransitionDownAnim="com_close",DriverTransitionAnim="Vhalftrack_com_open",ViewPitchUpLimit=5000,ViewPitchDownLimit=63000,bDrawOverlays=true,bExposed=true)
    UnbuttonedPositionIndex=0
    bDrawDriverInTP=true
    DriveAnim="stand_idleiron_mg42"
    HUDOverlayClass=class'DH_Vehicles.DH_VehHUDOverlay_50Cal'
    HUDOverlayOffset=(X=-2.0)
    HUDOverlayFOV=35.0
    FirstPersonGunRefBone="1stperson_wep"
    FirstPersonGunShakeScale=0.75
    FirstPersonOffsetZScale=1.0
    bHideMuzzleFlashAboveSights=true
}


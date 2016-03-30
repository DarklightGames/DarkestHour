//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_Marder3MMountedMGPawn extends DHVehicleMGPawn;

// Can't fire if using binoculars
function bool CanFire()
{
    return DriverPositionIndex != BinocPositionIndex;
}

defaultproperties
{
    GunClass=class'DH_Vehicles.DH_Marder3MMountedMG'
    bKeepDriverAuxCollision=true // necessary for new player hit detection system, which basically uses normal hit detection as for an infantry player pawn
    bMultiPosition=true
    DriverPositions(0)=(ViewFOV=60.0,PositionMesh=SkeletalMesh'DH_Marder3M_anm.Marder_M34_int',TransitionUpAnim="loader_open",DriverTransitionAnim="Vhalftrack_com_close",ViewPitchUpLimit=6000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=5500,ViewNegativeYawLimit=-5500,bDrawOverlays=true,bExposed=true)
    DriverPositions(1)=(ViewFOV=60.0,PositionMesh=SkeletalMesh'DH_Marder3M_anm.Marder_M34_int',TransitionDownAnim="loader_close",DriverTransitionAnim="Vhalftrack_com_open",ViewPitchUpLimit=6000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=5500,ViewNegativeYawLimit=-5500,bDrawOverlays=true,bExposed=true)
    DriverPositions(2)=(ViewFOV=12.0,PositionMesh=SkeletalMesh'DH_Marder3M_anm.Marder_M34_int',DriverTransitionAnim="stand_idleiron_binoc",ViewPitchUpLimit=6000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=10000,ViewNegativeYawLimit=-10000,bDrawOverlays=true,bExposed=true)
    UnbuttonedPositionIndex=0
    BinocPositionIndex=2
    bDrawDriverInTP=true
    DrivePos=(X=8.5,Y=0.0,Z=-21.5)
    DriveRot=(Yaw=16384)
    BinocsDrivePos=(X=5.0,Y=2.0,Z=-39.0)
    DriveAnim="VHalftrack_com_idle"
    CameraBone="loader_cam"
    HUDOverlayClass=class'DH_Vehicles.DH_VehHUDOverlay_MG34'
    HUDOverlayFOV=45.0
    BinocsOverlay=texture'DH_VehicleOptics_tex.German.BINOC_overlay_6x30Germ'
    FirstPersonGunRefBone="firstperson_wep"
    FirstPersonGunShakeScale=2.0
    FirstPersonOffsetZScale=1.0
    bHideMuzzleFlashAboveSights=true
}

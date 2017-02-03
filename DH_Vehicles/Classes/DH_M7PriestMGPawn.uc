//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_M7PriestMGPawn extends DHVehicleMGPawn;

defaultproperties
{
    GunClass=class'DH_Vehicles.DH_M7PriestMG'
    bMustBeTankCrew=false // TODO: unusual/unique?
    bKeepDriverAuxCollision=true // necessary for new player hit detection system, which basically uses normal hit detection as for an infantry player pawn
    bMultiPosition=true
    DriverPositions(0)=(ViewFOV=60.0,PositionMesh=SkeletalMesh'DH_M7Priest_anm.priest_mg_int',TransitionUpAnim="com_open",ViewPitchUpLimit=5000,ViewPitchDownLimit=63000,bDrawOverlays=true,bExposed=true)
    DriverPositions(1)=(ViewFOV=12.0,PositionMesh=SkeletalMesh'DH_M7Priest_anm.priest_mg_int',DriverTransitionAnim="stand_idleiron_binoc",ViewPitchUpLimit=5000,ViewPitchDownLimit=63000,bDrawOverlays=true,bExposed=true)
    UnbuttonedPositionIndex=0
    BinocPositionIndex=1
    BinocsOverlay=texture'DH_VehicleOptics_tex.Allied.BINOC_overlay_7x50Allied'
    //BinocsDrivePos=(X=-42.0,Y=-1.0,Z=-13.0) // TEST
    bDrawDriverInTP=true
    DriveAnim="stand_idleiron_mg42"
    HUDOverlayClass=class'DH_Vehicles.DH_VehHUDOverlay_50Cal'
    HUDOverlayFOV=40.0
    FirstPersonGunRefBone="1stperson_wep"
    FirstPersonGunShakeScale=1.0
    FirstPersonOffsetZScale=1.0
    bHideMuzzleFlashAboveSights=true
}

//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_M7PriestMGPawn extends DHVehicleMGPawn;

defaultproperties
{
    GunClass=class'DH_Vehicles.DH_M7PriestMG'
    bMustBeTankCrew=false
    bKeepDriverAuxCollision=true // necessary for new player hit detection system, which basically uses normal hit detection as for an infantry player pawn
    bMultiPosition=true
    DriverPositions(0)=(ViewFOV=72.0,PositionMesh=SkeletalMesh'DH_M7Priest_anm.priest_mg_int',DriverTransitionAnim="stand_idleiron_mg42",ViewPitchUpLimit=5000,ViewPitchDownLimit=63000,bDrawOverlays=true,bExposed=true)
//  DriverPositions(1)=(ViewFOV=12.0,PositionMesh=SkeletalMesh'DH_M7Priest_anm.priest_mg_int',DriverTransitionAnim="stand_idleiron_binoc",ViewPitchUpLimit=5000,ViewPitchDownLimit=63000,bDrawOverlays=true,bExposed=true)
    UnbuttonedPositionIndex=0
    BinocPositionIndex=1
    bDrawDriverInTP=true
    DrivePos=(X=-1.0,Y=0.0,Z=0.0)
    DriveAnim="stand_idleiron_mg42"
    CameraBone="com_camera"
    HUDOverlayClass=class'DH_Vehicles.DH_50Cal_VehHUDOverlay'
    HUDOverlayFOV=40.0
    // TODO: add position (between current 0 & 1) with head raised above sights, then uncomment these properties that are only relevant with that
    // Note such a raised position works best using the "Vhalftrack_com_" player anims (originally for the MG34 in halftrack), which include raising/lowering transition anims
//  FirstPersonGunRefBone="1stperson_wep"
//  FirstPersonOffsetZScale=1.0
//  bHideMuzzleFlashAboveSights=true
}

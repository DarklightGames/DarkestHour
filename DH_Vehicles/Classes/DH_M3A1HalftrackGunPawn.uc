//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_M3A1HalftrackGunPawn extends DHVehicleMGPawn;

// TEST added so player pawn's body part hit detection is aligned correctly between server & client (Matt, May 2015)
simulated function AttachDriver(Pawn P)
{
    local coords GunnerAttachmentBoneCoords;

    if (Gun != none)
    {
        P.bHardAttach = true;
        GunnerAttachmentBoneCoords = Gun.GetBoneCoords(Gun.GunnerAttachmentBone);
        P.SetLocation(GunnerAttachmentBoneCoords.Origin + DrivePos + P.default.PrePivot); // added + DrivePos + P.default.PrePivot
        P.SetPhysics(PHYS_None);
        Gun.AttachToBone(P, Gun.GunnerAttachmentBone);
        P.SetRelativeLocation(DrivePos + P.default.PrePivot);
        P.SetRelativeRotation(DriveRot);
        P.PrePivot=vect(0.0, 0.0, 0.0);
    }
}

defaultproperties
{
    UnbuttonedPositionIndex=0
    FirstPersonGunShakeScale=0.75
    WeaponFOV=60.0
    DriverPositions(0)=(ViewFOV=60.0,PositionMesh=SkeletalMesh'DH_M3A1Halftrack_anm.m3halftrack_gun_int',TransitionUpAnim="com_open",DriverTransitionAnim="Vhalftrack_com_close",ViewPitchUpLimit=5000,ViewPitchDownLimit=63000,ViewPositiveYawLimit=12000,ViewNegativeYawLimit=-12000,bDrawOverlays=true,bExposed=true)
    DriverPositions(1)=(ViewFOV=90.0,PositionMesh=SkeletalMesh'DH_M3A1Halftrack_anm.m3halftrack_gun_int',TransitionDownAnim="com_close",DriverTransitionAnim="Vhalftrack_com_open",ViewPitchUpLimit=5000,ViewPitchDownLimit=63000,ViewPositiveYawLimit=12000,ViewNegativeYawLimit=-12000,bDrawOverlays=true,bExposed=true)
    bMultiPosition=true
    bMustBeTankCrew=false
    GunClass=class'DH_Vehicles.DH_M3A1HalftrackGun'
    PositionInArray=0
    bHasAltFire=false
    CameraBone="Camera_com"
    FirstPersonGunRefBone="1stperson_wep"
    FirstPersonOffsetZScale=1.0
    bHideMuzzleFlashAboveSights=true
    DrivePos=(Y=-5.0,Z=14.0)
    DriveRot=(Yaw=16384)
    DriveAnim="VHalftrack_com_idle"
    EntryRadius=130.0
    HUDOverlayClass=class'DH_Vehicles.DH_VehHUDOverlay_30Cal'
    HUDOverlayOffset=(X=-2.0)
    HUDOverlayFOV=35.0
    bKeepDriverAuxCollision=true
    bPlayerCollisionBoxMoves=true; // TEST, so server always plays animations, to put serverside gunner collision in correct place (Matt, May 2015)
    PitchUpLimit=4000
    PitchDownLimit=60000
}

//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_HigginsBoatMGPawn extends DHVehicleMGPawn;

// Can't fire if using binoculars
function bool CanFire()
{
    return DriverPositionIndex != BinocPositionIndex || !IsHumanControlled();
}

// Modified so if player moves off binoculars (where he could look around) & back onto the MG, we match rotation back to the direction MG is facing
// Otherwise rotation becomes de-synced & he can have the wrong view rotation if he moves back onto binocs or exits
// Note we do this from state LeavingViewTransition instead of ViewTransition so that a CanFire() check in SetInitialViewRotation() works properly
simulated state LeavingViewTransition
{
    simulated function EndState()
    {
        super.EndState();

        if (LastPositionIndex == BinocPositionIndex && IsFirstPerson())
        {
            SetInitialViewRotation();
        }
    }
}

defaultproperties
{
    GunClass=class'DH_Vehicles.DH_HigginsBoatMG'
    PositionInArray=0
    bMustBeTankCrew=false
    bKeepDriverAuxCollision=true // necessary for new player hit detection system, which basically uses normal hit detection as for an infantry player pawn
    bMultiPosition=true
    DriverPositions(0)=(PositionMesh=SkeletalMesh'DH_HigginsBoat_anm.Higgins_MG_1st',TransitionUpAnim="com_open",DriverTransitionAnim="Vhalftrack_com_close",ViewPitchUpLimit=5000,ViewPitchDownLimit=63000,ViewPositiveYawLimit=12000,ViewNegativeYawLimit=-12000,bDrawOverlays=true,bExposed=true)
    DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_HigginsBoat_anm.Higgins_MG_1st',TransitionDownAnim="com_close",DriverTransitionAnim="Vhalftrack_com_open",ViewPitchUpLimit=5000,ViewPitchDownLimit=63000,ViewPositiveYawLimit=12000,ViewNegativeYawLimit=-12000,bDrawOverlays=true,bExposed=true)
    DriverPositions(2)=(ViewFOV=12.0,PositionMesh=SkeletalMesh'DH_HigginsBoat_anm.Higgins_MG_1st',DriverTransitionAnim="stand_idleiron_binoc",ViewPitchUpLimit=5300,ViewPitchDownLimit=63000,ViewPositiveYawLimit=12000,ViewNegativeYawLimit=-12000,bDrawOverlays=true,bExposed=true)
    UnbuttonedPositionIndex=0
    BinocPositionIndex=2
    bDrawDriverInTP=true
    DrivePos=(X=0.0,Y=-7.0,Z=13.0)
    DriveRot=(Yaw=16384)
    DriveAnim="VHalftrack_com_idle"
    CameraBone="Camera_com"
    HUDOverlayClass=class'DH_Vehicles.DH_30Cal_VehHUDOverlay'
    HUDOverlayOffset=(X=-2.0)
    HUDOverlayFOV=35.0
    FirstPersonGunRefBone="1stperson_wep"
    FirstPersonGunShakeScale=0.75
    FirstPersonOffsetZScale=1.0
    bHideMuzzleFlashAboveSights=true
}

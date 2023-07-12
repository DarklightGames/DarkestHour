//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_Marder3MMountedMGPawn extends DHVehicleMGPawn;

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
    GunClass=class'DH_Vehicles.DH_Marder3MMountedMG'
    bKeepDriverAuxCollision=true // necessary for new player hit detection system, which basically uses normal hit detection as for an infantry player pawn
    bMultiPosition=true
    DriverPositions(0)=(ViewFOV=72.0,PositionMesh=SkeletalMesh'DH_Marder3M_anm.Marder_M34_int',TransitionUpAnim="loader_open",DriverTransitionAnim="Vhalftrack_com_close",ViewPitchUpLimit=6000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=5500,ViewNegativeYawLimit=-5500,bDrawOverlays=true,bExposed=true)
    DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_Marder3M_anm.Marder_M34_int',TransitionDownAnim="loader_close",DriverTransitionAnim="Vhalftrack_com_open",ViewPitchUpLimit=6000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=5500,ViewNegativeYawLimit=-5500,bDrawOverlays=true,bExposed=true)
    DriverPositions(2)=(ViewFOV=12.0,PositionMesh=SkeletalMesh'DH_Marder3M_anm.Marder_M34_int',DriverTransitionAnim="stand_idleiron_binoc",ViewPitchUpLimit=6000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=10000,ViewNegativeYawLimit=-10000,bDrawOverlays=true,bExposed=true)
    UnbuttonedPositionIndex=0
    BinocPositionIndex=2
    bDrawDriverInTP=true
    DrivePos=(X=8.5,Y=0.0,Z=-21.5)
    DriveRot=(Yaw=16384)
    BinocsDrivePos=(X=5.0,Y=2.0,Z=-39.0)
    DriveAnim="VHalftrack_com_idle"
    CameraBone="loader_cam"
    HUDOverlayClass=class'DH_Vehicles.DH_MG34_VehHUDOverlay'
    HUDOverlayFOV=45.0
    FirstPersonGunRefBone="firstperson_wep"
    FirstPersonGunShakeScale=2.0
    FirstPersonOffsetZScale=1.0
    bHideMuzzleFlashAboveSights=true
}

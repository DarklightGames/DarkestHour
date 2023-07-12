//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_Stug3GMountedMGPawn extends DHVehicleMGPawn;

// Can't fire unless unbuttoned & controlling the external MG (not on binocs)
function bool CanFire()
{
    return (DriverPositionIndex == UnbuttonedPositionIndex && (!IsInState('ViewTransition') || LastPositionIndex > DriverPositionIndex))
        || (DriverPositionIndex > UnbuttonedPositionIndex && DriverPositionIndex != BinocPositionIndex)
        || !IsHumanControlled();
}

// Modified to show a hint that player must be unbuttoned to fire or reload the externally mounted MG
simulated function ClientKDriverEnter(PlayerController PC)
{
    super.ClientKDriverEnter(PC);

    if (DHPlayer(PC) != none)
    {
        DHPlayer(PC).QueueHint(46, true);
    }
}

// Modified so if player moves back onto the MG from a position where he could look around freely, we match rotation back to the direction MG is facing
// Otherwise rotation becomes de-synced & he can have the wrong view rotation if he moves off the gun again or exits
// Note we do this from state LeavingViewTransition instead of ViewTransition so that a CanFire() check in SetInitialViewRotation() works properly
simulated state LeavingViewTransition
{
    simulated function EndState()
    {
        super.EndState();

        if ((LastPositionIndex < UnbuttonedPositionIndex || LastPositionIndex == BinocPositionIndex) && IsFirstPerson()) // has either unbuttoned or moved off binoculars
        {
            SetInitialViewRotation();
        }
    }
}

defaultproperties
{
    GunClass=class'DH_Vehicles.DH_Stug3GMountedMG'
    bKeepDriverAuxCollision=true // necessary for new player hit detection system, which basically uses normal hit detection as for an infantry player pawn
    bMultiPosition=true
    DriverPositions(0)=(PositionMesh=SkeletalMesh'DH_Stug3G_anm.Stug_mg34_ext',TransitionUpAnim="loader_unbutton",ViewPitchUpLimit=7500,ViewPitchDownLimit=65535,ViewPositiveYawLimit=5500,ViewNegativeYawLimit=-5500)
    DriverPositions(1)=(ViewFOV=72.0,PositionMesh=SkeletalMesh'DH_Stug3G_anm.Stug_mg34_int',TransitionUpAnim="loader_open",TransitionDownAnim="loader_button",DriverTransitionAnim="Vhalftrack_com_close",ViewPitchUpLimit=2400,ViewPitchDownLimit=63500,ViewPositiveYawLimit=5500,ViewNegativeYawLimit=-5500,bDrawOverlays=true,bExposed=true)
    DriverPositions(2)=(PositionMesh=SkeletalMesh'DH_Stug3G_anm.Stug_mg34_int',TransitionDownAnim="loader_close",DriverTransitionAnim="Vhalftrack_com_open",ViewPitchUpLimit=2400,ViewPitchDownLimit=63500,ViewPositiveYawLimit=5500,ViewNegativeYawLimit=-5500,bDrawOverlays=true,bExposed=true)
    DriverPositions(3)=(ViewFOV=12.0,PositionMesh=SkeletalMesh'DH_Stug3G_anm.Stug_mg34_int',DriverTransitionAnim="stand_idleiron_binoc",ViewPitchUpLimit=6000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=10000,ViewNegativeYawLimit=-10000,bDrawOverlays=true,bExposed=true)
    BinocPositionIndex=3
    bMustUnbuttonToReload=true
    bDrawDriverInTP=true
    DrivePos=(X=4.0,Y=3.0,Z=20.0)
    DriveRot=(Yaw=16384)
    BinocsDrivePos=(X=-2.0,Y=5.0,Z=4.0)
    DriveAnim="VHalftrack_com_idle"
    CameraBone="loader_cam"
    HUDOverlayClass=class'DH_Vehicles.DH_MG34_VehHUDOverlay'
    HUDOverlayFOV=45.0
    FirstPersonGunRefBone="firstperson_wep"
    FirstPersonGunShakeScale=2.0
    FirstPersonOffsetZScale=3.0
}

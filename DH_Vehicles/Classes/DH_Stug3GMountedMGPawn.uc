//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_Stug3GMountedMGPawn extends DHVehicleMGPawn;

// Can't fire unless unbuttoned & controlling the external MG
function bool CanFire()
{
    return (DriverPositionIndex == UnbuttonedPositionIndex && !IsInState('ViewTransition')) || DriverPositionIndex > UnbuttonedPositionIndex;
}

// Modified to do null UpdateSpecialCustomAim(), otherwise MG faces wrong direction when player enters in buttoned up position, not controlling external MG
simulated state EnteringVehicle // Matt: this is a TEST as an alternative to doing this in UpdateRocketAcceleration
{
    simulated function HandleEnter()
    {
        super.HandleEnter();

        UpdateSpecialCustomAim(0.01, 0.0, 0.0);
    }
}

// TODO: the specified Vhalftrack_X anims are missing from DHCharacters_anm file, so see if it can be imported from the RO version - until then these anims don't exist & can't play
defaultproperties
{
    bKeepDriverAuxCollision=true // necessary for new player hit detection system, which basically uses normal hit detection as for an infantry player pawn
    FirstPersonGunShakeScale=2.0
    WeaponFOV=72.0
    DriverPositions(0)=(ViewFOV=90.0,PositionMesh=SkeletalMesh'DH_Stug3G_anm.Stug_mg34_ext',TransitionUpAnim="loader_unbutton",/*DriverTransitionAnim="Vhalftrack_com_close",*/ViewPitchUpLimit=7500,ViewPitchDownLimit=65535,ViewPositiveYawLimit=5500,ViewNegativeYawLimit=-5500)
    DriverPositions(1)=(ViewFOV=90.0,PositionMesh=SkeletalMesh'DH_Stug3G_anm.Stug_mg34_int',TransitionUpAnim="loader_open",TransitionDownAnim="loader_button",/*DriverTransitionAnim="Vhalftrack_com_open",*/ViewPitchUpLimit=2400,ViewPitchDownLimit=63500,ViewPositiveYawLimit=5500,ViewNegativeYawLimit=-5500,bDrawOverlays=true,bExposed=true)
    DriverPositions(2)=(ViewFOV=90.0,PositionMesh=SkeletalMesh'DH_Stug3G_anm.Stug_mg34_int',TransitionDownAnim="loader_close",ViewPitchUpLimit=2400,ViewPitchDownLimit=63500,ViewPositiveYawLimit=5500,ViewNegativeYawLimit=-5500,bDrawOverlays=true,bExposed=true)
    bMultiPosition=true
    GunClass=class'DH_Vehicles.DH_Stug3GMountedMG'
    bHasAltFire=false
    CameraBone="loader_cam"
    FirstPersonGunRefBone="firstperson_wep"
    FirstPersonOffsetZScale=3.0
    DrivePos=(X=16.0,Z=20.0)
    DriveRot=(Yaw=16384)
    DriveAnim="VHalftrack_com_idle"
    EntryRadius=130.0
    HUDOverlayClass=class'DH_Vehicles.DH_VehHUDOverlay_MG34'
    HUDOverlayFOV=45.0
    PitchUpLimit=6000
    PitchDownLimit=63500
}

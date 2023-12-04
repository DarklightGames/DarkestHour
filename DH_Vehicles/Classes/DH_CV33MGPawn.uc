//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_CV33MGPawn extends DHVehicleMGPawn;

function bool CanFire()
{
    // Ugly, but this stops the gun from firing and uses the normal CameraBone on other positions.
    // TODO: Having these two concepts tied together is dumb, perhaps we can fix this in the future.
    return DriverPositionIndex == 0;
}

// Only allow the gunner to reload if they are on the gunsight or still buttoned up.
simulated function bool CanReload()
{
    return DriverPositionIndex < 2;
}

defaultproperties
{
    GunClass=class'DH_Vehicles.DH_CV33MG'
    PositionInArray=0
    bMustBeTankCrew=false
    bKeepDriverAuxCollision=true // necessary for new player hit detection system, which basically uses normal hit detection as for an infantry player pawn
    bMultiPosition=true
    DriverPositions(0)=(ViewFOV=72.0,PositionMesh=SkeletalMesh'DH_CV33_anm.cv33_turret_ext',DriverTransitionAnim="VUC_com_close",ViewPitchUpLimit=4000,ViewPitchDownLimit=60000,ViewPositiveYawLimit=9000,ViewNegativeYawLimit=-9000,bDrawOverlays=true)
    DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_CV33_anm.cv33_turret_ext',TransitionUpAnim="cv33_turret_open",DriverTransitionAnim="VUC_com_open",ViewPitchUpLimit=4000,ViewPitchDownLimit=60000,ViewPositiveYawLimit=9000,ViewNegativeYawLimit=-9000)
    DriverPositions(2)=(PositionMesh=SkeletalMesh'DH_CV33_anm.cv33_turret_ext',TransitionDownAnim="cv33_turret_close",DriverTransitionAnim="VUC_com_open",ViewPitchUpLimit=4000,ViewPitchDownLimit=60000,ViewPositiveYawLimit=27000,ViewNegativeYawLimit=-27000,bExposed=true)
    DriverPositions(3)=(PositionMesh=SkeletalMesh'DH_CV33_anm.cv33_turret_ext',ViewPitchUpLimit=4000,ViewPitchDownLimit=60000,ViewPositiveYawLimit=27000,ViewNegativeYawLimit=-27000,bExposed=true,bDrawOverlays=true)
    UnbuttonedPositionIndex=2
    BinocPositionIndex=3
    bDrawDriverInTP=true
    DriveRot=(Pitch=0,Roll=0,Yaw=16384)
    DriveAnim="VUC_com_idle_close"
    
    FirstPersonGunRefBone="1stperson_wep"
    FirstPersonGunShakeScale=2.5
    FirstPersonOffsetZScale=3.0
    bHideMuzzleFlashAboveSights=true
    VehicleMGReloadTexture=Texture'DH_InterfaceArt_tex.Tank_Hud.DT_ammo_reload'

    GunsightOverlay=Texture'DH_CV33_tex.cv33_gunsight'
    GunsightSize=0.6

    GunsightCameraBone="GUNSIGHT_CAMERA"
    CameraBone="GUNNER_CAMERA"
}

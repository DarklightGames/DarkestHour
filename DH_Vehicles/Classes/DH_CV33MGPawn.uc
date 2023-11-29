//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_CV33MGPawn extends DHVehicleMGPawn;

function bool CanFire()
{
    return DriverPositionIndex == 0;
}

defaultproperties
{
    GunClass=class'DH_Vehicles.DH_CV33MG'
    PositionInArray=0
    bMustBeTankCrew=false
    bKeepDriverAuxCollision=true // necessary for new player hit detection system, which basically uses normal hit detection as for an infantry player pawn
    bMultiPosition=true
    DriverPositions(0)=(ViewFOV=72.0,PositionMesh=SkeletalMesh'DH_CV33_anm.cv33_turret_ext',TransitionUpAnim="com_open",DriverTransitionAnim="VUC_com_close",ViewPitchUpLimit=4000,ViewPitchDownLimit=60000,ViewPositiveYawLimit=9000,ViewNegativeYawLimit=-9000,bDrawOverlays=true,bExposed=false)
    DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_CV33_anm.cv33_turret_ext',TransitionDownAnim="com_close",DriverTransitionAnim="VUC_com_open",ViewPitchUpLimit=4000,ViewPitchDownLimit=60000,ViewPositiveYawLimit=9000,ViewNegativeYawLimit=-9000,bExposed=true)
    UnbuttonedPositionIndex=1
    bDrawDriverInTP=true
    DriveRot=(Pitch=0,Roll=0,Yaw=16384)
    DriveAnim="VUC_com_idle_close"
    
    FirstPersonGunRefBone="1stperson_wep"
    FirstPersonGunShakeScale=2.5
    FirstPersonOffsetZScale=3.0
    bHideMuzzleFlashAboveSights=true
    VehicleMGReloadTexture=Texture'DH_InterfaceArt_tex.Tank_Hud.DT_ammo_reload'

    GunsightOverlay=Texture'DH_VehicleOptics_tex.German.KZF2_MGSight'
    GunsightSize=0.381 // 18 degrees visible FOV at 1.8x magnification (KFZ2 sight)

    GunsightCameraBone="GUNSIGHT_CAMERA"
    CameraBone="GUNNER_CAMERA"
}

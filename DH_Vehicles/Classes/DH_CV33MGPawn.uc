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
    bKeepDriverAuxCollision=true
    bMultiPosition=true
    // Because of the way that explosives work, we must say that the driver is not exposed so that
    // he is not killed by explosives while buttoned up.
    DriverPositions(0)=(ViewFOV=72.0,PositionMesh=SkeletalMesh'DH_CV33_anm.cv33_turret_int',bDrawOverlays=true)
    DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_CV33_anm.cv33_turret_int',TransitionUpAnim="cv33_turret_open",DriverTransitionAnim="cv33_gunner_close",ViewPitchUpLimit=4000,ViewPitchDownLimit=60000,ViewPositiveYawLimit=16384,ViewNegativeYawLimit=-16384)
    DriverPositions(2)=(PositionMesh=SkeletalMesh'DH_CV33_anm.cv33_turret_int',TransitionDownAnim="cv33_turret_close",DriverTransitionAnim="cv33_gunner_open",ViewPitchUpLimit=14000,ViewPitchDownLimit=62500,ViewPositiveYawLimit=27000,ViewNegativeYawLimit=-27000,bExposed=true)
    DriverPositions(3)=(PositionMesh=SkeletalMesh'DH_CV33_anm.cv33_turret_int',DriverTransitionAnim="cv33_gunner_binocs",ViewPitchUpLimit=14000,ViewPitchDownLimit=62500,ViewPositiveYawLimit=27000,ViewNegativeYawLimit=-27000,bExposed=true,bDrawOverlays=true)
    UnbuttonedPositionIndex=2
    BinocPositionIndex=3
    bDrawDriverInTP=true
    DrivePos=(X=0,Y=0,Z=58)
    DriveRot=(Pitch=0,Yaw=16384,Roll=0)
    BinocsDriveRot=(Pitch=0,Yaw=16384,Roll=0)
    DriveAnim="cv33_gunner_closed"
    
    FirstPersonGunRefBone="1stperson_wep"
    FirstPersonGunShakeScale=2.5
    FirstPersonOffsetZScale=3.0
    bHideMuzzleFlashAboveSights=true
    VehicleMGReloadTexture=Texture'DH_InterfaceArt_tex.Tank_Hud.DT_ammo_reload'

    GunsightOverlay=Texture'DH_CV33_tex.cv33_gunsight'
    GunsightSize=0.6

    GunsightCameraBone="GUNSIGHT_CAMERA"
    CameraBone="GUNNER_CAMERA"

    AnimationDrivers(0)=(Sequence="cv33_gunner_yaw_driver",Type=ADT_Yaw,DriverPositionIndexRange=(Min=0,Max=1),FrameCount=32)
    bUseInternalMeshForBaseVehicle=true
}

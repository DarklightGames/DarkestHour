//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_BrenCarrierMGPawn extends DHVehicleMGPawn;

// Modified to better suit the curved magazine of the bren gun
function float GetAmmoReloadState()
{
    if (MGun != none)
    {
        switch (MGun.ReloadState)
        {
            case MG_ReadyToFire:    return 0.00;

            case MG_Waiting:
            case MG_Empty:
            case MG_ReloadedPart1:  return 1.00;
            case MG_ReloadedPart2:  return 0.67;
            case MG_ReloadedPart3:  return 0.50;
            case MG_ReloadedPart4:  return 0.35;
        }
    }
}

defaultproperties
{
    bKeepDriverAuxCollision=true // necessary for new player hit detection system, which basically uses normal hit detection as for an infantry player pawn
    VehicleMGReloadTexture=texture'DH_InterfaceArt_tex.Tank_Hud.Bren_ammo_reload'
    UnbuttonedPositionIndex=0
    FirstPersonGunShakeScale=1.5
    WeaponFOV=60.0
    DriverPositions(0)=(ViewFOV=60.0,PositionMesh=SkeletalMesh'DH_BrenCarrier_anm.Bren_mg_int',TransitionUpAnim="com_open",DriverTransitionAnim="VUC_com_close",ViewPitchUpLimit=4000,ViewPitchDownLimit=60000,ViewPositiveYawLimit=7500,ViewNegativeYawLimit=-7500,bDrawOverlays=true,bExposed=true)
    DriverPositions(1)=(ViewFOV=90.0,PositionMesh=SkeletalMesh'DH_BrenCarrier_anm.Bren_mg_int',TransitionDownAnim="com_close",DriverTransitionAnim="VUC_com_open",ViewPitchUpLimit=4000,ViewPitchDownLimit=60000,ViewPositiveYawLimit=7500,ViewNegativeYawLimit=-7500,bDrawOverlays=true,bExposed=true)
    bMultiPosition=true
    bMustBeTankCrew=false
    GunClass=class'DH_Vehicles.DH_BrenCarrierMG'
    PositionInArray=0
    bHasAltFire=false
    CameraBone="Camera_com"
    FirstPersonGunRefBone="1stperson_wep"
    FirstPersonOffsetZScale=3.0
    bHideMuzzleFlashAboveSights=true
    DrivePos=(X=-11.0,Y=-4.0,Z=31.0)
    DriveRot=(Yaw=16384)
    DriveAnim="VUC_com_idle_close"
    EntryRadius=130.0
    HUDOverlayClass=class'DH_Vehicles.DH_VehHUDOverlay_Bren'
    HUDOverlayOffset=(X=-6.0)
    HUDOverlayFOV=35.0
    PitchUpLimit=4000
    PitchDownLimit=60000
}

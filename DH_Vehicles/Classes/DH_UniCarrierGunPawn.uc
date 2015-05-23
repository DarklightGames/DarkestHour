//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_UniCarrierGunPawn extends DHMountedTankMGPawn; // Matt: originally extended ROMountedTankMGPawn

// Modified to better suit the curved magazine of the bren gun
function float GetAmmoReloadState()
{
    local float ProportionOfReloadRemaining;

    if (MGun != none)
    {
        if (MGun.ReadyToFire(false))
        {
            return 0.0;
        }
        else if (MGun.bReloading)
        {
            ProportionOfReloadRemaining = 1.0 - ((Level.TimeSeconds - MGun.ReloadStartTime) / MGun.ReloadDuration);

            if (ProportionOfReloadRemaining >= 0.75)
            {
                return 1.0;
            }
            else if (ProportionOfReloadRemaining >= 0.5)
            {
                return 0.67;
            }
            else if (ProportionOfReloadRemaining >= 0.25)
            {
                return 0.5;
            }
            else
            {
                return 0.35;
            }
        }
        else
        {
            return 1.0;
        }
    }
}

defaultproperties
{
    VehicleMGReloadTexture=texture'DH_InterfaceArt_tex.Tank_Hud.Bren_ammo_reload'
    UnbuttonedPositionIndex=0
    FirstPersonGunShakeScale=1.5
    WeaponFOV=60.0
    DriverPositions(0)=(ViewLocation=(X=10.0),ViewFOV=60.0,PositionMesh=SkeletalMesh'DH_allies_carrier_anm.Bren_mg_int',TransitionUpAnim="com_open",DriverTransitionAnim="VUC_com_close",ViewPitchUpLimit=4000,ViewPitchDownLimit=60000,ViewPositiveYawLimit=7500,ViewNegativeYawLimit=-7500,bDrawOverlays=true,bExposed=true)
    DriverPositions(1)=(ViewFOV=90.0,PositionMesh=SkeletalMesh'DH_allies_carrier_anm.Bren_mg_int',TransitionDownAnim="com_close",DriverTransitionAnim="VUC_com_open",ViewPitchUpLimit=4000,ViewPitchDownLimit=60000,ViewPositiveYawLimit=7500,ViewNegativeYawLimit=-7500,bDrawOverlays=true,bExposed=true)
    bMultiPosition=true
    bMustBeTankCrew=false
    GunClass=class'DH_Vehicles.DH_UniCarrierGun'
    bCustomAiming=true
    PositionInArray=0
    bHasAltFire=false
    CameraBone="Camera_com"
    FirstPersonGunRefBone="1stperson_wep"
    FirstPersonOffsetZScale=3.0
    bHideMuzzleFlashAboveSights=true
    bPCRelativeFPRotation=true
    bDesiredBehindView=false
    DrivePos=(X=-11.0,Y=-4.0,Z=31.0)
    DriveRot=(Yaw=16384)
    DriveAnim="VUC_com_idle_close"
    EntryRadius=130.0
    FPCamPos=(X=10.0)
    HUDOverlayClass=class'DH_Vehicles.DH_UniCarrierMGOverlay'
    HUDOverlayOffset=(X=-6.0)
    HUDOverlayFOV=35.0
    bKeepDriverAuxCollision=true
    PitchUpLimit=4000
    PitchDownLimit=60000
    ExitPositions(0)=(X=48.0,Y=-107.0,Z=15.0)
    ExitPositions(1)=(X=48.0,Y=117.0,Z=15.0)
    ExitPositions(2)=(X=52.0,Y=-119.0,Z=13.0)
    ExitPositions(3)=(X=-45.0,Y=-118.0,Z=15.0)
    ExitPositions(4)=(X=7.0,Y=110.0,Z=15.0)
    ExitPositions(5)=(X=-48.0,Y=111.0,Z=15.0)
}

//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DH_BA64MGPawn extends DHVehicleMGPawn;

defaultproperties
{
    GunClass=class'DH_Vehicles.DH_BA64MG'
    PositionInArray=0

    bKeepDriverAuxCollision=true // necessary for new player hit detection system, which basically uses normal hit detection as for an infantry player pawn
    bMultiPosition=true
	DriverPositions(0)=(ViewLocation=(X=0,Y=0,Z=0),ViewFOV=72,PositionMesh=Mesh'allies_ba64_anm.BA64_turret_int',DriverTransitionAnim=VBA64_com_close,TransitionUpAnim=com_open,ViewPitchUpLimit=3500,ViewPitchDownLimit=63500,ViewPositiveYawLimit=10000,ViewNegativeYawLimit=-10000,bDrawOverlays=false,bExposed=false)
    DriverPositions(1)=(PositionMesh=SkeletalMesh'allies_carrier_anm.Carrier_mg_int',TransitionDownAnim="com_close",DriverTransitionAnim="VUC_com_open",ViewPitchUpLimit=4000,ViewPitchDownLimit=60000,ViewPositiveYawLimit=9000,ViewNegativeYawLimit=-9000,bDrawOverlays=true,bExposed=true)
    UnbuttonedPositionIndex=0
    bDrawDriverInTP=true
    DriveRot=(Pitch=0,Roll=0,Yaw=16384)
    DriveAnim="VUC_com_idle_close"
    CameraBone="Camera_com"
    HUDOverlayClass=class'ROVehicles.ROVehDTOverlay'
    HUDOverlayOffset=(X=-30.0,Y=0.0,Z=0.0)
    HUDOverlayFOV=45.0
    FirstPersonGunRefBone="1stperson_wep"
    FirstPersonGunShakeScale=3.0
    FirstPersonOffsetZScale=3.0
    bHideMuzzleFlashAboveSights=true
    VehicleMGReloadTexture=Texture'DH_InterfaceArt_tex.Tank_Hud.DT_ammo_reload'
	bMustBeTankCrew=false
}

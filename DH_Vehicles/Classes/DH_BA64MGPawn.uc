//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DH_BA64MGPawn extends DHVehicleMGPawn;

defaultproperties
{
    //Gun Class
    GunClass=class'DH_Vehicles.DH_BA64MG'
    bKeepDriverAuxCollision=true // necessary for new player hit detection system, which basically uses normal hit detection as for an infantry player pawn

    //Driver's positions and anims
    DriverPositions(0)=(ViewLocation=(X=0,Y=0,Z=0),PositionMesh=Mesh'DH_BA64_anm.BA64_turret_int',DriverTransitionAnim=VBA64_com_close,TransitionUpAnim=com_open,ViewPitchUpLimit=3500,ViewPitchDownLimit=63500,ViewPositiveYawLimit=10000,ViewNegativeYawLimit=-10000,bDrawOverlays=true,bExposed=true)
    DriverPositions(1)=(ViewLocation=(X=0,Y=0,Z=0),PositionMesh=Mesh'DH_BA64_anm.BA64_turret_int',DriverTransitionAnim=VBA64_com_open,TransitionDownAnim=com_close,ViewPitchUpLimit=3500,ViewPitchDownLimit=63500,ViewPositiveYawLimit=10000,ViewNegativeYawLimit=-10000,bDrawOverlays=true,bExposed=true)
    DriverPositions(2)=(ViewLocation=(X=0,Y=0,Z=0),PositionMesh=Mesh'DH_BA64_anm.BA64_turret_int',DriverTransitionAnim="stand_idleiron_binoc",ViewPitchUpLimit=5000,ViewPitchDownLimit=63000,bDrawOverlays=true,bExposed=true)

    PositionInArray=0
    UnbuttonedPositionIndex=0
    BinocPositionIndex=2
    bDrawDriverInTP=true
    DrivePos=(X=0,Y=0,Z=0)
    DriveRot=(Pitch=0,Roll=0,Yaw=0)
    CameraBone="Camera_com"

    //HUD
    HUDOverlayClass=class'ROVehicles.ROVehDTOverlay'
    HUDOverlayOffset=(X=-30.0,Y=0.0,Z=0.0)
    HUDOverlayFOV=45.0
    VehicleMGReloadTexture=Texture'DH_InterfaceArt_tex.Tank_Hud.DT_ammo_reload'

    bMultiPosition=true
    bMustBeTankCrew=false
    bCustomAiming = true

    FirstPersonGunRefBone="1stperson_wep"
    FirstPersonGunShakeScale=3.0
    FirstPersonOffsetZScale=3.0
    bHideMuzzleFlashAboveSights=true
}

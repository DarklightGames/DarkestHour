//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2021
//==============================================================================

class DH_Flak38CannonPawn extends DHATGunCannonPawn;

defaultproperties
{
    //Gun Class
    GunClass=class'DH_Vehicles.DH_Flak38Cannon'

    //Driver's positions & anims
    DriverPositions(0)=(ViewLocation=(X=28.0,Y=-19.0,Z=3.0),ViewFOV=28.33,PositionMesh=SkeletalMesh'DH_Flak38_anm.Flak38_turret',TransitionUpAnim="com_open",DriverTransitionAnim="crouch_idlehold_bayo",ViewPitchUpLimit=4005,ViewPitchDownLimit=64623,ViewPositiveYawLimit=5825,ViewNegativeYawLimit=-5825,bDrawOverlays=true,bExposed=true)
    DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_Flak38_anm.Flak38_turret',TransitionDownAnim="com_close",DriverTransitionAnim="stand_idlehip_binoc",ViewPitchUpLimit=6000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=20000,ViewNegativeYawLimit=-20000,bExposed=true)
    DriverPositions(2)=(ViewFOV=12.0,PositionMesh=SkeletalMesh'DH_Flak38_anm.Flak38_turret',DriverTransitionAnim="stand_idleiron_binoc",ViewPitchUpLimit=6000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=20000,ViewNegativeYawLimit=-20000,bDrawOverlays=true,bExposed=true)

    IntermediatePositionIndex=1 // the open sights position (used to play a special 'intermediate' firing anim in that position)
    RaisedPositionIndex=2
    BinocPositionIndex=3
    DriveAnim="VIS2_driver_idle_close"
    DrivePos=(X=-35.0,Y=26.0,Z=13.0)
    CameraBone="Camera_com"

    //Gunsight
    GunsightOverlay=Texture'DH_VehicleOptics_tex.German.ZF_3x8_Flak2cm'
    GunsightSize=0.32 // 8 degrees visible FOV at 3x magnification (ZF 3x8 Flak sight)
    OverlayCorrectionX=-6

    //HUD
    AmmoShellTexture=Texture'DH_InterfaceArt_tex.Tank_Hud.2341Mag'
    AmmoShellReloadTexture=Texture'DH_InterfaceArt_tex.Tank_Hud.2341Mag_reload'
}

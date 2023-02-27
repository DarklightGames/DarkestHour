//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_JagdpanzerIVL48CannonPawn extends DHAssaultGunCannonPawn;

defaultproperties
{
    GunClass=class'DH_Vehicles.DH_JagdpanzerIVL48Cannon'
    DriverPositions(0)=(ViewLocation=(X=-20.0,Y=-30.0,Z=25.0),ViewFOV=17.0,PositionMesh=SkeletalMesh'DH_Jagdpanzer4_anm.jagdpanzer4L48_turret_int',TransitionUpAnim="Overlay_In",ViewPitchUpLimit=2731,ViewPitchDownLimit=64653,ViewPositiveYawLimit=1820,ViewNegativeYawLimit=-1820,bDrawOverlays=true)
    DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_Jagdpanzer4_anm.jagdpanzer4L48_turret_int',TransitionUpAnim="com_open",ViewPitchUpLimit=0,ViewPitchDownLimit=65536,ViewPositiveYawLimit=65535,ViewNegativeYawLimit=-65535,bDrawOverlays=true)
    DriverPositions(2)=(PositionMesh=SkeletalMesh'DH_Jagdpanzer4_anm.jagdpanzer4L48_turret_int',TransitionDownAnim="com_close",DriverTransitionAnim="stand_idlehip_binoc",ViewPitchUpLimit=10000,ViewPitchDownLimit=64500,ViewPositiveYawLimit=65535,ViewNegativeYawLimit=-65535,bExposed=true)
    DriverPositions(3)=(ViewFOV=12.0,PositionMesh=SkeletalMesh'DH_Jagdpanzer4_anm.jagdpanzer4L48_turret_int',DriverTransitionAnim="stand_idleiron_binoc",ViewPitchUpLimit=10000,ViewPitchDownLimit=64500,ViewPositiveYawLimit=65535,ViewNegativeYawLimit=-65535,bDrawOverlays=true,bExposed=true)
    PeriscopePositionIndex=1
    DrivePos=(X=5.0,Y=2.5,Z=-22.5)
    DriveAnim="stand_idlehip_binoc"
    bHasAltFire=false
    CameraBone="Turret"
    GunsightOverlay=Texture'DH_VehicleOptics_tex.German.stug3_SflZF1a_sight'
    GunsightSize=0.471 // 8 degrees visible FOV at 5x magnification (Sfl.ZF1a sight)
    PeriscopeOverlay=Texture'DH_VehicleOptics_tex.General.PERISCOPE_overlay_German'
    AmmoShellTexture=Texture'InterfaceArt_tex.Tank_Hud.panzer4F2shell'
    AmmoShellReloadTexture=Texture'InterfaceArt_tex.Tank_Hud.panzer4F2shell_reload'
}

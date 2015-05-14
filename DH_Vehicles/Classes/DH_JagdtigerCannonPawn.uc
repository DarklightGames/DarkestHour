//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_JagdtigerCannonPawn extends DHAssaultGunCannonPawn;

defaultproperties
{
    OverlayCenterSize=0.83333
    UnbuttonedPositionIndex=1
    bManualTraverseOnly=true
    ManualRotateSound=sound'Vehicle_Weapons.Turret.manual_gun_traverse'
    ManualRotateAndPitchSound=sound'Vehicle_Weapons.Turret.manual_gun_traverse'
    CannonScopeOverlay=texture'DH_Artillery_Tex.ATGun_Hud.ZF_II_3x8_Pak'
    DestroyedScopeOverlay=texture'DH_VehicleOpticsDestroyed_tex.German.stug3_SflZF1a_destroyed'
    bLockCameraDuringTransition=true
    BinocPositionIndex=2
    WeaponFOV=12.0
    AmmoShellTexture=texture'DH_InterfaceArt_tex.Tank_Hud.JagdTiger_shell'
    AmmoShellReloadTexture=texture'DH_InterfaceArt_tex.Tank_Hud.JagdTiger_shell_reload'
    DriverPositions(0)=(ViewLocation=(X=25.0,Y=-25.0,Z=5.0),ViewFOV=12.0,PositionMesh=SkeletalMesh'DH_Jagdtiger_anm.jagdtiger_turret_ext',TransitionUpAnim="com_open",DriverTransitionAnim="VPanzer4_driver_close",ViewPitchUpLimit=2731,ViewPitchDownLimit=64171,ViewPositiveYawLimit=2000,ViewNegativeYawLimit=-2000,bDrawOverlays=true)
    DriverPositions(1)=(ViewFOV=90.0,PositionMesh=SkeletalMesh'DH_Jagdtiger_anm.jagdtiger_turret_ext',TransitionDownAnim="com_close",DriverTransitionAnim="VPanzer4_driver_open",ViewPitchUpLimit=6000,ViewPitchDownLimit=65000,ViewPositiveYawLimit=100000,ViewNegativeYawLimit=-100000,bExposed=true)
    DriverPositions(2)=(ViewFOV=12.0,PositionMesh=SkeletalMesh'DH_Jagdtiger_anm.jagdtiger_turret_ext',ViewPitchUpLimit=6000,ViewPitchDownLimit=65000,ViewPositiveYawLimit=100000,ViewNegativeYawLimit=-100000,bDrawOverlays=true,bExposed=true)
    FireImpulse=(X=-110000.0)
    GunClass=class'DH_Vehicles.DH_JagdtigerCannon'
    bHasAltFire=false
    CameraBone="Turret_placement1"
    ManualMinRotateThreshold=0.5
    ManualMaxRotateThreshold=3.0
    DrivePos=(Z=-6.0)
    DriveAnim="VPanzer4_driver_idle_close"
    EntryRadius=130.0
    PitchUpLimit=6000
    PitchDownLimit=64000
    SoundVolume=130
}

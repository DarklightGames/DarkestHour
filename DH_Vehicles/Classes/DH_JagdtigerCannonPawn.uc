//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_JagdtigerCannonPawn extends DH_AssaultGunCannonPawn;

defaultproperties
{
    OverlayCenterSize=0.833330
    UnbuttonedPositionIndex=1
    DestroyedScopeOverlay=Texture'DH_VehicleOpticsDestroyed_tex.German.stug3_SflZF1a_destroyed'
    bManualTraverseOnly=true
    PoweredRotateSound=Sound'Vehicle_Weapons.Turret.manual_turret_traverse2'
    PoweredPitchSound=Sound'Vehicle_Weapons.Turret.manual_turret_traverse2'
    PoweredRotateAndPitchSound=Sound'Vehicle_Weapons.Turret.manual_turret_traverse2'
    CannonScopeOverlay=Texture'DH_Artillery_Tex.ATGun_Hud.ZF_II_3x8_Pak'
    bLockCameraDuringTransition=true
    BinocPositionIndex=2
    WeaponFov=12.000000
    AmmoShellTexture=Texture'DH_InterfaceArt_tex.Tank_Hud.JagdTiger_shell'
    AmmoShellReloadTexture=Texture'DH_InterfaceArt_tex.Tank_Hud.JagdTiger_shell_reload'
    DriverPositions(0)=(ViewLocation=(X=25.000000,Y=-25.000000,Z=5.000000),ViewFOV=12.000000,PositionMesh=SkeletalMesh'DH_Jagdtiger_anm.jagdtiger_turret_ext',TransitionUpAnim="com_open",DriverTransitionAnim="VPanzer4_driver_close",ViewPitchUpLimit=2731,ViewPitchDownLimit=64171,ViewPositiveYawLimit=2000,ViewNegativeYawLimit=-2000,bDrawOverlays=true)
    DriverPositions(1)=(ViewFOV=90.000000,PositionMesh=SkeletalMesh'DH_Jagdtiger_anm.jagdtiger_turret_ext',TransitionDownAnim="com_close",DriverTransitionAnim="VPanzer4_driver_open",ViewPitchUpLimit=6000,ViewPitchDownLimit=65000,ViewPositiveYawLimit=100000,ViewNegativeYawLimit=-100000,bExposed=true)
    DriverPositions(2)=(ViewFOV=12.000000,PositionMesh=SkeletalMesh'DH_Jagdtiger_anm.jagdtiger_turret_ext',ViewPitchUpLimit=6000,ViewPitchDownLimit=65000,ViewPositiveYawLimit=100000,ViewNegativeYawLimit=-100000,bDrawOverlays=true,bExposed=true)
    FireImpulse=(X=-110000.000000)
    GunClass=class'DH_Vehicles.DH_JagdtigerCannon'
    CameraBone="Turret_placement1"
    MinRotateThreshold=0.500000
    MaxRotateThreshold=3.000000
    bPCRelativeFPRotation=true
    bFPNoZFromCameraPitch=true
    DrivePos=(Z=-6.000000)
    DriveAnim="VPanzer4_driver_idle_close"
    EntryRadius=130.000000
    TPCamDistance=300.000000
    TPCamLookat=(X=-25.000000,Z=0.000000)
    TPCamWorldOffset=(Z=120.000000)
    VehiclePositionString="in a Jagdpanzer VI Ausf.B cannon"
    VehicleNameString="in a Jagdpanzer VI Ausf.B Cannon"
    PitchUpLimit=6000
    PitchDownLimit=64000
    SoundVolume=130
}

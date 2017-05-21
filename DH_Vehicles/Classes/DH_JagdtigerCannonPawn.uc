//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DH_JagdtigerCannonPawn extends DHAssaultGunCannonPawn;

defaultproperties
{
    GunClass=class'DH_Vehicles.DH_JagdtigerCannon'
    DriverPositions(0)=(ViewLocation=(X=25.0,Y=-25.0,Z=5.0),ViewFOV=12.0,PositionMesh=SkeletalMesh'DH_Jagdtiger_anm.jagdtiger_turret_ext',TransitionUpAnim="com_open",ViewPitchUpLimit=2731,ViewPitchDownLimit=64171,ViewPositiveYawLimit=2000,ViewNegativeYawLimit=-2000,bDrawOverlays=true)
    DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_Jagdtiger_anm.jagdtiger_turret_ext',TransitionDownAnim="com_close",DriverTransitionAnim="stand_idlehip_binoc",ViewPitchUpLimit=6000,ViewPitchDownLimit=65000,ViewPositiveYawLimit=100000,ViewNegativeYawLimit=-100000,bExposed=true)
    DriverPositions(2)=(ViewFOV=12.0,PositionMesh=SkeletalMesh'DH_Jagdtiger_anm.jagdtiger_turret_ext',DriverTransitionAnim="stand_idleiron_binoc",ViewPitchUpLimit=6000,ViewPitchDownLimit=65000,ViewPositiveYawLimit=100000,ViewNegativeYawLimit=-100000,bDrawOverlays=true,bExposed=true)
    UnbuttonedPositionIndex=1
    BinocPositionIndex=2
    bLockCameraDuringTransition=true
    DrivePos=(X=2.0,Y=6.0,Z=-3.0)
    DriveAnim="stand_idlehip_binoc"
    bHasAltFire=false
    GunsightOverlay=texture'DH_Artillery_Tex.ATGun_Hud.ZF_II_3x8_Pak'
    GunsightSize=0.83333
    RangePositionX=0.02
    AmmoShellTexture=texture'DH_InterfaceArt_tex.Tank_Hud.JagdTiger_shell'
    AmmoShellReloadTexture=texture'DH_InterfaceArt_tex.Tank_Hud.JagdTiger_shell_reload'
    FireImpulse=(X=-110000.0)
}

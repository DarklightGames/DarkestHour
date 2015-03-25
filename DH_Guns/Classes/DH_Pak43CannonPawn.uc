//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_Pak43CannonPawn extends DH_ATGunTwoCannonPawn;

defaultproperties
{
    bShowRangeText=true
    OverlayCenterSize=0.57
    CannonScopeOverlay=texture'DH_Artillery_Tex.ATGun_Hud.ZF_II_3x8_Pak'
    BinocPositionIndex=2
    WeaponFov=24.0
    AmmoShellTexture=texture'DH_InterfaceArt_tex.Tank_Hud.KingTigerShell'
    AmmoShellReloadTexture=texture'DH_InterfaceArt_tex.Tank_Hud.KingTigerShell_reload'
    DriverPositions(0)=(ViewLocation=(X=50.0,Y=-24.0,Z=8.0),ViewFOV=24.0,PositionMesh=SkeletalMesh'DH_Pak43_anm.pak43_turret',TransitionUpAnim="com_open",DriverTransitionAnim="crouch_idlehold_bayo",ViewPitchUpLimit=6918,ViewPitchDownLimit=64626,ViewPositiveYawLimit=6000,ViewNegativeYawLimit=-6000,bDrawOverlays=true,bExposed=true)
    DriverPositions(1)=(ViewFOV=90.0,PositionMesh=SkeletalMesh'DH_Pak43_anm.pak43_turret',TransitionDownAnim="com_close",DriverTransitionAnim="stand_idlehip_binoc",ViewPitchUpLimit=5000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=20000,ViewNegativeYawLimit=-20000,bExposed=true)
    DriverPositions(2)=(ViewFOV=12.0,PositionMesh=SkeletalMesh'DH_Pak43_anm.pak43_turret',DriverTransitionAnim="stand_idleiron_binoc",ViewPitchUpLimit=5000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=20000,ViewNegativeYawLimit=-20000,bDrawOverlays=true,bExposed=true)
    GunClass=class'DH_Guns.DH_Pak43Cannon'
    CameraBone="Gun"
    bFPNoZFromCameraPitch=true
    DrivePos=(Y=-5.0,Z=-85.0)
    DriveAnim="crouch_idlehold_bayo"
    EntryRadius=200.0
    bKeepDriverAuxCollision=true
    SoundVolume=130
}

//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_Pak43CannonPawn extends DH_ATGunTwoCannonPawn;

defaultproperties
{
    OverlayCenterSize=0.570000
    CannonScopeOverlay=texture'DH_Artillery_Tex.ATGun_Hud.ZF_II_3x8_Pak'
    BinocPositionIndex=2
    WeaponFov=24.000000
    AmmoShellTexture=texture'DH_InterfaceArt_tex.Tank_Hud.KingTigerShell'
    AmmoShellReloadTexture=texture'DH_InterfaceArt_tex.Tank_Hud.KingTigerShell_reload'
    DriverPositions(0)=(ViewLocation=(X=50.000000,Y=-24.000000,Z=8.000000),ViewFOV=24.000000,PositionMesh=SkeletalMesh'DH_Pak43_anm.pak43_turret',TransitionUpAnim="com_open",DriverTransitionAnim="crouch_idlehold_bayo",ViewPitchUpLimit=6918,ViewPitchDownLimit=64626,ViewPositiveYawLimit=6000,ViewNegativeYawLimit=-6000,bDrawOverlays=true,bExposed=true)
    DriverPositions(1)=(ViewFOV=90.000000,PositionMesh=SkeletalMesh'DH_Pak43_anm.pak43_turret',TransitionDownAnim="com_close",DriverTransitionAnim="stand_idlehip_binoc",ViewPitchUpLimit=5000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=20000,ViewNegativeYawLimit=-20000,bExposed=true)
    DriverPositions(2)=(ViewFOV=12.000000,PositionMesh=SkeletalMesh'DH_Pak43_anm.pak43_turret',DriverTransitionAnim="stand_idleiron_binoc",ViewPitchUpLimit=5000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=20000,ViewNegativeYawLimit=-20000,bDrawOverlays=true,bExposed=true)
    GunClass=class'DH_Guns.DH_Pak43Cannon'
    CameraBone="Gun"
    RotateSound=sound'Vehicle_Weapons.Turret.manual_gun_traverse'
    PitchSound=sound'Vehicle_Weapons.Turret.manual_turret_elevate'
    RotateAndPitchSound=sound'Vehicle_Weapons.Turret.manual_gun_traverse'
    bFPNoZFromCameraPitch=true
    DrivePos=(Y=-5.000000,Z=-85.000000)
    DriveAnim="crouch_idlehold_bayo"
    EntryRadius=200.000000
    VehicleNameString="Pak43/41 AT-Gun"
    bKeepDriverAuxCollision=true
    SoundVolume=130
}

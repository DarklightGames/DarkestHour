//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_Pak43CannonPawn extends DHATGunCannonPawn;

defaultproperties
{
    GunClass=class'DH_Guns.DH_Pak43Cannon'
    DriverPositions(0)=(ViewLocation=(X=50.0,Y=-24.0,Z=8.0),ViewFOV=28.33,PositionMesh=SkeletalMesh'DH_Pak43_anm.pak43_turret',TransitionUpAnim="com_open",DriverTransitionAnim="crouch_idlehold_bayo",ViewPitchUpLimit=6918,ViewPitchDownLimit=64626,ViewPositiveYawLimit=6000,ViewNegativeYawLimit=-6000,bDrawOverlays=true,bExposed=true)
    DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_Pak43_anm.pak43_turret',TransitionDownAnim="com_close",DriverTransitionAnim="stand_idlehip_binoc",ViewPitchUpLimit=5000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=20000,ViewNegativeYawLimit=-20000,bExposed=true)
    DriverPositions(2)=(ViewFOV=12.0,PositionMesh=SkeletalMesh'DH_Pak43_anm.pak43_turret',DriverTransitionAnim="stand_idleiron_binoc",ViewPitchUpLimit=5000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=20000,ViewNegativeYawLimit=-20000,bDrawOverlays=true,bExposed=true)
    DrivePos=(X=-33.0,Y=2.0,Z=-87.0)
    DriveAnim="crouch_idlehold_bayo"
    GunsightOverlay=Texture'DH_VehicleOptics_tex.German.ZF_II_3x8_Pak'
    GunsightSize=0.282 // 8 degrees visible FOV at 3x magnification (ZF 3x8 Pak sight)
    AmmoShellTexture=Texture'DH_InterfaceArt_tex.Tank_Hud.KingTigerShell'
    AmmoShellReloadTexture=Texture'DH_InterfaceArt_tex.Tank_Hud.KingTigerShell_reload'
}

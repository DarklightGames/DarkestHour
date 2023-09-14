//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_17PounderGunCannonPawn extends DHATGunCannonPawn;

defaultproperties
{
    GunClass=class'DH_Guns.DH_17PounderGunCannon'
    DriverPositions(0)=(ViewLocation=(X=40.0,Y=-17.0,Z=22.0),ViewFOV=28.33,PositionMesh=SkeletalMesh'DH_17PounderGun_anm.17Pounder_turret',TransitionUpAnim="com_open",DriverTransitionAnim="crouch_idlehold_bayo",ViewPitchUpLimit=3004,ViewPitchDownLimit=64444,ViewPositiveYawLimit=5460,ViewNegativeYawLimit=-5460,bDrawOverlays=true,bExposed=true)
    DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_17PounderGun_anm.17Pounder_turret',TransitionDownAnim="com_close",DriverTransitionAnim="stand_idlehip_binoc",ViewPitchUpLimit=5000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=20000,ViewNegativeYawLimit=-20000,bExposed=true)
    DriverPositions(2)=(ViewFOV=12.0,PositionMesh=SkeletalMesh'DH_17PounderGun_anm.17Pounder_turret',DriverTransitionAnim="stand_idleiron_binoc",ViewPitchUpLimit=5000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=20000,ViewNegativeYawLimit=-20000,bDrawOverlays=true,bExposed=true)
    DrivePos=(X=-40.0,Y=-4.0,Z=-42.0)
    DriveAnim="crouch_idlehold_bayo"
    CameraBone="gun01"
    GunsightOverlay=Texture'DH_VehicleOptics_tex.British.17Pdr_sight_background'
    CannonScopeCenter=Texture'DH_VehicleOptics_tex.British.17Pdr_sight_mover'
    GunsightSize=0.459 // 13 degrees visible FOV at 3x magnification (No.51 sight)
    RangeText="Yards"
    AmmoShellTexture=Texture'InterfaceArt_tex.Tank_Hud.T3485shell'
    AmmoShellReloadTexture=Texture'InterfaceArt_tex.Tank_Hud.T3485shell_reload'
}

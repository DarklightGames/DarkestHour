//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DH_17PounderGunCannonPawn extends DHATGunCannonPawn;

defaultproperties
{
    GunClass=class'DH_Guns.DH_17PounderGunCannon'
    DriverPositions(0)=(ViewLocation=(X=40.0,Y=-17.0,Z=22.0),ViewFOV=24.0,PositionMesh=SkeletalMesh'DH_17PounderGun_anm.17Pounder_turret',TransitionUpAnim="com_open",DriverTransitionAnim="crouch_idlehold_bayo",ViewPitchUpLimit=3004,ViewPitchDownLimit=64444,ViewPositiveYawLimit=5460,ViewNegativeYawLimit=-5460,bDrawOverlays=true,bExposed=true)
    DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_17PounderGun_anm.17Pounder_turret',TransitionDownAnim="com_close",DriverTransitionAnim="stand_idlehip_binoc",ViewPitchUpLimit=5000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=20000,ViewNegativeYawLimit=-20000,bExposed=true)
    DriverPositions(2)=(ViewFOV=12.0,PositionMesh=SkeletalMesh'DH_17PounderGun_anm.17Pounder_turret',DriverTransitionAnim="stand_idleiron_binoc",ViewPitchUpLimit=5000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=20000,ViewNegativeYawLimit=-20000,bDrawOverlays=true,bExposed=true)
    DrivePos=(X=-40.0,Y=-4.0,Z=-42.0)
    DriveAnim="crouch_idlehold_bayo"
    CameraBone="gun01"
    GunsightOverlay=texture'DH_VehicleOptics_tex.Artillery.17Pdr_sight_background'
    CannonScopeCenter=texture'DH_VehicleOptics_tex.Artillery.17pdr_sight_mover'
    GunsightSize=0.542
    RangeText="Yards"
    BinocsOverlay=texture'DH_VehicleOptics_tex.Allied.BINOC_overlay_7x50Allied'
    AmmoShellTexture=texture'InterfaceArt_tex.Tank_Hud.T3485shell'
    AmmoShellReloadTexture=texture'InterfaceArt_tex.Tank_Hud.T3485shell_reload'
}

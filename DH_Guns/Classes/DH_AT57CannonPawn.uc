//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_AT57CannonPawn extends DHATGunCannonPawn;

defaultproperties
{
    GunClass=class'DH_Guns.DH_AT57Cannon'
    DriverPositions(0)=(ViewLocation=(X=20.0,Y=-12.0,Z=10.0),ViewFOV=24.0,PositionMesh=SkeletalMesh'DH_6PounderGun_anm.6pounder_turret',TransitionUpAnim="com_open",DriverTransitionAnim="crouch_idle_binoc",ViewPitchUpLimit=2731,ViewPitchDownLimit=64626,ViewPositiveYawLimit=6000,ViewNegativeYawLimit=-6000,bDrawOverlays=true,bExposed=true)
    DriverPositions(1)=(ViewFOV=90.0,PositionMesh=SkeletalMesh'DH_6PounderGun_anm.6pounder_turret',TransitionDownAnim="com_close",DriverTransitionAnim="stand_idlehip_binoc",ViewPitchUpLimit=6000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=20000,ViewNegativeYawLimit=-20000,bExposed=true)
    DriverPositions(2)=(ViewFOV=12.0,PositionMesh=SkeletalMesh'DH_6PounderGun_anm.6pounder_turret',DriverTransitionAnim="stand_idleiron_binoc",ViewPitchUpLimit=6000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=20000,ViewNegativeYawLimit=-20000,bDrawOverlays=true,bExposed=true)
    DrivePos=(X=-25.0,Y=7.0,Z=-27.0)
    DriveAnim="crouch_idle_binoc"
    CannonScopeOverlay=texture'DH_Artillery_Tex.ATGun_Hud.57mmGun_sight_background'
    OverlayCenterSize=0.542
    BinocsOverlay=texture'DH_VehicleOptics_tex.Allied.BINOC_overlay_7x50Allied'
    AmmoShellTexture=texture'InterfaceArt_tex.Tank_Hud.Panzer3shell'
    AmmoShellReloadTexture=texture'InterfaceArt_tex.Tank_Hud.Panzer3shell_reload'
}

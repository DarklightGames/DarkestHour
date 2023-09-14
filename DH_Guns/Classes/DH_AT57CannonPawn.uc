//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_AT57CannonPawn extends DHATGunCannonPawn;

defaultproperties
{
    GunClass=class'DH_Guns.DH_AT57Cannon'
    DriverPositions(0)=(ViewLocation=(X=20.0,Y=-12.0,Z=10.0),ViewFOV=28.33,PositionMesh=SkeletalMesh'DH_6PounderGun_anm.6pounder_turret',TransitionUpAnim="com_open",DriverTransitionAnim="crouch_idle_binoc",ViewPitchUpLimit=2731,ViewPitchDownLimit=64626,ViewPositiveYawLimit=6000,ViewNegativeYawLimit=-6000,bDrawOverlays=true,bExposed=true)
    DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_6PounderGun_anm.6pounder_turret',TransitionDownAnim="com_close",DriverTransitionAnim="stand_idlehip_binoc",ViewPitchUpLimit=6000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=20000,ViewNegativeYawLimit=-20000,bExposed=true)
    DriverPositions(2)=(ViewFOV=12.0,PositionMesh=SkeletalMesh'DH_6PounderGun_anm.6pounder_turret',DriverTransitionAnim="stand_idleiron_binoc",ViewPitchUpLimit=6000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=20000,ViewNegativeYawLimit=-20000,bDrawOverlays=true,bExposed=true)
    DrivePos=(X=-25.0,Y=7.0,Z=-27.0)
    DriveAnim="crouch_idle_binoc"
    GunsightOverlay=Texture'DH_VehicleOptics_tex.US.57mmGun_sight_background'
    GunsightSize=0.369 // 10 degrees 27 minutes visible FOV at 3x magnification (M69C telescope)
    AmmoShellTexture=Texture'InterfaceArt_tex.Tank_Hud.Panzer3shell'
    AmmoShellReloadTexture=Texture'InterfaceArt_tex.Tank_Hud.Panzer3shell_reload'
}

//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_T3476CannonPawn extends DHSovietCannonPawn;

exec function GSD() // TEMP TEST to zero in sights
{
    DHVehicleCannon(Gun).bGunsightSettingMode = !DHVehicleCannon(Gun).bGunsightSettingMode;
    log(name @ "bGunsightSettingMode =" @ DHVehicleCannon(Gun).bGunsightSettingMode);
}

defaultproperties
{
    GunClass=class'DH_Vehicles.DH_T3476Cannon' // TODO: Pos0 FOV was 34 in RO - need to change?
    DriverPositions(0)=(ViewLocation=(X=115.0,Y=-15.0,Z=0.0),ViewFOV=29.0,PositionMesh=SkeletalMesh'DH_T34_anm.T34-76_turret_int',TransitionUpAnim="com_open",DriverTransitionAnim="VT3476_com_close",ViewPitchUpLimit=6000,ViewPitchDownLimit=64500,ViewPositiveYawLimit=19000,ViewNegativeYawLimit=-20000,bDrawOverlays=true)
    DriverPositions(1)=(ViewFOV=90.0,PositionMesh=SkeletalMesh'DH_T34_anm.T34-76_turret_int',TransitionDownAnim="com_close",DriverTransitionAnim="VT3476_com_open",ViewPitchUpLimit=5000,ViewPitchDownLimit=62000,ViewPositiveYawLimit=6000,ViewNegativeYawLimit=-10000,bExposed=true)
    DriverPositions(2)=(ViewFOV=12.0,PositionMesh=SkeletalMesh'DH_T34_anm.T34-76_turret_int',DriverTransitionAnim="stand_idleiron_binoc",ViewPitchUpLimit=5000,ViewPitchDownLimit=62000,ViewPositiveYawLimit=6000,ViewNegativeYawLimit=-10000,bDrawOverlays=true,bExposed=true)
    UnbuttonedPositionIndex=1
    BinocPositionIndex=2
    DriveAnim="VT3476_com_idle_close"
    bLockCameraDuringTransition=true
    GunsightOverlay=texture'Vehicle_Optic.T3476_sight_background'
    CannonScopeCenter=texture'Vehicle_Optic.T3476_sight_mover'
    DestroyedGunsightOverlay=texture'DH_VehicleOpticsDestroyed_tex.Allied.Sherman_sight_destroyed' // TODO: use/make one for T34/Soviet
    AmmoShellTexture=texture'InterfaceArt_tex.Tank_Hud.T3476_SU76_Kv1shell'
    AmmoShellReloadTexture=texture'InterfaceArt_tex.Tank_Hud.T3476_SU76_Kv1shell_reload'
    PoweredRotateSound=sound'Vehicle_Weapons.Turret.hydraul_turret_traverse'
    PoweredPitchSound=sound'Vehicle_Weapons.Turret.manual_turret_elevate'
    PoweredRotateAndPitchSound=sound'Vehicle_Weapons.Turret.hydraul_turret_traverse'
}

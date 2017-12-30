//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DH_T3476CannonPawn extends DHSovietCannonPawn;

defaultproperties
{
    GunClass=class'DH_Vehicles.DH_T3476Cannon'
    DriverPositions(0)=(ViewLocation=(X=115.0,Y=-15.0,Z=0.0),ViewFOV=34.0,PositionMesh=SkeletalMesh'DH_T34_anm.T34-76_turret_int',TransitionUpAnim="com_open",DriverTransitionAnim="VT3476_com_close",bDrawOverlays=true)
    DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_T34_anm.T34-76_turret_int',TransitionDownAnim="com_close",DriverTransitionAnim="VT3476_com_open",ViewPitchUpLimit=5000,ViewPitchDownLimit=62000,ViewPositiveYawLimit=6000,ViewNegativeYawLimit=-10000,bExposed=true)
    DriverPositions(2)=(ViewFOV=12.0,PositionMesh=SkeletalMesh'DH_T34_anm.T34-76_turret_int',DriverTransitionAnim="stand_idleiron_binoc",ViewPitchUpLimit=5000,ViewPitchDownLimit=62000,ViewPositiveYawLimit=6000,ViewNegativeYawLimit=-10000,bDrawOverlays=true,bExposed=true)
    UnbuttonedPositionIndex=1
    BinocPositionIndex=2
    DriveAnim="VT3476_com_idle_close"
    bLockCameraDuringTransition=true // just stops player being able to turn & see through incomplete turret interior when buttoning or unbuttoning
    CannonScopeCenter=Texture'Vehicle_Optic.T3476_sight_mover'
    GunsightSize=0.4412 // 15 degrees visible FOV at 2.5x magnification (TMFD-7 telescopic gunsight)
    DestroyedGunsightOverlay=Texture'DH_VehicleOpticsDestroyed_tex.German.PZ4_sight_destroyed' // matches size of gunsight
    AmmoShellTexture=Texture'InterfaceArt_tex.Tank_Hud.T3476_SU76_Kv1shell'
    AmmoShellReloadTexture=Texture'InterfaceArt_tex.Tank_Hud.T3476_SU76_Kv1shell_reload'
    PoweredRotateSound=Sound'Vehicle_Weapons.Turret.hydraul_turret_traverse'
    PoweredPitchSound=Sound'Vehicle_Weapons.Turret.manual_turret_elevate'
    PoweredRotateAndPitchSound=Sound'Vehicle_Weapons.Turret.hydraul_turret_traverse'
}

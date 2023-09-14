//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_T3476CannonPawn extends DHSovietCannonPawn;

defaultproperties
{
    GunClass=class'DH_Vehicles.DH_T3476Cannon'
    DriverPositions(0)=(ViewLocation=(X=115.0,Y=-15.0,Z=0.0),ViewFOV=34.0,PositionMesh=SkeletalMesh'DH_T34_anm.T34-76_turret_int',bDrawOverlays=true)
    DriverPositions(1)=(ViewLocation=(X=35,Y=-5.0,Z=20.0),ViewFOV=34.0,PositionMesh=SkeletalMesh'DH_T34_anm.T34-76_turret_int',DriverTransitionAnim="VT3476_com_idle_close",TransitionUpAnim="com_open",DriverTransitionAnim="VT3476_com_close",ViewPitchUpLimit=1,ViewPitchDownLimit=65535,ViewPositiveYawLimit=65536,ViewNegativeYawLimit=-65536,bDrawOverlays=true)
    //
    DriverPositions(2)=(PositionMesh=SkeletalMesh'DH_T34_anm.T34-76_turret_int',TransitionDownAnim="com_close",DriverTransitionAnim="VT3476_com_open",ViewPitchUpLimit=5000,ViewPitchDownLimit=62000,ViewPositiveYawLimit=6000,ViewNegativeYawLimit=-10000,bExposed=true)
    DriverPositions(3)=(ViewFOV=12.0,PositionMesh=SkeletalMesh'DH_T34_anm.T34-76_turret_int',DriverTransitionAnim="stand_idleiron_binoc",ViewPitchUpLimit=5000,ViewPitchDownLimit=62000,ViewPositiveYawLimit=6000,ViewNegativeYawLimit=-10000,bDrawOverlays=true,bExposed=true)

    PeriscopePositionIndex=1
    UnbuttonedPositionIndex=2
    BinocPositionIndex=3

    PeriscopeOverlay=Texture'DH_VehicleOptics_tex.General.MG_sight' //emulating the PT4-7 periscope 2.5x 26' FOV
    PeriscopeSize=0.76

    DriveAnim="VT3476_com_idle_close"
    bLockCameraDuringTransition=true // just stops player being able to turn & see through incomplete turret interior when buttoning or unbuttoning
    GunsightOverlay=Texture'DH_VehicleOptics_tex.Soviet.T3476_sight_background' // edited RO sight to make edges solid black to avoid graphical smears on sides of sight
    CannonScopeCenter=Texture'Vehicle_Optic.T3476_sight_mover'
    GunsightSize=0.441 // 15 degrees visible FOV at 2.5x magnification (TMFD-7 sight)
    DestroyedGunsightOverlay=Texture'DH_VehicleOpticsDestroyed_tex.German.PZ4_sight_destroyed' // matches size of gunsight
    AmmoShellTexture=Texture'InterfaceArt_tex.Tank_Hud.T3476_SU76_Kv1shell'
    AmmoShellReloadTexture=Texture'InterfaceArt_tex.Tank_Hud.T3476_SU76_Kv1shell_reload'
    PoweredRotateSound=Sound'Vehicle_Weapons.Turret.hydraul_turret_traverse'
    PoweredPitchSound=Sound'Vehicle_Weapons.Turret.manual_turret_elevate'
    PoweredRotateAndPitchSound=Sound'Vehicle_Weapons.Turret.hydraul_turret_traverse'
}

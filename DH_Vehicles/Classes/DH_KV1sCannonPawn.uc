//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_KV1sCannonPawn extends DHSovietCannonPawn;

defaultproperties
{
    GunClass=class'DH_Vehicles.DH_KV1sCannon'
    DriverPositions(0)=(ViewLocation=(X=24.0,Y=-13.0,Z=0.0),ViewFOV=34.0,PositionMesh=SkeletalMesh'DH_KV_anm.KV1S_turret_int',bDrawOverlays=true)
    DriverPositions(1)=(ViewLocation=(X=49.0,Y=-4.0,Z=5.0),ViewFOV=34.0,PositionMesh=SkeletalMesh'DH_KV_anm.KV1S_turret_ext',ViewPitchUpLimit=1,ViewPitchDownLimit=65535,ViewPositiveYawLimit=65536,ViewNegativeYawLimit=-65536,bDrawOverlays=true)
    //
    DriverPositions(2)=(ViewFOV=75.0,PositionMesh=SkeletalMesh'DH_KV_anm.KV1S_turret_int',TransitionUpAnim="com_open",DriverTransitionAnim="VKV1_com_close",ViewPitchUpLimit=5000,ViewPitchDownLimit=65000,ViewPositiveYawLimit=6000,ViewNegativeYawLimit=-10000)
    DriverPositions(3)=(PositionMesh=SkeletalMesh'DH_KV_anm.KV1S_turret_int',TransitionDownAnim="com_close",DriverTransitionAnim="VKV1_com_open",ViewPitchUpLimit=5000,ViewPitchDownLimit=62000,ViewPositiveYawLimit=6000,ViewNegativeYawLimit=-10000,bExposed=true)
    DriverPositions(4)=(ViewFOV=12.0,PositionMesh=SkeletalMesh'DH_KV_anm.KV1S_turret_int',DriverTransitionAnim="stand_idleiron_binoc",ViewPitchUpLimit=5000,ViewPitchDownLimit=62000,ViewPositiveYawLimit=6000,ViewNegativeYawLimit=-10000,bDrawOverlays=true,bExposed=true)

    PeriscopePositionIndex=1
    UnbuttonedPositionIndex=3
    BinocPositionIndex=4

    PeriscopeOverlay=Texture'DH_VehicleOptics_tex.General.MG_sight' //emulating the PT4-7 periscope 2.5x 26' FOV
    PeriscopeSize=0.76

    DriveAnim="VKV1_com_idle_close"
    bLockCameraDuringTransition=true
    GunsightOverlay=Texture'DH_VehicleOptics_tex.Soviet.T3476_sight_background' // using same sight as T34/76 instead of RO's different KV-1 sight
    CannonScopeCenter=Texture'Vehicle_Optic.T3476_sight_mover'
    GunsightSize=0.441 // 15 degrees visible FOV at 2.5x magnification (9T-13, 10T-13 or 20T-13 sight)
    DestroyedGunsightOverlay=Texture'DH_VehicleOpticsDestroyed_tex.German.PZ4_sight_destroyed' // matches size of gunsight

    AmmoShellTexture=Texture'InterfaceArt_tex.Tank_Hud.T3476_SU76_Kv1shell'
    AmmoShellReloadTexture=Texture'InterfaceArt_tex.Tank_Hud.T3476_SU76_Kv1shell_reload'
    PoweredRotateSound=Sound'Vehicle_Weapons.Turret.hydraul_turret_traverse'
    PoweredPitchSound=Sound'Vehicle_Weapons.Turret.manual_turret_elevate'
    PoweredRotateAndPitchSound=Sound'Vehicle_Weapons.Turret.hydraul_turret_traverse'
}

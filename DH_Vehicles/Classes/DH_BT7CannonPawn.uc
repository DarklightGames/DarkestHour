//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_BT7CannonPawn extends DHSovietCannonPawn;

defaultproperties
{
    GunClass=class'DH_Vehicles.DH_BT7Cannon'
    DriverPositions(0)=(ViewLocation=(X=0.0,Y=-7.0,Z=4.0),ViewFOV=29.0,PositionMesh=SkeletalMesh'allies_ahz_bt7_anm.BT7_turret_int',TransitionUpAnim="com_open",DriverTransitionAnim="VPanzer4_com_close",ViewPitchUpLimit=6000,ViewPitchDownLimit=64500,ViewPositiveYawLimit=19000,ViewNegativeYawLimit=-20000)
    DriverPositions(1)=(ViewFOV=90.0,PositionMesh=SkeletalMesh'allies_ahz_bt7_anm.BT7_turret_int',TransitionDownAnim="com_close",DriverTransitionAnim="VT3476_com_open",ViewPitchUpLimit=5000,ViewPitchDownLimit=62000,ViewPositiveYawLimit=6000,ViewNegativeYawLimit=-10000,bExposed=true)
    DriverPositions(2)=(ViewFOV=12.0,PositionMesh=SkeletalMesh'allies_ahz_bt7_anm.BT7_turret_int',DriverTransitionAnim="stand_idleiron_binoc",ViewPitchUpLimit=5000,ViewPitchDownLimit=62000,ViewPositiveYawLimit=6000,ViewNegativeYawLimit=-10000,bDrawOverlays=true,bExposed=true)
    UnbuttonedPositionIndex=1
    BinocPositionIndex=2
    DrivePos=(X=8.0,Y=-3.0,Z=-5.0)
    DriveAnim="VPanzer4_com_idle_close"
    bManualTraverseOnly=true
    bHasAltFire=false
    GunsightOverlay=texture'DH_VehicleOptics_tex.Allied.M1937_optics'
    CannonScopeCenter=texture'Vehicle_Optic.T3476_sight_mover'
    OverlayCenterSize=0.6944 // 20deg * 2.5x gives 50 deg apparent FOV,  TMF-1, T-70, 2.5x20 ???
//  DestroyedGunsightOverlay=texture'DH_VehicleOpticsDestroyed_tex. // TODO: add/make one
    AmmoShellTexture=texture'InterfaceArt_ahz_tex.Tank_Hud.45mmShell'
    AmmoShellReloadTexture=texture'InterfaceArt_ahz_tex.Tank_Hud.45mmShell_reload'
    ManualRotateSound=sound'Vehicle_Weapons.Turret.manual_turret_traverse'
    FireImpulse=(X=-50000.0)
}

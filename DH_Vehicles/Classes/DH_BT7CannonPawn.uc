//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DH_BT7CannonPawn extends DHSovietCannonPawn;

defaultproperties
{
    GunClass=class'DH_Vehicles.DH_BT7Cannon'
  	DriverPositions(0)=(ViewLocation=(X=55,Y=-10,Z=1),ViewFOV=34,PositionMesh=Mesh'allies_ahz_bt7_anm.BT7_turret_int',DriverTransitionAnim=VPanzer4_com_close,TransitionUpAnim=com_open,ViewPitchUpLimit=6000,ViewPitchDownLimit=64500,ViewPositiveYawLimit=19000,ViewNegativeYawLimit=-20000,bDrawOverlays=true,bExposed=false)
	DriverPositions(1)=(ViewLocation=(X=0,Y=0,Z=0),ViewFOV=85,PositionMesh=Mesh'allies_ahz_bt7_anm.BT7_turret_int',DriverTransitionAnim=VT3476_com_open,TransitionDownAnim=com_close,ViewPitchUpLimit=5000,ViewPitchDownLimit=62000,ViewPositiveYawLimit=6000,ViewNegativeYawLimit=-10000,bDrawOverlays=false,bExposed=true)
	DriverPositions(2)=(ViewLocation=(X=0,Y=0,Z=0),ViewFOV=20,PositionMesh=Mesh'allies_ahz_bt7_anm.BT7_turret_int',DriverTransitionAnim=none,ViewPitchUpLimit=5000,ViewPitchDownLimit=62000,ViewPositiveYawLimit=6000,ViewNegativeYawLimit=-10000,bDrawOverlays=true,bExposed=true)


    UnbuttonedPositionIndex=1
    BinocPositionIndex=2

    bManualTraverseOnly=true

    DriveAnim=VPanzer4_com_idle_close  
    bLockCameraDuringTransition=true 
    GunsightOverlay=Texture'DH_VehicleOptics_tex.Soviet.45mmATGun_sight_background'
    CannonScopeCenter=Texture'Vehicle_Optic.Scopes.T3476_sight_mover'
    GunsightSize=0.441 // 15 degrees visible FOV at 2.5x magnification (PP-1 sight)
    DestroyedGunsightOverlay=Texture'DH_VehicleOpticsDestroyed_tex.German.PZ4_sight_destroyed'
    AmmoShellTexture=Texture'InterfaceArt_ahz_tex.Tank_Hud.45mmShell' // TODO: get new ammo icons made so the "X" text matches the position of the ammo count
    AmmoShellReloadTexture=Texture'InterfaceArt_ahz_tex.Tank_Hud.45mmShell_reload'
	
    PoweredRotateSound=Sound'Vehicle_Weapons.Turret.hydraul_turret_traverse'
    PoweredPitchSound=Sound'Vehicle_Weapons.Turret.manual_turret_elevate'
    PoweredRotateAndPitchSound=Sound'Vehicle_Weapons.Turret.hydraul_turret_traverse'
}

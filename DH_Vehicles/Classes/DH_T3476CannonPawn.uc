//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_T3476CannonPawn extends DHSovietCannonPawn;

defaultproperties
{
    VehicleNameString="T34/76 Cannon"
    GunClass=class'DH_Vehicles.DH_T3476Cannon'
    DriverPositions(0)=(ViewLocation=(X=20,Y=-11,Z=9),ViewFOV=29,PositionMesh=Mesh'allies_t3476_anm.t3476_turret_int',DriverTransitionAnim=VT3476_com_close,TransitionUpAnim=com_open,ViewPitchUpLimit=6000,ViewPitchDownLimit=64500,ViewPositiveYawLimit=19000,ViewNegativeYawLimit=-20000,bDrawOverlays=true,bExposed=false)
    DriverPositions(1)=(ViewLocation=(X=0,Y=0,Z=0),ViewFOV=80,PositionMesh=Mesh'allies_t3476_anm.t3476_turret_int',DriverTransitionAnim=VT3476_com_open,TransitionDownAnim=com_close,ViewPitchUpLimit=5000,ViewPitchDownLimit=62000,ViewPositiveYawLimit=6000,ViewNegativeYawLimit=-10000,bDrawOverlays=false,bExposed=true)
    DriverPositions(2)=(ViewLocation=(X=0,Y=0,Z=0),ViewFOV=12,PositionMesh=Mesh'allies_t3476_anm.t3476_turret_int',DriverTransitionAnim=none,ViewPitchUpLimit=5000,ViewPitchDownLimit=62000,ViewPositiveYawLimit=6000,ViewNegativeYawLimit=-10000,bDrawOverlays=true,bExposed=true)
    UnbuttonedPositionIndex=1
    RaisedPositionIndex=1
    BinocPositionIndex=2
    DrivePos=(X=0.0,Y=0.0,Z=0.0)
    DriveAnim=VT3476_com_idle_close
    GunsightOverlay=texture'Vehicle_Optic.T3476_sight_background'
    CannonScopeCenter=texture'Vehicle_Optic.T3476_sight_mover'
    OverlayCenterSize=0.52
    DestroyedGunsightOverlay=texture'DH_VehicleOpticsDestroyed_tex.Allied.Sherman_sight_destroyed'
    AmmoShellTexture=texture'InterfaceArt_tex.Tank_Hud.T3476_SU76_Kv1shell'
    AmmoShellReloadTexture=texture'InterfaceArt_tex.Tank_Hud.T3476_SU76_Kv1shell_reload'
    bLockCameraDuringTransition=true
/*
    ExitPositions(0)=(X=135.0,Y=-33.0,Z=176.0)  //driver
    ExitPositions(1)=(X=30.0,Y=-5.0,Z=210.0)    //commander
    ExitPositions(2)=(X=-124.0,Y=-161.0,Z=64.0) //passenger (l)
    ExitPositions(3)=(X=-245.0,Y=-42.0,Z=63.0)  //passenger (rl)
    ExitPositions(4)=(X=-249.0,Y=31.0,Z=63.0)   //passenger (rr)
    ExitPositions(5)=(X=-126.0,Y=169.0,Z=64.0)  //passenger (r)
*/
    ExitPositions(0)=(X=0,Y=-200,Z=100)
    ExitPositions(1)=(X=0,Y=200,Z=100)
    WeaponFov=36
    PitchUpLimit=6000
    PitchDownLimit=64000
    PoweredRotateSound=Sound'Vehicle_Weapons.Turret.hydraul_turret_traverse'
    PoweredPitchSound=Sound'Vehicle_Weapons.Turret.manual_turret_elevate'
    PoweredRotateAndPitchSound=Sound'Vehicle_Weapons.Turret.hydraul_turret_traverse'
    OverlayCorrectionX=1
    OverlayCorrectionY=0
}

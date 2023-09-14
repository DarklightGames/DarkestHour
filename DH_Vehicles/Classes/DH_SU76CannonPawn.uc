//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_SU76CannonPawn extends DHAssaultGunCannonPawn;

//to do: periscope and/or DT machinegun

defaultproperties
{
    GunClass=class'DH_Vehicles.DH_SU76Cannon'
    DriverPositions(0)=(ViewLocation=(X=15,Y=-10.0,Z=15.0),ViewFOV=20.27,PositionMesh=Mesh'DH_SU76_anm.SU76_turret_int',DriverTransitionAnim=none,ViewPitchUpLimit=6000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=3000,ViewNegativeYawLimit=-3000,bDrawOverlays=true,bExposed=true)
    DriverPositions(1)=(ViewLocation=(X=0,Y=0,Z=0),PositionMesh=Mesh'DH_SU76_anm.SU76_turret_int',DriverTransitionAnim=VSU76_com_close,TransitionUpAnim=com_open,ViewPitchUpLimit=5000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=65536,ViewNegativeYawLimit=-65536,bDrawOverlays=false,bExposed=true)
    DriverPositions(2)=(ViewLocation=(X=0,Y=0,Z=0),PositionMesh=Mesh'DH_SU76_anm.SU76_turret_int',DriverTransitionAnim=VSU76_com_open,TransitionDownAnim=com_close,ViewPitchUpLimit=5000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=65536,ViewNegativeYawLimit=-65536,bDrawOverlays=false,bExposed=true)
    DriverPositions(3)=(ViewLocation=(X=0,Y=0,Z=0),ViewFOV=12.5,PositionMesh=Mesh'DH_SU76_anm.SU76_turret_int',DriverTransitionAnim=none,ViewPitchUpLimit=5000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=65536,ViewNegativeYawLimit=-65536,bDrawOverlays=true,bExposed=true)

    AmmoShellTexture=Texture'InterfaceArt_tex.Tank_Hud.T3476_SU76_Kv1shell'

    UnbuttonedPositionIndex=0 // let's commander exit at any position
    RaisedPositionIndex=2
    BinocPositionIndex=3

    bManualTraverseOnly=true

    DriveAnim=VSU76_com_idle_close
    bLockCameraDuringTransition=false

    bHasFireImpulse=True
    FireImpulse=(X=-70000,Y=0.0,Z=0.0)

    bHasAltFire=false

    DestroyedGunsightOverlay=Texture'DH_VehicleOpticsDestroyed_tex.German.PZ4_sight_destroyed' // matches size of gunsight

    AmmoShellReloadTexture=Texture'InterfaceArt_tex.Tank_Hud.T3476_SU76_Kv1shell_reload'
    ManualRotateSound=Sound'Vehicle_Weapons.Turret.manual_gun_traverse'
    ManualRotateAndPitchSound=Sound'Vehicle_Weapons.Turret.manual_gun_traverse'

    GunsightOverlay=Texture'DH_VehicleOptics_tex.Soviet.PG1_sight_background'
    GunsightSize=0.497 // 10°5' degrees visible FOV at 3.7x magnification (PG1 sight)

}

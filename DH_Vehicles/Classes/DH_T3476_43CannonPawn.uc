//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_T3476_43CannonPawn extends DHSovietCannonPawn;

defaultproperties
{
    GunClass=class'DH_Vehicles.DH_T3476_43Cannon'
    DriverPositions(0)=(ViewLocation=(X=20.0,Y=-11.5,Z=8.5),ViewFOV=30.0,PositionMesh=SkeletalMesh'DH_T34_2_anm.T34m43_turret_int',DriverTransitionAnim="stand_idlehip_binoc",bDrawOverlays=true)
    DriverPositions(1)=(ViewLocation=(X=13.5,Y=0.5,Z=16.0),ViewFOV=75.0,PositionMesh=SkeletalMesh'DH_T34_2_anm.T34m43_turret_int',DriverTransitionAnim="stand_idlehip_binoc",TransitionUpAnim=com_open,ViewPitchUpLimit=1,ViewPitchDownLimit=65535,ViewPositiveYawLimit=65536,ViewNegativeYawLimit=-65536,bDrawOverlays=true)
    //
    DriverPositions(2)=(PositionMesh=SkeletalMesh'DH_T34_2_anm.T34m43_turret_int',DriverTransitionAnim="stand_idlehip_binoc",TransitionDownAnim=com_close,ViewPitchUpLimit=5000,ViewPitchDownLimit=62000,ViewPositiveYawLimit=6000,ViewNegativeYawLimit=-10000,bExposed=true)
    DriverPositions(3)=(ViewFOV=12.0,PositionMesh=SkeletalMesh'DH_T34_2_anm.T34m43_turret_int',DriverTransitionAnim="stand_idleiron_binoc",ViewPitchUpLimit=5000,ViewPitchDownLimit=62000,ViewPositiveYawLimit=6000,ViewNegativeYawLimit=-10000,bDrawOverlays=true,bExposed=true)

    PeriscopePositionIndex=1
    UnbuttonedPositionIndex=2
    BinocPositionIndex=3
    DrivePos=(X=2.0,Y=3.0,Z=4.0)
    DriveRot=(Pitch=0)

    //commented out because this should have mkIV periscope like on t34-85 (its visible in the cupola)
    //PeriscopeOverlay=Texture'DH_VehicleOptics_tex.General.MG_sight' //emulating the PT4-7 periscope 2.5x 26' FOV
    //PeriscopeSize=0.76

    DriveAnim="VIS2_com_idle_close" //"VT3485_com_idle_close"
    bLockCameraDuringTransition=false

    //Gunsight
    GunsightOverlay=Texture'DH_VehicleOptics_tex.Soviet.T3476_sight_background' // edited RO sight to make edges solid black to avoid graphical smears on sides of sight
    CannonScopeCenter=Texture'Vehicle_Optic.T3476_sight_mover'
    GunsightSize=0.5 // 15 degrees visible FOV at 2.5x magnification (TMFD-7 sight)
    DestroyedGunsightOverlay=Texture'DH_VehicleOpticsDestroyed_tex.German.PZ4_sight_destroyed' // matches size of gunsight

    //HUD
    AmmoShellTexture=Texture'InterfaceArt_tex.Tank_Hud.T3476_SU76_Kv1shell'
    AmmoShellReloadTexture=Texture'InterfaceArt_tex.Tank_Hud.T3476_SU76_Kv1shell_reload'

    //Sounds
    PoweredRotateSound=Sound'Vehicle_Weapons.Turret.hydraul_turret_traverse'
    PoweredPitchSound=Sound'Vehicle_Weapons.Turret.manual_turret_elevate'
    PoweredRotateAndPitchSound=Sound'Vehicle_Weapons.Turret.hydraul_turret_traverse'
}

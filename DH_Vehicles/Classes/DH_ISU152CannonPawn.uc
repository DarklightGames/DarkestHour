//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_ISU152CannonPawn extends DHSovietCannonPawn;

defaultproperties
{
    // TODO: periscope had choice of x1 and x5 magnification so could have 2 positions, but code currently only handles 1 PeriscopePositionIndex so have gone with x1 as more generally useful
    // Could easily alter functionality to handle both

    GunClass=class'DH_Vehicles.DH_ISU152Cannon' // 2.5x magnification on gunsight
    DriverPositions(0)=(ViewFOV=45.0,ViewLocation=(X=30.0,Y=-10.5,Z=8.0),PositionMesh=SkeletalMesh'DH_ISU152_anm.ISU152-turret_int',ViewPitchUpLimit=6000,ViewPitchDownLimit=65000,ViewPositiveYawLimit=2000,ViewNegativeYawLimit=-2000,bDrawOverlays=true)
    DriverPositions(1)=(ViewFOV=90.0,ViewLocation=(X=15.0,Z=11.0),PositionMesh=SkeletalMesh'DH_ISU152_anm.ISU152-turret_int',TransitionUpAnim="com_open",ViewPitchUpLimit=1,ViewPitchDownLimit=65535,ViewPositiveYawLimit=6000,ViewNegativeYawLimit=-6000,bDrawOverlays=true)
    DriverPositions(2)=(ViewFOV=90.0,PositionMesh=SkeletalMesh'DH_ISU152_anm.ISU152-turret_int',TransitionDownAnim="com_close",DriverTransitionAnim="stand_idlehip_binoc",ViewPitchUpLimit=14500,ViewPitchDownLimit=64550,ViewPositiveYawLimit=10000,ViewNegativeYawLimit=-60000,bExposed=true)
    DriverPositions(3)=(ViewFOV=12.0,PositionMesh=SkeletalMesh'DH_ISU152_anm.ISU152-turret_int',DriverTransitionAnim="stand_idleiron_binoc",ViewPitchUpLimit=14500,ViewPitchDownLimit=64550,ViewPositiveYawLimit=10000,ViewNegativeYawLimit=-10000,bDrawOverlays=true,bExposed=true)
    PeriscopePositionIndex=1
    bManualTraverseOnly=true
    ManualMinRotateThreshold=0.5
    ManualMaxRotateThreshold=3.0
    DrivePos=(X=5.0,Y=2.0,Z=-16.0) // adjusted from original
    DriveAnim="stand_idlehip_binoc"
    bLockCameraDuringTransition=true // stops player looking sideways & seeing through the vehicle
    bHasAltFire=false
    GunsightOverlay=texture'DH_VehicleOptics_tex.Soviet.isu152_sight_background'
    CannonScopeCenter=texture'Vehicle_Optic.Scopes.T3476_sight_mover'
    DestroyedGunsightOverlay=texture'DH_VehicleOpticsDestroyed_tex.Allied.Sherman_sight_destroyed' // TODO: make one for ISU-152 or generic Soviet
    PeriscopeOverlay=texture'DH_VehicleOptics_tex.Soviet.TNK-1_periscope' // TODO: maybe move this to DHSovietCannonPawn, if was widely used?
    AmmoShellTexture=texture'DH_InterfaceArt_tex.Tank_Hud.ISU152_shell'
    AmmoShellReloadTexture=texture'DH_InterfaceArt_tex.Tank_Hud.ISU152_shell_reload'
    ManualRotateSound=sound'Vehicle_Weapons.Turret.manual_gun_traverse'
    ManualRotateAndPitchSound=sound'Vehicle_Weapons.Turret.manual_gun_traverse'
    FireImpulse=(X=-200000.0)
}

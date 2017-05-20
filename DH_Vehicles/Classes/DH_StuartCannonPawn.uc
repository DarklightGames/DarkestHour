//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_StuartCannonPawn extends DHAmericanCannonPawn;

defaultproperties
{
    GunClass=class'DH_Vehicles.DH_StuartCannon'
    DriverPositions(0)=(ViewLocation=(X=12.0,Y=-9.5,Z=7.0),ViewFOV=24.0,PositionMesh=SkeletalMesh'DH_Stuart_anm.Stuart_turret_ext',TransitionUpAnim="Periscope_in",ViewPitchUpLimit=3641,ViewPitchDownLimit=63352,bDrawOverlays=true)
    DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_Stuart_anm.Stuart_turret_ext',TransitionUpAnim="com_open",ViewPitchUpLimit=1,ViewPitchDownLimit=65535,ViewPositiveYawLimit=65536,ViewNegativeYawLimit=-65536,bDrawOverlays=true)
    DriverPositions(2)=(PositionMesh=SkeletalMesh'DH_Stuart_anm.Stuart_turret_ext',TransitionDownAnim="com_close",DriverTransitionAnim="stand_idlehip_binoc",ViewPitchUpLimit=10000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=65536,ViewNegativeYawLimit=-65536,bExposed=true)
    DriverPositions(3)=(ViewFOV=12.0,PositionMesh=SkeletalMesh'DH_Stuart_anm.Stuart_turret_ext',DriverTransitionAnim="stand_idleiron_binoc",ViewPitchUpLimit=10000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=65536,ViewNegativeYawLimit=-65536,bDrawOverlays=true,bExposed=true)
    PeriscopePositionIndex=1
    DrivePos=(X=8.0,Y=8.0,Z=-5.0)
    DriveAnim="stand_idlehip_binoc"
    GunsightOverlay=texture'DH_VehicleOptics_tex.Allied.Stuart_sight_background'
    GunsightSize=0.542
    DestroyedGunsightOverlay=texture'DH_VehicleOpticsDestroyed_tex.Allied.Stuart_sight_destroyed'
    AmmoShellTexture=texture'DH_InterfaceArt_tex.Tank_Hud.StuartShell'
    AmmoShellReloadTexture=texture'DH_InterfaceArt_tex.Tank_Hud.StuartShell_reload'
    PoweredRotateSound=sound'DH_AlliedVehicleSounds.Sherman.ShermanTurretTraverse'
    PoweredPitchSound=sound'Vehicle_Weapons.Turret.manual_turret_elevate'
    PoweredRotateAndPitchSound=sound'DH_AlliedVehicleSounds.Sherman.ShermanTurretTraverse'
    FireImpulse=(X=-30000.0)
}

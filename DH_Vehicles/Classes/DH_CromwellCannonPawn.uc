//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DH_CromwellCannonPawn extends DHBritishCannonPawn;

defaultproperties
{
    GunClass=class'DH_Vehicles.DH_CromwellCannon'
    DriverPositions(0)=(ViewLocation=(X=23.0,Y=-20.0,Z=0.0),ViewFOV=24.0,TransitionUpAnim="com_idle_close",ViewPitchUpLimit=3641,ViewPitchDownLimit=64500,bDrawOverlays=true)
    DriverPositions(1)=(TransitionUpAnim="com_open",DriverTransitionAnim="stand_idlehip_binoc",ViewPitchUpLimit=1,ViewPitchDownLimit=65535,ViewPositiveYawLimit=12000,ViewNegativeYawLimit=-12000,bDrawOverlays=true)
    DriverPositions(2)=(TransitionDownAnim="com_close",DriverTransitionAnim="VT3485_com_open",ViewPitchUpLimit=10000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=10000,ViewNegativeYawLimit=-10000,bExposed=true)
    DriverPositions(3)=(ViewFOV=12.0,DriverTransitionAnim="stand_idleiron_binoc",ViewPitchUpLimit=10000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=10000,ViewNegativeYawLimit=-10000,bDrawOverlays=true,bExposed=true)
    PeriscopePositionIndex=1
    DriveAnim="stand_idlehip_binoc"
    GunsightOverlay=texture'DH_VehicleOptics_tex.Allied.Cromwell_sight_background'
    CannonScopeCenter=texture'DH_VehicleOptics_tex.Allied.British_sight_mover'
    DestroyedGunsightOverlay=texture'DH_VehicleOpticsDestroyed_tex.Allied.Cromwell_sight_destroyed'
    AmmoShellTexture=texture'DH_InterfaceArt_tex.Tank_Hud.ShermanShell'
    AmmoShellReloadTexture=texture'DH_InterfaceArt_tex.Tank_Hud.ShermanShell_reload'
    PoweredRotateSound=sound'DH_AlliedVehicleSounds.Sherman.ShermanTurretTraverse'
    PoweredPitchSound=sound'Vehicle_Weapons.Turret.manual_turret_elevate'
    PoweredRotateAndPitchSound=sound'DH_AlliedVehicleSounds.Sherman.ShermanTurretTraverse'
}

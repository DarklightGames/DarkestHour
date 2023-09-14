//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_ChurchillMkVIICannonPawn extends DHBritishCannonPawn;

defaultproperties
{
    GunClass=class'DH_Vehicles.DH_ChurchillMkVIICannon'
    DriverPositions(0)=(ViewLocation=(X=12.0,Y=-9.5,Z=-0.75),ViewFOV=28.33,bDrawOverlays=true)
    // TODO: make new animations so no need for these camera offsets:
    DriverPositions(1)=(ViewLocation=(X=44.0,Y=-8.5,Z=3.0),TransitionUpAnim="com_open",ViewPitchUpLimit=1,ViewPitchDownLimit=65535,bDrawOverlays=true)
    DriverPositions(2)=(ViewLocation=(X=5.0,Y=3.0,Z=0.0),TransitionDownAnim="com_close",DriverTransitionAnim="stand_idlehip_binoc",ViewPitchUpLimit=10000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=10000,ViewNegativeYawLimit=-10000,bExposed=true)
    DriverPositions(3)=(ViewLocation=(X=5.0,Y=3.0,Z=0.0),ViewFOV=12.0,DriverTransitionAnim="stand_idleiron_binoc",ViewPitchUpLimit=10000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=10000,ViewNegativeYawLimit=-10000,bDrawOverlays=true,bExposed=true)
    PeriscopePositionIndex=1
    DriveAnim="stand_idlehip_binoc"
    DrivePos=(X=-10.0,Y=3.5,Z=-10.0) // commander clips the cupola whatever animation or position is used, as hatch is so small - this is as good as I could get it
    GunsightOverlay=Texture'DH_VehicleOptics_tex.British.Cromwell_sight_background'
    CannonScopeCenter=Texture'DH_VehicleOptics_tex.British.British_sight_mover'
    GunsightSize=0.459 // 13 degrees visible FOV at 3x magnification (No.50 x3 ML Mk. II sight)
    DestroyedGunsightOverlay=Texture'DH_VehicleOpticsDestroyed_tex.Allied.Cromwell_sight_destroyed'
    AmmoShellTexture=Texture'DH_InterfaceArt_tex.Tank_Hud.ShermanShell'
    AmmoShellReloadTexture=Texture'DH_InterfaceArt_tex.Tank_Hud.ShermanShell_reload'
    PoweredRotateSound=Sound'Vehicle_Weapons.Turret.electric_turret_traverse'
    PoweredPitchSound=Sound'Vehicle_Weapons.Turret.manual_turret_elevate'
    PoweredRotateAndPitchSound=Sound'Vehicle_Weapons.Turret.electric_turret_traverse'
}

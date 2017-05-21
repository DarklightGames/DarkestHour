//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DH_WolverineCannonPawn extends DHAmericanCannonPawn;

defaultproperties
{
    GunClass=class'DH_Vehicles.DH_WolverineCannon'
    DriverPositions(0)=(ViewLocation=(X=35.0,Y=-10.0,Z=8.0),ViewFOV=14.4,PositionMesh=SkeletalMesh'DH_Wolverine_anm.M10_turret_ext',ViewPitchUpLimit=3641,ViewPitchDownLimit=63351,bDrawOverlays=true,bExposed=true)
    DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_Wolverine_anm.M10_turret_ext',TransitionUpAnim="com_open",DriverTransitionAnim="VSU76_com_close",ViewPitchUpLimit=10000,ViewPitchDownLimit=60000,ViewPositiveYawLimit=100000,ViewNegativeYawLimit=-100000,bExposed=true)
    DriverPositions(2)=(PositionMesh=SkeletalMesh'DH_Wolverine_anm.M10_turret_ext',TransitionDownAnim="com_close",DriverTransitionAnim="VSU76_com_open",ViewPitchUpLimit=10000,ViewPitchDownLimit=60000,ViewPositiveYawLimit=100000,ViewNegativeYawLimit=-100000,bExposed=true)
    DriverPositions(3)=(ViewFOV=12.0,PositionMesh=SkeletalMesh'DH_Wolverine_anm.M10_turret_ext',DriverTransitionAnim="stand_idleiron_binoc",ViewPitchUpLimit=10000,ViewPitchDownLimit=60000,ViewPositiveYawLimit=100000,ViewNegativeYawLimit=-100000,bDrawOverlays=true,bExposed=true)
    UnbuttonedPositionIndex=0
    RaisedPositionIndex=2
    BinocPositionIndex=3
    DrivePos=(X=12.0,Y=8.0,Z=1.0)
    DriveAnim="VSU76_com_idle_close"
    bManualTraverseOnly=true
    bHasAltFire=false
    GunsightOverlay=texture'DH_VehicleOptics_tex.Allied.Wolverine_sight_background'
    GunsightSize=0.972
    DestroyedGunsightOverlay=texture'DH_VehicleOpticsDestroyed_tex.Allied.Wolverine_sight_destroyed'
    AmmoShellTexture=texture'DH_InterfaceArt_tex.Tank_Hud.WolverineShell'
    AmmoShellReloadTexture=texture'DH_InterfaceArt_tex.Tank_Hud.WolverineShell_reload'
    FireImpulse=(X=-100000.0)
}

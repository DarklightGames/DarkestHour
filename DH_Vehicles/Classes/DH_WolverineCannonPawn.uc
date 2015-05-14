//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_WolverineCannonPawn extends DHAmericanTankCannonPawn;

defaultproperties
{
    OverlayCenterSize=0.972
    UnbuttonedPositionIndex=0
    DestroyedScopeOverlay=texture'DH_VehicleOpticsDestroyed_tex.Allied.Wolverine_sight_destroyed'
    bManualTraverseOnly=true
    CannonScopeOverlay=texture'DH_VehicleOptics_tex.Allied.Wolverine_sight_background'
    BinocPositionIndex=2
    WeaponFOV=14.4
    AmmoShellTexture=texture'DH_InterfaceArt_tex.Tank_Hud.WolverineShell'
    AmmoShellReloadTexture=texture'DH_InterfaceArt_tex.Tank_Hud.WolverineShell_reload'
    bPlayerCollisionBoxMoves=true
    DriverPositions(0)=(ViewLocation=(X=35.0,Y=-10.0,Z=8.0),ViewFOV=14.4,PositionMesh=SkeletalMesh'DH_Wolverine_anm.M10_turret_ext',TransitionUpAnim="com_open",DriverTransitionAnim="VSU76_com_close",ViewPitchUpLimit=3641,ViewPitchDownLimit=63351,bDrawOverlays=true)
    DriverPositions(1)=(ViewFOV=90.0,PositionMesh=SkeletalMesh'DH_Wolverine_anm.M10_turret_ext',TransitionDownAnim="com_close",DriverTransitionAnim="VSU76_com_open",ViewPitchUpLimit=10000,ViewPitchDownLimit=60000,ViewPositiveYawLimit=100000,ViewNegativeYawLimit=-100000,bExposed=true)
    DriverPositions(2)=(ViewFOV=12.0,PositionMesh=SkeletalMesh'DH_Wolverine_anm.M10_turret_ext',ViewPitchUpLimit=10000,ViewPitchDownLimit=60000,ViewPositiveYawLimit=100000,ViewNegativeYawLimit=-100000,bDrawOverlays=true,bExposed=true)
    FireImpulse=(X=-100000.0)
    GunClass=class'DH_Vehicles.DH_WolverineCannon'
    bHasAltFire=false
    CameraBone="Gun"
    DrivePos=(X=7.0,Y=5.0,Z=-5.0)
    DriveAnim="VSU76_com_idle_close"
    EntryRadius=130.0
    PitchUpLimit=6000
    PitchDownLimit=64000
    SoundVolume=130
    SoundRadius=200.0
}

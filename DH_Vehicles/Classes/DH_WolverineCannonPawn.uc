//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_WolverineCannonPawn extends DHAmericanCannonPawn;

defaultproperties
{
    //Gun Class
    GunClass=class'DH_Vehicles.DH_WolverineCannon'

    //Driver's positions & anims
    DriverPositions(0)=(ViewLocation=(X=25.0,Y=-25.2,Z=8.0),ViewFOV=25,PositionMesh=SkeletalMesh'DH_Wolverine_anm.M10_turret_ext',ViewPitchUpLimit=3641,ViewPitchDownLimit=63351,bDrawOverlays=true,bExposed=true)
    DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_Wolverine_anm.M10_turret_ext',TransitionUpAnim="com_open",DriverTransitionAnim="VSU76_com_close",ViewPitchUpLimit=10000,ViewPitchDownLimit=60000,ViewPositiveYawLimit=100000,ViewNegativeYawLimit=-100000,bExposed=true)
    DriverPositions(2)=(PositionMesh=SkeletalMesh'DH_Wolverine_anm.M10_turret_ext',TransitionDownAnim="com_close",DriverTransitionAnim="VSU76_com_open",ViewPitchUpLimit=10000,ViewPitchDownLimit=60000,ViewPositiveYawLimit=100000,ViewNegativeYawLimit=-100000,bExposed=true)
    DriverPositions(3)=(ViewFOV=12.0,PositionMesh=SkeletalMesh'DH_Wolverine_anm.M10_turret_ext',DriverTransitionAnim="stand_idleiron_binoc",ViewPitchUpLimit=10000,ViewPitchDownLimit=60000,ViewPositiveYawLimit=100000,ViewNegativeYawLimit=-100000,bDrawOverlays=true,bExposed=true)

    UnbuttonedPositionIndex=0
    RaisedPositionIndex=2
    DrivePos=(X=12.0,Y=8.0,Z=1.0)
    DriveAnim="VSU76_com_idle_close"

    //Traverse & Fire
    bManualTraverseOnly=true
    bHasAltFire=false
    FireImpulse=(X=-75000.0)

    //Gunsight
    GunsightOverlay=Texture'DH_VehicleOptics_tex.US.Wolverine_sight_background'
    GunsightSize=0.492 // 12.3 degrees visible FOV at 3x magnification (M70G sight)
    DestroyedGunsightOverlay=Texture'DH_VehicleOpticsDestroyed_tex.Allied.Wolverine_sight_destroyed'

    //HUD
    AmmoShellTexture=Texture'DH_InterfaceArt_tex.Tank_Hud.WolverineShell'
    AmmoShellReloadTexture=Texture'DH_InterfaceArt_tex.Tank_Hud.WolverineShell_reload'
}

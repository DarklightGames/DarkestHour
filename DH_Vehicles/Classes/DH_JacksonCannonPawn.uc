//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_JacksonCannonPawn extends DHAmericanCannonPawn;

defaultproperties
{
    GunClass=class'DH_Vehicles.DH_JacksonCannon'
    DriverPositions(0)=(ViewLocation=(X=12.0,Y=25.0,Z=6.0),ViewFOV=28.33,PositionMesh=SkeletalMesh'DH_Jackson_anm.Jackson_turret_ext',TransitionUpAnim="gunsight_out",ViewPitchUpLimit=3641,ViewPitchDownLimit=63715,ViewPositiveYawLimit=19000,ViewNegativeYawLimit=-20000,bDrawOverlays=true,bExposed=true)
    DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_Jackson_anm.Jackson_turret_ext',TransitionUpAnim="com_open",TransitionDownAnim="gunsight_in",DriverTransitionAnim="VSU76_com_close",ViewPitchUpLimit=10000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=100000,ViewNegativeYawLimit=-100000,bExposed=true)
    DriverPositions(2)=(PositionMesh=SkeletalMesh'DH_Jackson_anm.Jackson_turret_ext',TransitionDownAnim="com_close",DriverTransitionAnim="VSU76_com_open",ViewPitchUpLimit=10000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=100000,ViewNegativeYawLimit=-100000,bExposed=true)
    DriverPositions(3)=(ViewFOV=12.0,PositionMesh=SkeletalMesh'DH_Jackson_anm.Jackson_turret_ext',DriverTransitionAnim="stand_idleiron_binoc",ViewPitchUpLimit=10000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=100000,ViewNegativeYawLimit=-100000,bDrawOverlays=true,bExposed=true)
    UnbuttonedPositionIndex=0
    RaisedPositionIndex=2
    DriveAnim="VSU76_com_idle_close"
    bHasAltFire=false
    GunsightOverlay=Texture'DH_VehicleOptics_tex.US.Jackson_sight_background'
    GunsightSize=0.759 // 21.5 degrees visible FOV at 3x magnification (M76F sight)
    DestroyedGunsightOverlay=Texture'DH_VehicleOpticsDestroyed_tex.Allied.Wolverine_sight_destroyed'
    AmmoShellTexture=Texture'InterfaceArt_tex.Tank_Hud.IS2shell'
    AmmoShellReloadTexture=Texture'InterfaceArt_tex.Tank_Hud.IS2shell_reload'
    PoweredRotateSound=Sound'Vehicle_Weapons.Turret.hydraul_turret_traverse'
    PoweredPitchSound=Sound'Vehicle_Weapons.Turret.manual_turret_elevate'
    PoweredRotateAndPitchSound=Sound'Vehicle_Weapons.Turret.hydraul_turret_traverse'
    FireImpulse=(X=-100000.0)
}

//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_IS2CannonPawn extends DHSovietCannonPawn;

defaultproperties
{
    GunClass=class'DH_Vehicles.DH_IS2Cannon'
    DriverPositions(0)=(ViewLocation=(X=115.0,Y=-20.0,Z=5.0),ViewFOV=22.5,PositionMesh=SkeletalMesh'DH_IS2_anm.IS2-turret_int',ViewPitchUpLimit=6000,ViewPitchDownLimit=64500,ViewPositiveYawLimit=19000,ViewNegativeYawLimit=-20000,bDrawOverlays=true)
    DriverPositions(1)=(ViewLocation=(X=0.0,Y=0.0,Z=14.0),ViewFOV=75.0,PositionMesh=SkeletalMesh'DH_IS2_anm.IS2-turret_ext',DriverTransitionAnim="VIS2_com_idle_close",ViewPitchUpLimit=1,ViewPitchDownLimit=65535,ViewPositiveYawLimit=65536,ViewNegativeYawLimit=-65536,bDrawOverlays=true)
    //TO-DO: add some animations to transition from periscope view
    DriverPositions(2)=(ViewFOV=75.0,PositionMesh=SkeletalMesh'DH_IS2_anm.IS2-turret_int',DriverTransitionAnim="VIS2_com_close",TransitionUpAnim="com_open",ViewPitchUpLimit=4000,ViewPitchDownLimit=64500,ViewPositiveYawLimit=65536,ViewNegativeYawLimit=-65536)
    DriverPositions(3)=(PositionMesh=SkeletalMesh'DH_IS2_anm.IS2-turret_int',DriverTransitionAnim="VIS2_com_open",TransitionDownAnim="com_close",ViewPitchUpLimit=5000,ViewPitchDownLimit=62000,ViewPositiveYawLimit=6000,ViewNegativeYawLimit=-10000,bExposed=true)
    DriverPositions(4)=(ViewFOV=12.0,PositionMesh=SkeletalMesh'DH_IS2_anm.IS2-turret_int',DriverTransitionAnim="stand_idleiron_binoc",ViewPitchUpLimit=5000,ViewPitchDownLimit=62000,ViewPositiveYawLimit=6000,ViewNegativeYawLimit=-10000,bDrawOverlays=true,bExposed=true)


    DriveAnim="VIS2_com_idle_close"
    PeriscopePositionIndex=1
    UnbuttonedPositionIndex=3
    BinocPositionIndex=4

    GunsightOverlay=Texture'Vehicle_Optic.IS2_sight'
    CannonScopeCenter=Texture'Vehicle_Optic.T3476_sight_mover'
    GunsightSize=0.711 // 16 degrees visible FOV at 4x magnification (TSh-17 sight) // TODO: our model 1943 IS-2 may have had 10T/17 sight with 15 degs FOV & 2.5x mag?
    ScopeCenterPositionX=0.075
    ScopeCenterScaleX=2.0
    DestroyedGunsightOverlay=Texture'DH_VehicleOpticsDestroyed_tex.German.PZ4_sight_destroyed' // matches size of gunsight
    AmmoShellTexture=Texture'InterfaceArt_tex.Tank_Hud.IS2shell'
    AmmoShellReloadTexture=Texture'InterfaceArt_tex.Tank_Hud.IS2shell_reload'
    PoweredRotateSound=Sound'Vehicle_Weapons.Turret.hydraul_turret_traverse'
    PoweredPitchSound=Sound'Vehicle_Weapons.Turret.manual_turret_elevate'
    PoweredRotateAndPitchSound=Sound'Vehicle_Weapons.Turret.hydraul_turret_traverse'
    FireImpulse=(X=-120000.0)
}

//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_T3485CannonPawn extends DHSovietCannonPawn;

defaultproperties
{
    GunClass=class'DH_Vehicles.DH_T3485Cannon'
    DriverPositions(0)=(ViewLocation=(X=23.0,Y=-15.0,Z=0.0),ViewFOV=21.25,PositionMesh=SkeletalMesh'DH_T34_anm.T34-85_turret_int',bDrawOverlays=true)
    DriverPositions(1)=(ViewLocation=(X=0,Y=0,Z=15.0),ViewFOV=75.0,PositionMesh=SkeletalMesh'DH_T34_anm.T34-85_turret_int',DriverTransitionAnim="VT3485_com_close",TransitionUpAnim="com_open",ViewPitchUpLimit=1,ViewPitchDownLimit=65535,ViewPositiveYawLimit=65536,ViewNegativeYawLimit=-65536,bDrawOverlays=true)
    //
    DriverPositions(2)=(PositionMesh=SkeletalMesh'DH_T34_anm.T34-85_turret_int',DriverTransitionAnim="VT3485_com_open",TransitionDownAnim="com_close",ViewPitchUpLimit=5000,ViewPitchDownLimit=62000,ViewPositiveYawLimit=6000,ViewNegativeYawLimit=-10000,bExposed=true)
    DriverPositions(3)=(ViewFOV=12.0,PositionMesh=SkeletalMesh'DH_T34_anm.T34-85_turret_int',DriverTransitionAnim="stand_idleiron_binoc",ViewPitchUpLimit=5000,ViewPitchDownLimit=62000,ViewPositiveYawLimit=6000,ViewNegativeYawLimit=-10000,bDrawOverlays=true,bExposed=true)

    DriveAnim="VT3485_com_idle_close"
    PeriscopePositionIndex=1
    BinocPositionIndex=3

    //PeriscopeOverlay=Texture'DH_VehicleOptics_tex.General.MG_sight'
    //PeriscopeSize=0.5

    GunsightOverlay=Texture'Vehicle_Optic.t3485_sight'
    GunsightSize=0.753 // 16 degrees visible FOV at 4x magnification (TSh-16 sight)
    OverlayCorrectionY=-2.5 // raises sight slightly so tip of reticle arrowhead is right on the aim point
    CannonScopeCenter=Texture'Vehicle_Optic.T3476_sight_mover'
    ScopeCenterPositionX=0.075
    ScopeCenterScaleX=2.0
    ScopeCenterScaleY=1.0
    DestroyedGunsightOverlay=Texture'DH_VehicleOpticsDestroyed_tex.German.PZ4_sight_destroyed' // matches size of gunsight

    AmmoShellTexture=Texture'InterfaceArt_tex.Tank_Hud.T3485shell'
    AmmoShellReloadTexture=Texture'InterfaceArt_tex.Tank_Hud.T3485shell_reload'

    PoweredRotateSound=Sound'Vehicle_Weapons.Turret.hydraul_turret_traverse'
    PoweredPitchSound=Sound'Vehicle_Weapons.Turret.manual_turret_elevate'
    PoweredRotateAndPitchSound=Sound'Vehicle_Weapons.Turret.hydraul_turret_traverse'
}

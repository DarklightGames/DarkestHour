//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_IS2CannonPawn extends DHSovietCannonPawn;

defaultproperties
{
    GunClass=class'DH_Vehicles.DH_IS2Cannon'
    DriverPositions(0)=(ViewLocation=(X=115.0,Y=-20.0,Z=5.0),ViewFOV=21.0,PositionMesh=SkeletalMesh'DH_IS2_anm.IS2-turret_int',ViewPitchUpLimit=6000,ViewPitchDownLimit=64500,ViewPositiveYawLimit=19000,ViewNegativeYawLimit=-20000,bDrawOverlays=true)
    DriverPositions(1)=(ViewLocation=(X=-9.0,Y=-18.5,Z=45.0),ViewFOV=75.0,PositionMesh=SkeletalMesh'DH_IS2_anm.IS2-turret_int',DriverTransitionAnim="VIS2_com_close",TransitionUpAnim="com_open",ViewPitchUpLimit=5000,ViewPitchDownLimit=64500,ViewPositiveYawLimit=6000,ViewNegativeYawLimit=-10000,bExposed=false)
    DriverPositions(2)=(ViewLocation=(X=-22.0,Y=-18.5,Z=65.0),ViewFOV=90.0,PositionMesh=SkeletalMesh'DH_IS2_anm.IS2-turret_int',DriverTransitionAnim="VIS2_com_open",TransitionDownAnim="com_close",ViewPitchUpLimit=5000,ViewPitchDownLimit=62000,ViewPositiveYawLimit=6000,ViewNegativeYawLimit=-10000,bExposed=true)
    DriverPositions(3)=(ViewLocation=(X=-22.0,Y=-18.5,Z=65.0),ViewFOV=12.0,PositionMesh=SkeletalMesh'DH_IS2_anm.IS2-turret_int',DriverTransitionAnim="stand_idleiron_binoc",ViewPitchUpLimit=5000,ViewPitchDownLimit=62000,ViewPositiveYawLimit=6000,ViewNegativeYawLimit=-10000,bDrawOverlays=true,bExposed=true)
    DriveAnim="VIS2_com_idle_close"
    GunsightOverlay=texture'Vehicle_Optic.IS2_sight'
    CannonScopeCenter=texture'Vehicle_Optic.T3476_sight_mover'
    ScopeCenterPositionX=0.075
    ScopeCenterScaleX=2.0
    DestroyedGunsightOverlay=texture'DH_VehicleOpticsDestroyed_tex.Allied.Sherman_sight_destroyed' // TODO: use/make one for IS2/Soviet
    AmmoShellTexture=texture'InterfaceArt_tex.Tank_Hud.IS2shell'
    AmmoShellReloadTexture=texture'InterfaceArt_tex.Tank_Hud.IS2shell_reload'
    PoweredRotateSound=sound'Vehicle_Weapons.Turret.hydraul_turret_traverse'
    PoweredPitchSound=sound'Vehicle_Weapons.Turret.manual_turret_elevate'
    PoweredRotateAndPitchSound=sound'Vehicle_Weapons.Turret.hydraul_turret_traverse'
    FireImpulse=(X=-120000.0)
}

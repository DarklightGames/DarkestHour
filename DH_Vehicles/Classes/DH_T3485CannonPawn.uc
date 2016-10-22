//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_T3485CannonPawn extends DHSovietCannonPawn;

defaultproperties
{
    GunClass=class'DH_Vehicles.DH_T3485Cannon' // TODO: 76mm Pos0 FOV was 34 in RO but 29 in DH - need to also change this from 21?
    DriverPositions(0)=(ViewLocation=(X=115.0,Y=-15.0,Z=0.0),ViewFOV=21.0,PositionMesh=SkeletalMesh'DH_T34_anm.T34-85_turret_int',ViewPitchUpLimit=6000,ViewPitchDownLimit=64500,ViewPositiveYawLimit=19000,ViewNegativeYawLimit=-20000,bDrawOverlays=true)
    DriverPositions(1)=(ViewFOV=45,PositionMesh=SkeletalMesh'DH_T34_anm.T34-85_turret_int',DriverTransitionAnim="VT3485_com_close",TransitionUpAnim="com_open",ViewPitchUpLimit=5000,ViewPitchDownLimit=62000,ViewPositiveYawLimit=6000,ViewNegativeYawLimit=-10000)
    DriverPositions(2)=(ViewFOV=85,PositionMesh=SkeletalMesh'DH_T34_anm.T34-85_turret_int',DriverTransitionAnim="VT3485_com_open",TransitionDownAnim="com_close",ViewPitchUpLimit=5000,ViewPitchDownLimit=62000,ViewPositiveYawLimit=6000,ViewNegativeYawLimit=-10000,bExposed=true)
    DriverPositions(3)=(ViewFOV=20,PositionMesh=SkeletalMesh'DH_T34_anm.T34-85_turret_int',DriverTransitionAnim="stand_idleiron_binoc",ViewPitchUpLimit=5000,ViewPitchDownLimit=62000,ViewPositiveYawLimit=6000,ViewNegativeYawLimit=-10000,bDrawOverlays=true,bExposed=true)
    DriveAnim="VT3485_com_idle_close"
    //CameraBone="turret" // TEST
    GunsightOverlay=texture'Vehicle_Optic.t3485_sight'
    CannonScopeCenter=texture'Vehicle_Optic.T3476_sight_mover'
    OverlayCenterSize=0.52
    ScopeCenterPositionX=0.075
    ScopeCenterScaleX=2.0
    DestroyedGunsightOverlay=texture'DH_VehicleOpticsDestroyed_tex.Allied.Sherman_sight_destroyed' // TODO: use/make one for T34
    AmmoShellTexture=texture'InterfaceArt_tex.Tank_Hud.T3485shell'
    AmmoShellReloadTexture=texture'InterfaceArt_tex.Tank_Hud.T3485shell_reload'
    PoweredRotateSound=sound'Vehicle_Weapons.Turret.hydraul_turret_traverse'
    PoweredPitchSound=sound'Vehicle_Weapons.Turret.manual_turret_elevate'
    PoweredRotateAndPitchSound=sound'Vehicle_Weapons.Turret.hydraul_turret_traverse'
}



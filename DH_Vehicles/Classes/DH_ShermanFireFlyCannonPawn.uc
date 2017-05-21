//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DH_ShermanFireFlyCannonPawn extends DHBritishCannonPawn;

defaultproperties
{
    GunClass=class'DH_Vehicles.DH_ShermanFireFlyCannon'
    DriverPositions(0)=(ViewLocation=(X=21.0,Y=14.0,Z=6.0),ViewFOV=12.0,PositionMesh=SkeletalMesh'DH_ShermanFirefly_anm.ShermanFirefly_turret_ext',ViewPitchUpLimit=4551,ViewPitchDownLimit=64625,ViewPositiveYawLimit=19000,ViewNegativeYawLimit=-20000,bDrawOverlays=true)
    DriverPositions(1)=(ViewLocation=(X=21.0,Y=14.0,Z=6.0),ViewFOV=24.0,PositionMesh=SkeletalMesh'DH_ShermanFirefly_anm.ShermanFirefly_turret_ext',TransitionUpAnim="Periscope_in",ViewPitchUpLimit=4551,ViewPitchDownLimit=64625,bDrawOverlays=true)
    DriverPositions(2)=(PositionMesh=SkeletalMesh'DH_ShermanFirefly_anm.ShermanFirefly_turret_ext',TransitionUpAnim="com_open",ViewPitchUpLimit=1,ViewPitchDownLimit=65535,ViewPositiveYawLimit=65536,ViewNegativeYawLimit=-65536,bDrawOverlays=true)
    DriverPositions(3)=(ViewLocation=(X=-5.0,Z=15.0),PositionMesh=SkeletalMesh'DH_ShermanFirefly_anm.ShermanFirefly_turret_ext',TransitionDownAnim="com_close",DriverTransitionAnim="stand_idlehip_binoc",ViewPitchUpLimit=10000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=10000,ViewNegativeYawLimit=-10000,bExposed=true)
    DriverPositions(4)=(ViewLocation=(X=-5.0,Z=15.0),ViewFOV=12.0,PositionMesh=SkeletalMesh'DH_ShermanFirefly_anm.ShermanFirefly_turret_ext',DriverTransitionAnim="stand_idleiron_binoc",ViewPitchUpLimit=10000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=10000,ViewNegativeYawLimit=-10000,bDrawOverlays=true,bExposed=true)
    GunsightPositions=2
    PeriscopePositionIndex=2
    UnbuttonedPositionIndex=3
    BinocPositionIndex=4
    DrivePos=(X=4.0,Y=0.0,Z=-5.0)
    DriveAnim="stand_idlehip_binoc"
    GunsightOverlay=texture'DH_VehicleOptics_tex.Allied.17Pdr_sight_background'
    CannonScopeCenter=texture'DH_VehicleOptics_tex.Allied.British_sight_mover'
    DestroyedGunsightOverlay=texture'DH_VehicleOpticsDestroyed_tex.Allied.17pdr_sight_destroyed'
    AmmoShellTexture=texture'InterfaceArt_tex.Tank_Hud.T3485shell'
    AmmoShellReloadTexture=texture'InterfaceArt_tex.Tank_Hud.T3485shell_reload'
    PoweredRotateSound=sound'DH_AlliedVehicleSounds.Sherman.ShermanTurretTraverse'
    PoweredPitchSound=sound'Vehicle_Weapons.Turret.manual_turret_elevate'
    PoweredRotateAndPitchSound=sound'DH_AlliedVehicleSounds.Sherman.ShermanTurretTraverse'
    FireImpulse=(X=-100000.0)
}

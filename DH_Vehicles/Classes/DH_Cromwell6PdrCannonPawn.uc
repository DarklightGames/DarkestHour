//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_Cromwell6PdrCannonPawn extends DH_BritishTankCannonPawn;

defaultproperties
{
    PeriscopePositionIndex=1
    DestroyedScopeOverlay=texture'DH_VehicleOpticsDestroyed_tex.Allied.Cromwell_sight_destroyed'
    PoweredRotateSound=sound'DH_AlliedVehicleSounds.Sherman.ShermanTurretTraverse'
    PoweredPitchSound=sound'Vehicle_Weapons.Turret.manual_turret_elevate'
    PoweredRotateAndPitchSound=sound'DH_AlliedVehicleSounds.Sherman.ShermanTurretTraverse'
    CannonScopeOverlay=texture'DH_VehicleOptics_tex.Allied.Cromwell6Pdr_sight_background'
    CannonScopeCenter=texture'DH_VehicleOptics_tex.Allied.British_sight_mover'
    ScopePositionX=0.000000
    ScopePositionY=0.000000
    WeaponFov=24.000000
    AmmoShellTexture=texture'InterfaceArt_tex.Tank_Hud.Panzer3shell'
    AmmoShellReloadTexture=texture'InterfaceArt_tex.Tank_Hud.Panzer3shell_reload'
    DriverPositions(0)=(ViewLocation=(X=23.000000,Y=-20.000000),ViewFOV=24.000000,PositionMesh=SkeletalMesh'DH_Cromwell_anm.cromwell_6pdr_turret_int',TransitionUpAnim="Periscope_in",ViewPitchUpLimit=3641,ViewPitchDownLimit=64500,bDrawOverlays=true)
    DriverPositions(1)=(ViewFOV=90.000000,PositionMesh=SkeletalMesh'DH_Cromwell_anm.cromwell_6pdr_turret_int',TransitionUpAnim="com_open",DriverTransitionAnim="VT3485_com_close",ViewPitchUpLimit=1,ViewPitchDownLimit=65535,ViewPositiveYawLimit=12000,ViewNegativeYawLimit=-12000,bDrawOverlays=true)
    DriverPositions(2)=(ViewFOV=90.000000,PositionMesh=SkeletalMesh'DH_Cromwell_anm.cromwell_6pdr_turret_int',TransitionDownAnim="com_close",DriverTransitionAnim="VT3485_com_open",ViewPitchUpLimit=10000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=10000,ViewNegativeYawLimit=-10000,bExposed=true)
    DriverPositions(3)=(ViewFOV=12.000000,PositionMesh=SkeletalMesh'DH_Cromwell_anm.cromwell_6pdr_turret_int',ViewPitchUpLimit=10000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=10000,ViewNegativeYawLimit=-10000,bDrawOverlays=true,bExposed=true)
    GunClass=class'DH_Vehicles.DH_Cromwell6PdrCannon'
    CameraBone="Gun"
    bPCRelativeFPRotation=true
    bFPNoZFromCameraPitch=true
    DrivePos=(Z=-3.000000)
    DriveAnim="VT3485_com_idle_close"
    EntryRadius=130.000000
    TPCamDistance=300.000000
    TPCamLookat=(X=-25.000000,Z=0.000000)
    TPCamWorldOffset=(Z=120.000000)
    PitchUpLimit=6000
    PitchDownLimit=64000
    SoundVolume=130
}

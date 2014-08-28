//==============================================================================
// DH_Cromwell6PdrCannonPawn
//
// Darkest Hour Source - (c) Darkest Hour Team 2010
// Red Orchestra Source - (c) Tripwire Interactive 2006
//
// British Cruiser Tank Mk.VIII Cromwell Mk.I cannon pawn
//==============================================================================
class DH_Cromwell6PdrCannonPawn extends DH_BritishTankCannonPawn;

defaultproperties
{
     PeriscopePositionIndex=1
     DestroyedScopeOverlay=Texture'DH_VehicleOpticsDestroyed_tex.Allied.Cromwell_sight_destroyed'
     PoweredRotateSound=Sound'DH_AlliedVehicleSounds.Sherman.ShermanTurretTraverse'
     PoweredPitchSound=Sound'Vehicle_Weapons.Turret.manual_turret_elevate'
     PoweredRotateAndPitchSound=Sound'DH_AlliedVehicleSounds.Sherman.ShermanTurretTraverse'
     CannonScopeOverlay=Texture'DH_VehicleOptics_tex.Allied.Cromwell6Pdr_sight_background'
     CannonScopeCenter=Texture'DH_VehicleOptics_tex.Allied.British_sight_mover'
     ScopePositionX=0.000000
     ScopePositionY=0.000000
     WeaponFov=24.000000
     AmmoShellTexture=Texture'InterfaceArt_tex.Tank_Hud.Panzer3shell'
     AmmoShellReloadTexture=Texture'InterfaceArt_tex.Tank_Hud.Panzer3shell_reload'
     DriverPositions(0)=(ViewLocation=(X=23.000000,Y=-20.000000),ViewFOV=24.000000,PositionMesh=SkeletalMesh'DH_Cromwell_anm.cromwell_6pdr_turret_int',TransitionUpAnim="Periscope_in",ViewPitchUpLimit=3641,ViewPitchDownLimit=64500,bDrawOverlays=true)
     DriverPositions(1)=(ViewFOV=90.000000,PositionMesh=SkeletalMesh'DH_Cromwell_anm.cromwell_6pdr_turret_int',TransitionUpAnim="com_open",DriverTransitionAnim="VT3485_com_close",ViewPitchUpLimit=1,ViewPitchDownLimit=65535,ViewPositiveYawLimit=12000,ViewNegativeYawLimit=-12000,bDrawOverlays=true)
     DriverPositions(2)=(ViewFOV=90.000000,PositionMesh=SkeletalMesh'DH_Cromwell_anm.cromwell_6pdr_turret_int',TransitionDownAnim="com_close",DriverTransitionAnim="VT3485_com_open",ViewPitchUpLimit=10000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=10000,ViewNegativeYawLimit=-10000,bExposed=true)
     DriverPositions(3)=(ViewFOV=12.000000,PositionMesh=SkeletalMesh'DH_Cromwell_anm.cromwell_6pdr_turret_int',ViewPitchUpLimit=10000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=10000,ViewNegativeYawLimit=-10000,bDrawOverlays=true,bExposed=true)
     GunClass=Class'DH_Vehicles.DH_Cromwell6PdrCannon'
     CameraBone="Gun"
     bPCRelativeFPRotation=true
     bFPNoZFromCameraPitch=true
     DrivePos=(Z=-3.000000)
     DriveAnim="VT3485_com_idle_close"
     ExitPositions(0)=(Y=-120.000000,Z=150.000000)
     ExitPositions(1)=(Y=120.000000,Z=150.000000)
     EntryRadius=130.000000
     TPCamDistance=300.000000
     TPCamLookat=(X=-25.000000,Z=0.000000)
     TPCamWorldOffset=(Z=120.000000)
     VehiclePositionString="in a Cromwell Mk.I cannon"
     VehicleNameString="Cromwell Mk.I cannon"
     PitchUpLimit=6000
     PitchDownLimit=64000
     SoundVolume=130
}

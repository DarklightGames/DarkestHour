//==============================================================================
// DH_PanzerIIINCannonPawn
//
// Darkest Hour Source - (c) Darkest Hour Team 2010
// Red Orchestra Source - (c) Tripwire Interactive 2006
//
// German Panzer III Ausf. N tank cannon pawn
//==============================================================================
class DH_PanzerIIINCannonPawn extends DH_GermanTankCannonPawn;

defaultproperties
{
     ScopeCenterScale=0.635000
     ScopeCenterRotator=TexRotator'DH_VehicleOptics_tex.German.PZ4_sight_Center'
     CenterRotationFactor=985
     OverlayCenterSize=0.780000
     DestroyedScopeOverlay=Texture'DH_VehicleOpticsDestroyed_tex.German.PZ4_sight_destroyed'
     bManualTraverseOnly=true
     PoweredRotateSound=Sound'Vehicle_Weapons.Turret.manual_turret_traverse'
     PoweredPitchSound=Sound'Vehicle_Weapons.Turret.manual_turret_elevate'
     PoweredRotateAndPitchSound=Sound'Vehicle_Weapons.Turret.manual_turret_traverse'
     CannonScopeCenter=Texture'DH_VehicleOptics_tex.German.PZ3_sight_graticule'
     ScopePositionX=0.237000
     ScopePositionY=0.150000
     WeaponFov=30.000000
     AmmoShellTexture=Texture'DH_InterfaceArt_tex.Tank_Hud.Panzer3shell'
     AmmoShellReloadTexture=Texture'DH_InterfaceArt_tex.Tank_Hud.Panzer3shell_reload'
     DriverPositions(0)=(ViewLocation=(X=12.000000,Y=-27.000000,Z=3.000000),ViewFOV=30.000000,PositionMesh=SkeletalMesh'DH_Panzer3_anm.Panzer3n_turret_int',ViewPitchUpLimit=3641,ViewPitchDownLimit=64080,ViewPositiveYawLimit=19000,ViewNegativeYawLimit=-20000,bDrawOverlays=true)
     DriverPositions(1)=(ViewFOV=85.000000,PositionMesh=SkeletalMesh'DH_Panzer3_anm.Panzer3n_turret_int',TransitionUpAnim="com_open",DriverTransitionAnim="VKV1_com_close",ViewPitchUpLimit=5000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=6000,ViewNegativeYawLimit=-10000)
     DriverPositions(2)=(ViewFOV=85.000000,PositionMesh=SkeletalMesh'DH_Panzer3_anm.Panzer3n_turret_int',TransitionDownAnim="com_close",DriverTransitionAnim="VKV1_com_open",ViewPitchUpLimit=5000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=10000,ViewNegativeYawLimit=-10000,bExposed=true)
     DriverPositions(3)=(ViewFOV=12.000000,PositionMesh=SkeletalMesh'DH_Panzer3_anm.Panzer3n_turret_int',ViewPitchUpLimit=5000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=10000,ViewNegativeYawLimit=-10000,bDrawOverlays=true,bExposed=true)
     GunClass=Class'DH_Vehicles.DH_PanzerIIINCannon'
     CameraBone="Gun"
     bPCRelativeFPRotation=true
     bFPNoZFromCameraPitch=true
     DrivePos=(Z=-6.000000)
     DriveAnim="VKV1_com_idle_close"
     ExitPositions(0)=(Y=-100.000000,Z=160.000000)
     ExitPositions(1)=(Y=100.000000,Z=160.000000)
     EntryRadius=130.000000
     FPCamPos=(X=50.000000,Y=-30.000000,Z=11.000000)
     TPCamDistance=300.000000
     TPCamLookat=(X=-25.000000,Z=0.000000)
     TPCamWorldOffset=(Z=120.000000)
     VehiclePositionString="in a Panzer III Ausf.N cannon"
     VehicleNameString="Panzer III Ausf.N Cannon"
     PitchUpLimit=6000
     PitchDownLimit=64000
     SoundVolume=130
}

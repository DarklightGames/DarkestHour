//==============================================================================
// DH_ShermanCannonPawn_M4A3E2
//
// Darkest Hour Source - (c) Darkest Hour Team 2010
// Red Orchestra Source - (c) Tripwire Interactive 2006
//
// American M4A3E2(75)W (Sherman 'Jumbo') 75mm assault tank cannon pawn
//==============================================================================
class DH_ShermanCannonPawn_M4A3E2 extends DH_AmericanTankCannonPawn;

defaultproperties
{
     OverlayCenterSize=0.542000
     UnbuttonedPositionIndex=3
     DestroyedScopeOverlay=Texture'DH_VehicleOpticsDestroyed_tex.Allied.Sherman_sight_destroyed'
     PoweredRotateSound=Sound'DH_AlliedVehicleSounds.Sherman.ShermanTurretTraverse'
     PoweredPitchSound=Sound'Vehicle_Weapons.Turret.manual_turret_elevate'
     PoweredRotateAndPitchSound=Sound'DH_AlliedVehicleSounds.Sherman.ShermanTurretTraverse'
     CannonScopeOverlay=Texture'DH_VehicleOptics_tex.Allied.Sherman_sight_background'
     BinocPositionIndex=4
     WeaponFov=24.000000
     AmmoShellTexture=Texture'DH_InterfaceArt_tex.Tank_Hud.ShermanShell'
     AmmoShellReloadTexture=Texture'DH_InterfaceArt_tex.Tank_Hud.ShermanShell_reload'
     DriverPositions(0)=(ViewLocation=(X=24.000000,Y=18.000000,Z=2.000000),ViewFOV=24.000000,PositionMesh=SkeletalMesh'DH_ShermanM4A3E2_anm.ShermanM4A3E2_turret_int',ViewPitchUpLimit=4551,ViewPitchDownLimit=63715,ViewPositiveYawLimit=19000,ViewNegativeYawLimit=-20000,bDrawOverlays=true)
     DriverPositions(1)=(ViewFOV=90.000000,PositionMesh=SkeletalMesh'DH_ShermanM4A3E2_anm.ShermanM4A3E2_turret_int',TransitionUpAnim="Periscope_in",ViewPitchUpLimit=1,ViewPitchDownLimit=65535,ViewPositiveYawLimit=65536,ViewNegativeYawLimit=-65536,bDrawOverlays=true)
     DriverPositions(2)=(ViewFOV=90.000000,PositionMesh=SkeletalMesh'DH_ShermanM4A3E2_anm.ShermanM4A3E2_turret_int',TransitionUpAnim="com_open",TransitionDownAnim="periscope_out",ViewPitchUpLimit=10000,ViewPitchDownLimit=65535,ViewPositiveYawLimit=10000,ViewNegativeYawLimit=-10000)
     DriverPositions(3)=(ViewFOV=90.000000,PositionMesh=SkeletalMesh'DH_ShermanM4A3E2_anm.ShermanM4A3E2_turret_int',TransitionDownAnim="com_close",ViewPitchUpLimit=10000,ViewPitchDownLimit=62500,ViewPositiveYawLimit=10000,ViewNegativeYawLimit=-10000,bExposed=true)
     DriverPositions(4)=(ViewFOV=12.000000,PositionMesh=SkeletalMesh'DH_ShermanM4A3E2_anm.ShermanM4A3E2_turret_int',DriverTransitionAnim="stand_idleiron_binoc",ViewPitchUpLimit=10000,ViewPitchDownLimit=62500,ViewPositiveYawLimit=10000,ViewNegativeYawLimit=-10000,bDrawOverlays=true,bExposed=true)
     FireImpulse=(X=-95000.000000)
     GunClass=Class'DH_Vehicles.DH_ShermanCannon_M4A3E2'
     CameraBone="Gun"
     bPCRelativeFPRotation=true
     bFPNoZFromCameraPitch=true
     DrivePos=(X=3.000000,Z=8.000000)
     DriveAnim="stand_idlehip_binoc"
     ExitPositions(0)=(Y=-100.000000,Z=186.000000)
     ExitPositions(1)=(Y=100.000000,Z=186.000000)
     EntryRadius=130.000000
     TPCamDistance=300.000000
     TPCamLookat=(X=-25.000000,Z=0.000000)
     TPCamWorldOffset=(Z=120.000000)
     VehiclePositionString="in a M4A3E2(75)W Sherman cannon"
     VehicleNameString="M4A3E2(75)W Sherman Cannon"
     PitchUpLimit=6000
     PitchDownLimit=64000
     SoundVolume=130
     PeriscopePositionIndex=1
}

//==============================================================================
// DH_ShermanCannonPawn_M4A3105
//
// Darkest Hour Source - (c) Darkest Hour Team 2010
// Red Orchestra Source - (c) Tripwire Interactive 2006
//
// American M4A3 (105) 105mm tank howtizer cannon pawn
//==============================================================================
class DH_ShermanCannonPawn_M4A3105 extends DH_AmericanTankCannonPawn;

defaultproperties
{
     OverlayCenterSize=0.542000
     UnbuttonedPositionIndex=3
     DestroyedScopeOverlay=Texture'DH_VehicleOpticsDestroyed_tex.Allied.Sherman_sight_destroyed'
     PoweredRotateSound=Sound'Vehicle_Weapons.Turret.manual_turret_traverse'
     PoweredPitchSound=Sound'Vehicle_Weapons.Turret.manual_turret_elevate'
     PoweredRotateAndPitchSound=Sound'Vehicle_Weapons.Turret.manual_turret_traverse'
     CannonScopeOverlay=Texture'DH_VehicleOptics_tex.Allied.sherman105_sight_background'
     BinocPositionIndex=4
     WeaponFov=24.000000
     AmmoShellTexture=Texture'DH_InterfaceArt_tex.Tank_Hud.Sherman105Shell'
     AmmoShellReloadTexture=Texture'DH_InterfaceArt_tex.Tank_Hud.Sherman105Shell_reload'
     DriverPositions(0)=(ViewLocation=(X=25.000000,Y=18.000000,Z=2.000000),ViewFOV=24.000000,PositionMesh=SkeletalMesh'DH_ShermanM4A3E2_anm.shermanM4A3105_turret_int',TransitionUpAnim="Periscope_in",ViewPitchUpLimit=4551,ViewPitchDownLimit=63715,ViewPositiveYawLimit=19000,ViewNegativeYawLimit=-20000,bDrawOverlays=true)
     DriverPositions(1)=(ViewFOV=85.000000,PositionMesh=SkeletalMesh'DH_ShermanM4A3E2_anm.shermanM4A3105_turret_int',TransitionUpAnim="periscope_out",ViewPitchUpLimit=1,ViewPitchDownLimit=65535,ViewPositiveYawLimit=65536,ViewNegativeYawLimit=-65536,bDrawOverlays=true)
     DriverPositions(2)=(ViewFOV=85.000000,PositionMesh=SkeletalMesh'DH_ShermanM4A3E2_anm.shermanM4A3105_turret_int',TransitionUpAnim="com_open",TransitionDownAnim="Periscope_in",ViewPitchUpLimit=1,ViewPitchDownLimit=65535,ViewPositiveYawLimit=65536,ViewNegativeYawLimit=-65536)
     DriverPositions(3)=(ViewFOV=85.000000,PositionMesh=SkeletalMesh'DH_ShermanM4A3E2_anm.shermanM4A3105_turret_int',TransitionDownAnim="com_close",ViewPitchUpLimit=10000,ViewPitchDownLimit=65535,ViewPositiveYawLimit=10000,ViewNegativeYawLimit=-10000,bExposed=true)
     DriverPositions(4)=(ViewFOV=12.000000,PositionMesh=SkeletalMesh'DH_ShermanM4A3E2_anm.shermanM4A3105_turret_int',ViewPitchUpLimit=10000,ViewPitchDownLimit=62500,ViewPositiveYawLimit=10000,ViewNegativeYawLimit=-10000,bDrawOverlays=true,bExposed=true)
     FireImpulse=(X=-110000.000000)
     GunClass=Class'DH_Vehicles.DH_ShermanCannon_M4A3105'
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
     VehiclePositionString="in a M4A3(105) Sherman cannon"
     VehicleNameString="M4A3(105) Sherman Cannon"
     PitchUpLimit=6500
     PitchDownLimit=63500
     SoundVolume=130
}

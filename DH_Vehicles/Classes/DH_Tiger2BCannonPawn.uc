//==============================================================================
// DH_Tiger2BCannonPawn
//
// Darkest Hour Source - (c) Darkest Hour Team 2010
// Red Orchestra Source - (c) Tripwire Interactive 2006
//
// German Panzer VI Ausf. B "King Tiger" tank cannon pawn
//==============================================================================
class DH_Tiger2BCannonPawn extends DH_GermanTankCannonPawn;

defaultproperties
{
     ScopeCenterScale=0.715000
     ScopeCenterRotator=TexRotator'DH_VehicleOptics_tex.German.tiger2B_sight_center'
     CenterRotationFactor=502
     OverlayCenterSize=0.870000
     GunsightPositions=2
     UnbuttonedPositionIndex=3
     DestroyedScopeOverlay=Texture'DH_VehicleOpticsDestroyed_tex.German.tiger_sight_destroyed'
     PoweredRotateSound=Sound'DH_GerVehicleSounds2.Tiger2B.tiger2B_turret_traverse_loop'
     PoweredPitchSound=Sound'Vehicle_Weapons.Turret.manual_turret_travelevate'
     PoweredRotateAndPitchSound=Sound'DH_GerVehicleSounds2.Tiger2B.tiger2B_turret_traverse_loop'
     CannonScopeCenter=Texture'DH_VehicleOptics_tex.German.tiger_sight_graticule'
     ScopePositionX=0.237000
     ScopePositionY=0.150000
     BinocPositionIndex=4
     WeaponFov=28.799999
     AmmoShellTexture=Texture'DH_InterfaceArt_tex.Tank_Hud.KingTigerShell'
     AmmoShellReloadTexture=Texture'DH_InterfaceArt_tex.Tank_Hud.KingTigerShell_reload'
     DriverPositions(0)=(ViewLocation=(Y=-27.000000),ViewFOV=14.400000,PositionMesh=SkeletalMesh'DH_Tiger2B_anm.tiger2B_turret_int',ViewPitchUpLimit=2731,ViewPitchDownLimit=64189,ViewPositiveYawLimit=19000,ViewNegativeYawLimit=-20000,bDrawOverlays=True)
     DriverPositions(1)=(ViewLocation=(Y=-27.000000),ViewFOV=28.799999,PositionMesh=SkeletalMesh'DH_Tiger2B_anm.tiger2B_turret_int',ViewPitchUpLimit=2731,ViewPitchDownLimit=64189,ViewPositiveYawLimit=19000,ViewNegativeYawLimit=-20000,bDrawOverlays=True)
     DriverPositions(2)=(ViewLocation=(Z=-5.000000),ViewFOV=85.000000,PositionMesh=SkeletalMesh'DH_Tiger2B_anm.tiger2B_turret_int',TransitionUpAnim="com_open",DriverTransitionAnim="VPanther_com_close",ViewPitchUpLimit=5000,ViewPitchDownLimit=64000,ViewPositiveYawLimit=6000,ViewNegativeYawLimit=-10000)
     DriverPositions(3)=(ViewFOV=85.000000,PositionMesh=SkeletalMesh'DH_Tiger2B_anm.tiger2B_turret_int',TransitionDownAnim="com_close",DriverTransitionAnim="VPanther_com_open",ViewPitchUpLimit=10000,ViewPitchDownLimit=64000,ViewPositiveYawLimit=6000,ViewNegativeYawLimit=-10000,bExposed=True)
     DriverPositions(4)=(ViewFOV=12.000000,PositionMesh=SkeletalMesh'DH_Tiger2B_anm.tiger2B_turret_int',ViewPitchUpLimit=10000,ViewPitchDownLimit=64000,ViewPositiveYawLimit=6000,ViewNegativeYawLimit=-10000,bDrawOverlays=True,bExposed=True)
     FireImpulse=(X=-110000.000000)
     GunClass=Class'DH_Vehicles.DH_Tiger2BCannon'
     CameraBone="Gun"
     bPCRelativeFPRotation=True
     bFPNoZFromCameraPitch=True
     DrivePos=(Z=5.000000)
     DriveAnim="VPanther_com_idle_close"
     ExitPositions(0)=(X=-150.000000,Z=125.000000)
     ExitPositions(1)=(X=-150.000000,Z=125.000000)
     ExitPositions(2)=(Y=150.000000,Z=125.000000)
     ExitPositions(3)=(Y=-150.000000,Z=125.000000)
     EntryRadius=130.000000
     FPCamPos=(Y=-27.000000)
     TPCamDistance=300.000000
     TPCamLookat=(X=-25.000000,Z=0.000000)
     TPCamWorldOffset=(Z=120.000000)
     VehiclePositionString="in a Panzer VI Ausf.B cannon"
     VehicleNameString="Panzer VI Ausf.B cannon"
     PitchUpLimit=2731
     PitchDownLimit=64206
}

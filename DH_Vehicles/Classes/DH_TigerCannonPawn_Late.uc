//==============================================================================
// DH_TigerCannonPawn_Late
//
// Darkest Hour Source - (c) Darkest Hour Team 2010
// Red Orchestra Source - (c) Tripwire Interactive 2006
//
// German Panzer VI Ausf. E "Tiger" tank cannon pawn
//==============================================================================
class DH_TigerCannonPawn_Late extends DH_GermanTankCannonPawn;

defaultproperties
{
     ScopeCenterScale=0.680000
     ScopeCenterRotator=TexRotator'DH_VehicleOptics_tex.German.tiger_sight_center'
     CenterRotationFactor=820
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
     AmmoShellTexture=Texture'InterfaceArt_tex.Tank_Hud.Tigershell'
     AmmoShellReloadTexture=Texture'InterfaceArt_tex.Tank_Hud.Tigershell_reload'
     DriverPositions(0)=(ViewLocation=(X=35.000000,Y=-31.000000,Z=3.000000),ViewFOV=14.400000,PositionMesh=SkeletalMesh'axis_tiger1_anm.Tiger1_turret_int',ViewPitchUpLimit=3095,ViewPitchDownLimit=64353,ViewPositiveYawLimit=19000,ViewNegativeYawLimit=-20000,bDrawOverlays=true)
     DriverPositions(1)=(ViewLocation=(X=35.000000,Y=-31.000000,Z=3.000000),ViewFOV=28.799999,PositionMesh=SkeletalMesh'axis_tiger1_anm.Tiger1_turret_int',ViewPitchUpLimit=3095,ViewPitchDownLimit=64353,ViewPositiveYawLimit=19000,ViewNegativeYawLimit=-20000,bDrawOverlays=true)
     DriverPositions(2)=(ViewFOV=85.000000,PositionMesh=SkeletalMesh'axis_tiger1_anm.Tiger1_turret_int',TransitionUpAnim="com_open",DriverTransitionAnim="VTiger_com_close",ViewPitchUpLimit=5000,ViewPitchDownLimit=64000,ViewPositiveYawLimit=6000,ViewNegativeYawLimit=-10000)
     DriverPositions(3)=(ViewFOV=85.000000,PositionMesh=SkeletalMesh'axis_tiger1_anm.Tiger1_turret_int',TransitionDownAnim="com_close",DriverTransitionAnim="VTiger_com_open",ViewPitchUpLimit=10000,ViewPitchDownLimit=64000,ViewPositiveYawLimit=6000,ViewNegativeYawLimit=-10000,bExposed=true)
     DriverPositions(4)=(ViewFOV=12.000000,PositionMesh=SkeletalMesh'axis_tiger1_anm.Tiger1_turret_int',ViewPitchUpLimit=10000,ViewPitchDownLimit=64000,ViewPositiveYawLimit=6000,ViewNegativeYawLimit=-10000,bDrawOverlays=true,bExposed=true)
     FireImpulse=(X=-110000.000000)
     GunClass=Class'DH_Vehicles.DH_TigerCannon'
     CameraBone="Gun"
     bPCRelativeFPRotation=true
     DriveAnim="VTiger_com_idle_close"
     ExitPositions(0)=(X=-150.000000,Z=130.000000)
     ExitPositions(1)=(X=-50.000000,Y=20.000000,Z=150.000000)
     ExitPositions(2)=(Y=-200.000000,Z=100.000000)
     EntryRadius=130.000000
     FPCamPos=(X=50.000000,Y=-30.000000,Z=11.000000)
     TPCamDistance=300.000000
     TPCamLookat=(X=-25.000000,Z=0.000000)
     VehiclePositionString="in a Panzer VI Ausf.E cannon"
     VehicleNameString="Panzer VI Ausf.E Cannon"
     PitchUpLimit=6000
     PitchDownLimit=64000
}

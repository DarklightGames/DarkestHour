//==============================================================================
// DH_PantherDCannonPawn
//
// Darkest Hour Source - (c) Darkest Hour Team 2010
// Red Orchestra Source - (c) Tripwire Interactive 2006
//
// German Panzer V Ausf. D (Panther) tank cannon pawn
//==============================================================================
class DH_PantherDCannonPawn extends DH_GermanTankCannonPawn;

defaultproperties
{
     ScopeCenterScale=0.715000
     ScopeCenterRotator=TexRotator'DH_VehicleOptics_tex.German.Panther_sight_center'
     CenterRotationFactor=502
     OverlayCenterSize=0.972000
     DestroyedScopeOverlay=Texture'DH_VehicleOpticsDestroyed_tex.German.Panther_sight_destroyed'
     PoweredRotateSound=Sound'Vehicle_Weapons.Turret.hydraul_turret_traverse'
     PoweredPitchSound=Sound'Vehicle_Weapons.Turret.manual_turret_elevate'
     PoweredRotateAndPitchSound=Sound'Vehicle_Weapons.Turret.hydraul_turret_traverse'
     CannonScopeCenter=Texture'DH_VehicleOptics_tex.German.Panther_sight_graticule'
     ScopePositionX=0.237000
     ScopePositionY=0.150000
     WeaponFov=28.799999
     AmmoShellTexture=Texture'InterfaceArt_tex.Tank_Hud.Panthershell'
     AmmoShellReloadTexture=Texture'InterfaceArt_tex.Tank_Hud.Panthershell_reload'
     DriverPositions(0)=(ViewLocation=(X=34.000000,Y=-27.000000,Z=7.000000),ViewFOV=28.799999,PositionMesh=SkeletalMesh'axis_pantherg_anm.PantherG_turret_int',ViewPitchUpLimit=3276,ViewPitchDownLimit=64080,ViewPositiveYawLimit=19000,ViewNegativeYawLimit=-20000,bDrawOverlays=true)
     DriverPositions(1)=(ViewFOV=90.000000,PositionMesh=SkeletalMesh'axis_pantherg_anm.PantherG_turret_int',TransitionUpAnim="com_open",DriverTransitionAnim="VPanther_com_close",ViewPitchUpLimit=5000,ViewPitchDownLimit=64000,ViewPositiveYawLimit=6000,ViewNegativeYawLimit=-10000)
     DriverPositions(2)=(ViewFOV=90.000000,PositionMesh=SkeletalMesh'axis_pantherg_anm.PantherG_turret_int',TransitionDownAnim="com_close",DriverTransitionAnim="VPanther_com_open",ViewPitchUpLimit=10000,ViewPitchDownLimit=64000,ViewPositiveYawLimit=6000,ViewNegativeYawLimit=-10000,bExposed=true)
     DriverPositions(3)=(ViewFOV=12.000000,PositionMesh=SkeletalMesh'axis_pantherg_anm.PantherG_turret_int',ViewPitchUpLimit=10000,ViewPitchDownLimit=64000,ViewPositiveYawLimit=6000,ViewNegativeYawLimit=-10000,bDrawOverlays=true,bExposed=true)
     FireImpulse=(X=-110000.000000)
     GunClass=Class'DH_Vehicles.DH_PantherDCannon'
     CameraBone="Gun"
     bPCRelativeFPRotation=true
     bFPNoZFromCameraPitch=true
     DriveAnim="VPanther_com_idle_close"
     EntryRadius=130.000000
     TPCamDistance=300.000000
     TPCamLookat=(X=-25.000000,Z=0.000000)
     TPCamWorldOffset=(Z=120.000000)
     VehiclePositionString="in a Panzer V Ausf.D cannon"
     VehicleNameString="Panzer V Ausf.D Cannon"
     PitchUpLimit=6000
     PitchDownLimit=64000
     SoundVolume=130
}

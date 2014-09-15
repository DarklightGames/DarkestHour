//==============================================================================
// DH_JagdpanzerIVL70CannonPawn
//
// Darkest Hour Source - (c) Darkest Hour Team 2010
// Red Orchestra Source - (c) Tripwire Interactive 2006
//
// German Jagdpanzer IV Ausf. F 70(V) tank cannon pawn
//==============================================================================
class DH_JagdpanzerIVL70CannonPawn extends DH_AssaultGunCannonPawn;

defaultproperties
{
     PeriscopeOverlay=Texture'DH_VehicleOptics_tex.German.PERISCOPE_overlay_German'
     OverlayCenterSize=0.555000
     PeriscopePositionIndex=1
     DestroyedScopeOverlay=Texture'DH_VehicleOpticsDestroyed_tex.German.stug3_SflZF1a_destroyed'
     bManualTraverseOnly=true
     PoweredRotateSound=Sound'Vehicle_Weapons.Turret.manual_gun_traverse'
     PoweredPitchSound=Sound'Vehicle_Weapons.Turret.manual_turret_elevate'
     PoweredRotateAndPitchSound=Sound'Vehicle_Weapons.Turret.manual_gun_traverse'
     CannonScopeOverlay=Texture'DH_VehicleOptics_tex.German.stug3_SflZF1a_sight'
     WeaponFov=14.400000
     AmmoShellTexture=Texture'InterfaceArt_tex.Tank_Hud.Panthershell'
     AmmoShellReloadTexture=Texture'InterfaceArt_tex.Tank_Hud.Panthershell_reload'
     DriverPositions(0)=(ViewLocation=(X=-20.000000,Y=-30.000000,Z=25.000000),ViewFOV=14.400000,PositionMesh=SkeletalMesh'DH_Jagdpanzer4_anm.Jagdpanzer4L70_turret_int',TransitionUpAnim="Overlay_In",ViewPitchUpLimit=2731,ViewPitchDownLimit=64653,ViewPositiveYawLimit=1820,ViewNegativeYawLimit=-1820,bDrawOverlays=true)
     DriverPositions(1)=(ViewFOV=90.000000,PositionMesh=SkeletalMesh'DH_Jagdpanzer4_anm.Jagdpanzer4L70_turret_int',TransitionUpAnim="com_open",DriverTransitionAnim="VStug3_com_close",ViewPitchUpLimit=1,ViewPitchDownLimit=65300,ViewPositiveYawLimit=65535,ViewNegativeYawLimit=-65535,bDrawOverlays=true)
     DriverPositions(2)=(ViewFOV=90.000000,PositionMesh=SkeletalMesh'DH_Jagdpanzer4_anm.Jagdpanzer4L70_turret_int',TransitionDownAnim="com_close",DriverTransitionAnim="VStug3_com_open",ViewPitchUpLimit=10000,ViewPitchDownLimit=64500,ViewPositiveYawLimit=65535,ViewNegativeYawLimit=-65535,bExposed=true)
     DriverPositions(3)=(ViewFOV=12.000000,PositionMesh=SkeletalMesh'DH_Jagdpanzer4_anm.Jagdpanzer4L70_turret_int',ViewPitchUpLimit=10000,ViewPitchDownLimit=60000,ViewPositiveYawLimit=65535,ViewNegativeYawLimit=-65535,bDrawOverlays=true,bExposed=true)
     GunClass=Class'DH_Vehicles.DH_JagdpanzerIVL70Cannon'
     bHasAltFire=false
     CameraBone="Turret"
     MinRotateThreshold=0.500000
     MaxRotateThreshold=3.000000
     bPCRelativeFPRotation=true
     bFPNoZFromCameraPitch=true
     DrivePos=(X=5.000000,Z=-30.000000)
     DriveAnim="VStug3_com_idle_close"
     ExitPositions(0)=(Y=-150.000000,Z=150.000000)
     ExitPositions(1)=(Y=150.000000,Z=150.000000)
     EntryRadius=130.000000
     FPCamPos=(Z=5.000000)
     TPCamDistance=300.000000
     TPCamLookat=(X=-25.000000,Z=0.000000)
     TPCamWorldOffset=(Z=120.000000)
     VehiclePositionString="in a Jagdpanzer IV/70(V) cannon"
     VehicleNameString="Jagdpanzer IV/70(V) cannon"
     PitchUpLimit=6000
     PitchDownLimit=64000
     SoundVolume=130
}

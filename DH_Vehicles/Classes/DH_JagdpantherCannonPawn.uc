//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_JagdpantherCannonPawn extends DH_AssaultGunCannonPawn;

defaultproperties
{
     OverlayCenterSize=0.555000
     PeriscopePositionIndex=1
     DestroyedScopeOverlay=Texture'DH_VehicleOpticsDestroyed_tex.German.stug3_SflZF1a_destroyed'
     bManualTraverseOnly=true
     PoweredRotateSound=Sound'Vehicle_Weapons.Turret.manual_turret_traverse2'
     PoweredPitchSound=Sound'Vehicle_Weapons.Turret.manual_turret_elevate'
     PoweredRotateAndPitchSound=Sound'Vehicle_Weapons.Turret.manual_gun_traverse'
     CannonScopeOverlay=Texture'DH_Artillery_Tex.ATGun_Hud.ZF_II_3x8_Pak'
     bLockCameraDuringTransition=true
     WeaponFov=14.400000
     AmmoShellTexture=Texture'DH_InterfaceArt_tex.Tank_Hud.KingTigerShell'
     AmmoShellReloadTexture=Texture'DH_InterfaceArt_tex.Tank_Hud.KingTigerShell_reload'
     DriverPositions(0)=(ViewLocation=(X=70.000000,Y=-23.000000,Z=15.000000),ViewFOV=14.400000,PositionMesh=SkeletalMesh'DH_Jagdpanther_anm.Jagdpanther_turret_int',ViewPitchUpLimit=2548,ViewPitchDownLimit=64079,ViewPositiveYawLimit=3000,ViewNegativeYawLimit=-3000,bDrawOverlays=true)
     DriverPositions(1)=(ViewFOV=7.200000,PositionMesh=SkeletalMesh'DH_Jagdpanther_anm.Jagdpanther_turret_int',TransitionUpAnim="com_open",ViewPitchUpLimit=1200,ViewPitchDownLimit=64500,ViewPositiveYawLimit=18000,ViewNegativeYawLimit=-18000,bDrawOverlays=true)
     DriverPositions(2)=(ViewFOV=90.000000,PositionMesh=SkeletalMesh'DH_Jagdpanther_anm.Jagdpanther_turret_int',TransitionDownAnim="com_close",DriverTransitionAnim="VStug3_com_open",ViewPitchUpLimit=6000,ViewPitchDownLimit=65000,ViewPositiveYawLimit=100000,ViewNegativeYawLimit=-100000,bExposed=true)
     DriverPositions(3)=(ViewFOV=12.000000,PositionMesh=SkeletalMesh'DH_Jagdpanther_anm.Jagdpanther_turret_int',ViewPitchUpLimit=6000,ViewPitchDownLimit=65000,ViewPositiveYawLimit=100000,ViewNegativeYawLimit=-100000,bDrawOverlays=true,bExposed=true)
     FireImpulse=(X=-110000.000000)
     GunClass=class'DH_Vehicles.DH_JagdpantherCannon'
     bHasAltFire=false
     CameraBone="Turret_placement1"
     MaxRotateThreshold=3.000000
     bPCRelativeFPRotation=true
     bFPNoZFromCameraPitch=true
     DrivePos=(Z=-4.000000)
     DriveAnim="VStug3_com_idle_close"
     EntryRadius=130.000000
     TPCamDistance=300.000000
     TPCamLookat=(X=-25.000000,Z=0.000000)
     TPCamWorldOffset=(Z=120.000000)
     VehiclePositionString="in a Jagdpanzer V cannon"
     VehicleNameString="Jagdpanzer V Cannon"
     PitchUpLimit=6000
     PitchDownLimit=64000
     SoundVolume=130
}

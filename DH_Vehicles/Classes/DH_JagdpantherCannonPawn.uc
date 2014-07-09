//==============================================================================
// DH_JagdpantherCannonPawn
//
// Darkest Hour Source - (c) Darkest Hour Team 2010
// Red Orchestra Source - (c) Tripwire Interactive 2006
//
// German Jadgpanzer V 'Jagdpanther' tank destroyer cannon pawn
//==============================================================================
class DH_JagdpantherCannonPawn extends DH_AssaultGunCannonPawn;


// Commander cannot fire cannon when he is on the scissors scope or binocs (because he's not mounted on the damn gun!)
function Fire(optional float F)
{
	if( DriverPositionIndex == PeriscopePositionIndex || DriverPositionIndex == BinocPositionIndex && ROPlayer(Controller) != none )
	{
        return;
	}

	super.Fire(F);
}

defaultproperties
{
     OverlayCenterSize=0.555000
     PeriscopePositionIndex=1
     DestroyedScopeOverlay=Texture'DH_VehicleOpticsDestroyed_tex.German.stug3_SflZF1a_destroyed'
     bManualTraverseOnly=True
     PoweredRotateSound=Sound'Vehicle_Weapons.Turret.manual_turret_traverse2'
     PoweredPitchSound=Sound'Vehicle_Weapons.Turret.manual_turret_elevate'
     PoweredRotateAndPitchSound=Sound'Vehicle_Weapons.Turret.manual_gun_traverse'
     CannonScopeOverlay=Texture'DH_Artillery_Tex.ATGun_Hud.ZF_II_3x8_Pak'
     bLockCameraDuringTransition=True
     WeaponFov=14.400000
     AmmoShellTexture=Texture'DH_InterfaceArt_tex.Tank_Hud.KingTigerShell'
     AmmoShellReloadTexture=Texture'DH_InterfaceArt_tex.Tank_Hud.KingTigerShell_reload'
     DriverPositions(0)=(ViewLocation=(X=70.000000,Y=-23.000000,Z=15.000000),ViewFOV=14.400000,PositionMesh=SkeletalMesh'DH_Jagdpanther_anm.Jagdpanther_turret_int',ViewPitchUpLimit=2548,ViewPitchDownLimit=64079,ViewPositiveYawLimit=3000,ViewNegativeYawLimit=-3000,bDrawOverlays=True)
     DriverPositions(1)=(ViewFOV=7.200000,PositionMesh=SkeletalMesh'DH_Jagdpanther_anm.Jagdpanther_turret_int',TransitionUpAnim="com_open",ViewPitchUpLimit=1200,ViewPitchDownLimit=64500,ViewPositiveYawLimit=18000,ViewNegativeYawLimit=-18000,bDrawOverlays=True)
     DriverPositions(2)=(ViewFOV=80.000000,PositionMesh=SkeletalMesh'DH_Jagdpanther_anm.Jagdpanther_turret_int',TransitionDownAnim="com_close",DriverTransitionAnim="VStug3_com_open",ViewPitchUpLimit=6000,ViewPitchDownLimit=65000,ViewPositiveYawLimit=100000,ViewNegativeYawLimit=-100000,bExposed=True)
     DriverPositions(3)=(ViewFOV=12.000000,PositionMesh=SkeletalMesh'DH_Jagdpanther_anm.Jagdpanther_turret_int',ViewPitchUpLimit=6000,ViewPitchDownLimit=65000,ViewPositiveYawLimit=100000,ViewNegativeYawLimit=-100000,bDrawOverlays=True,bExposed=True)
     FireImpulse=(X=-110000.000000)
     GunClass=Class'DH_Vehicles.DH_JagdpantherCannon'
     bHasAltFire=False
     CameraBone="Turret_placement1"
     MaxRotateThreshold=3.000000
     bPCRelativeFPRotation=True
     bFPNoZFromCameraPitch=True
     DrivePos=(Z=-4.000000)
     DriveAnim="VStug3_com_idle_close"
     ExitPositions(0)=(X=-120.000000,Z=130.000000)
     ExitPositions(1)=(X=200.000000,Z=100.000000)
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

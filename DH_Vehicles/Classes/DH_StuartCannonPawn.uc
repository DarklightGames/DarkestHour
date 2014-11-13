//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_StuartCannonPawn extends DH_AmericanTankCannonPawn;

defaultproperties
{
     OverlayCenterSize=0.542000
     DestroyedScopeOverlay=Texture'DH_VehicleOpticsDestroyed_tex.Allied.Stuart_sight_destroyed'
     PoweredRotateSound=Sound'DH_AlliedVehicleSounds.Sherman.ShermanTurretTraverse'
     PoweredPitchSound=Sound'Vehicle_Weapons.Turret.manual_turret_elevate'
     PoweredRotateAndPitchSound=Sound'DH_AlliedVehicleSounds.Sherman.ShermanTurretTraverse'
     CannonScopeOverlay=Texture'DH_VehicleOptics_tex.Allied.Stuart_sight_background'
     WeaponFov=24.000000
     AmmoShellTexture=Texture'DH_InterfaceArt_tex.Tank_Hud.StuartShell'
     AmmoShellReloadTexture=Texture'DH_InterfaceArt_tex.Tank_Hud.StuartShell_reload'
     DriverPositions(0)=(ViewLocation=(X=12.000000,Y=-9.500000,Z=7.000000),ViewFOV=24.000000,PositionMesh=SkeletalMesh'DH_Stuart_anm.Stuart_turret_ext',TransitionUpAnim="Periscope_in",ViewPitchUpLimit=3641,ViewPitchDownLimit=63352,bDrawOverlays=true)
     DriverPositions(1)=(ViewFOV=90.000000,PositionMesh=SkeletalMesh'DH_Stuart_anm.Stuart_turret_ext',TransitionUpAnim="com_open",DriverTransitionAnim="VT60_com_close",ViewPitchUpLimit=1,ViewPitchDownLimit=65535,ViewPositiveYawLimit=65536,ViewNegativeYawLimit=-65536,bDrawOverlays=true)
     DriverPositions(2)=(ViewFOV=90.000000,PositionMesh=SkeletalMesh'DH_Stuart_anm.Stuart_turret_ext',TransitionDownAnim="com_close",DriverTransitionAnim="VT60_com_open",ViewPitchUpLimit=10000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=65536,ViewNegativeYawLimit=-65536,bExposed=true)
     DriverPositions(3)=(ViewFOV=12.000000,PositionMesh=SkeletalMesh'DH_Stuart_anm.Stuart_turret_ext',ViewPitchUpLimit=10000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=65536,ViewNegativeYawLimit=-65536,bDrawOverlays=true,bExposed=true)
     GunClass=class'DH_Vehicles.DH_StuartCannon'
     CameraBone="Gun"
     bPCRelativeFPRotation=true
     bFPNoZFromCameraPitch=true
     DrivePos=(X=8.000000,Y=4.800000,Z=-5.750000)
     DriveAnim="VT60_com_idle_close"
     EntryRadius=130.000000
     TPCamDistance=300.000000
     TPCamLookat=(X=-25.000000,Z=0.000000)
     TPCamWorldOffset=(Z=120.000000)
     VehiclePositionString="in a M5 Stuart cannon"
     VehicleNameString="M5 Stuart Cannon"
     PitchUpLimit=6000
     PitchDownLimit=64000
     SoundVolume=130
     PeriscopePositionIndex=1
}

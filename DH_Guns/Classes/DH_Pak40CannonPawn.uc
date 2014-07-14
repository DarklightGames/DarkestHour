//==============================================================================
// DH_Pak40CannonPawn
//
// Darkest Hour Source - (c) Darkest Hour Team 2010
// Red Orchestra Source - (c) Tripwire Interactive 2006
// AHZ AT Gun Source -(c) William "Teufelhund" Miller
//
// German 7.5 cm Panzerabwehrkanone 40 cannon pawn
//==============================================================================
class DH_Pak40CannonPawn extends DH_ATGunTwoCannonPawn;

defaultproperties
{
     OverlayCenterSize=0.570000
     CannonScopeOverlay=Texture'DH_Artillery_Tex.ATGun_Hud.ZF_II_3x8_Pak'
     BinocPositionIndex=2
     WeaponFov=24.000000
     AmmoShellTexture=Texture'InterfaceArt_tex.Tank_Hud.panzer4F2shell'
     AmmoShellReloadTexture=Texture'InterfaceArt_tex.Tank_Hud.panzer4F2shell_reload'
     DriverPositions(0)=(ViewLocation=(X=30.000000,Y=-20.000000,Z=30.000000),ViewFOV=24.000000,PositionMesh=SkeletalMesh'DH_Pak40_anm.Pak40_turret',TransitionUpAnim="com_open",DriverTransitionAnim="crouch_idlehold_bayo",ViewPitchUpLimit=4005,ViewPitchDownLimit=64623,ViewPositiveYawLimit=5825,ViewNegativeYawLimit=-5825,bDrawOverlays=True,bExposed=True)
     DriverPositions(1)=(ViewFOV=85.000000,PositionMesh=SkeletalMesh'DH_Pak40_anm.Pak40_turret',TransitionDownAnim="com_close",DriverTransitionAnim="stand_idlehip_binoc",ViewPitchUpLimit=6000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=20000,ViewNegativeYawLimit=-20000,bExposed=True)
     DriverPositions(2)=(ViewFOV=12.000000,PositionMesh=SkeletalMesh'DH_Pak40_anm.Pak40_turret',DriverTransitionAnim="stand_idleiron_binoc",ViewPitchUpLimit=6000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=20000,ViewNegativeYawLimit=-20000,bDrawOverlays=True,bExposed=True)
     GunClass=Class'DH_Guns.DH_Pak40Cannon'
     CameraBone="Turret"
     RotateSound=Sound'Vehicle_Weapons.Turret.manual_gun_traverse'
     PitchSound=Sound'Vehicle_Weapons.Turret.manual_turret_elevate'
     RotateAndPitchSound=Sound'Vehicle_Weapons.Turret.manual_gun_traverse'
     bFPNoZFromCameraPitch=True
     DrivePos=(X=-20.000000,Z=-44.000000)
     DriveAnim="crouch_idlehold_bayo"
     ExitPositions(0)=(X=-150.000000,Y=0.000000,Z=0.000000)
     ExitPositions(1)=(X=-100.000000,Y=0.000000,Z=0.000000)
     ExitPositions(2)=(X=-100.000000,Y=20.000000,Z=0.000000)
     ExitPositions(3)=(X=-100.000000,Y=-20.000000,Z=0.000000)
     ExitPositions(4)=(Y=50.000000,Z=0.000000)
     ExitPositions(5)=(Y=-50.000000,Z=0.000000)
     ExitPositions(6)=(X=-50.000000,Y=-50.000000,Z=0.000000)
     ExitPositions(7)=(X=-50.000000,Y=50.000000,Z=0.000000)
     ExitPositions(8)=(X=-75.000000,Y=75.000000,Z=0.000000)
     ExitPositions(9)=(X=-75.000000,Y=-75.000000,Z=0.000000)
     ExitPositions(10)=(X=-40.000000,Y=0.000000,Z=5.000000)
     ExitPositions(11)=(X=-60.000000,Y=0.000000,Z=5.000000)
     ExitPositions(12)=(X=-60.000000,Z=10.000000)
     ExitPositions(13)=(X=-60.000000,Z=15.000000)
     ExitPositions(14)=(X=-60.000000,Z=20.000000)
     ExitPositions(15)=(Z=5.000000)
     EntryRadius=200.000000
     VehiclePositionString="Using a Pak40 AT-Gun"
     VehicleNameString="Pak40 AT-Gun"
     bKeepDriverAuxCollision=True
     SoundVolume=130
}

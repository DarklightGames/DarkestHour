//==============================================================================
// DH_Pak43CannonPawn
//
// Darkest Hour Source - (c) Darkest Hour Team 2010
// Red Orchestra Source - (c) Tripwire Interactive 2006
// AHZ AT Gun Source -(c) William "Teufelhund" Miller
//
// German 8.8 cm Panzerabwehrkanone 43/41 cannon pawn
//==============================================================================
class DH_Pak43CannonPawn extends DH_ATGunTwoCannonPawn;

defaultproperties
{
     OverlayCenterSize=0.570000
     CannonScopeOverlay=Texture'DH_Artillery_Tex.ATGun_Hud.ZF_II_3x8_Pak'
     BinocPositionIndex=2
     WeaponFov=24.000000
     AmmoShellTexture=Texture'DH_InterfaceArt_tex.Tank_Hud.KingTigerShell'
     AmmoShellReloadTexture=Texture'DH_InterfaceArt_tex.Tank_Hud.KingTigerShell_reload'
     DriverPositions(0)=(ViewLocation=(X=50.000000,Y=-24.000000,Z=8.000000),ViewFOV=24.000000,PositionMesh=SkeletalMesh'DH_Pak43_anm.pak43_turret',TransitionUpAnim="com_open",DriverTransitionAnim="crouch_idlehold_bayo",ViewPitchUpLimit=6918,ViewPitchDownLimit=64626,ViewPositiveYawLimit=6000,ViewNegativeYawLimit=-6000,bDrawOverlays=true,bExposed=true)
     DriverPositions(1)=(ViewFOV=85.000000,PositionMesh=SkeletalMesh'DH_Pak43_anm.pak43_turret',TransitionDownAnim="com_close",DriverTransitionAnim="stand_idlehip_binoc",ViewPitchUpLimit=5000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=20000,ViewNegativeYawLimit=-20000,bExposed=true)
     DriverPositions(2)=(ViewFOV=12.000000,PositionMesh=SkeletalMesh'DH_Pak43_anm.pak43_turret',DriverTransitionAnim="stand_idleiron_binoc",ViewPitchUpLimit=5000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=20000,ViewNegativeYawLimit=-20000,bDrawOverlays=true,bExposed=true)
     GunClass=Class'DH_Guns.DH_Pak43Cannon'
     CameraBone="Gun"
     RotateSound=Sound'Vehicle_Weapons.Turret.manual_gun_traverse'
     PitchSound=Sound'Vehicle_Weapons.Turret.manual_turret_elevate'
     RotateAndPitchSound=Sound'Vehicle_Weapons.Turret.manual_gun_traverse'
     bFPNoZFromCameraPitch=true
     DrivePos=(Y=-5.000000,Z=-85.000000)
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
     VehiclePositionString="Using a Pak43/41 Gun"
     VehicleNameString="Pak43/41 AT-Gun"
     bKeepDriverAuxCollision=true
     SoundVolume=130
}

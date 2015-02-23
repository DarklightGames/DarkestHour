//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_Flak88CannonPawn extends DH_ATGunTwoCannonPawn;

defaultproperties
{
    OverlayCenterSize=0.961
    OverlayCorrectionX=-3
    CannonScopeOverlay=texture'DH_VehicleOptics_tex.Artillery.Flak36_sight_background'
    BinocPositionIndex=2
    WeaponFov=18.0
    AmmoShellTexture=texture'InterfaceArt_tex.Tank_Hud.Tigershell'
    AmmoShellReloadTexture=texture'InterfaceArt_tex.Tank_Hud.Tigershell_reload'
    DriverPositions(0)=(ViewLocation=(X=70.0,Y=20.0,Z=5.0),ViewFOV=18.0,PositionMesh=SkeletalMesh'DH_Flak88_anm.flak88_turret',DriverTransitionAnim="Vt3485_driver_idle_close",ViewPitchUpLimit=15474,ViewPitchDownLimit=64990,ViewPositiveYawLimit=3000,ViewNegativeYawLimit=-3000,bDrawOverlays=true,bExposed=true)
    DriverPositions(1)=(ViewFOV=90.0,PositionMesh=SkeletalMesh'DH_Flak88_anm.flak88_turret',DriverTransitionAnim="Vt3485_driver_idle_close",ViewPitchUpLimit=8000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=8000,ViewNegativeYawLimit=-8000,bExposed=true)
    DriverPositions(2)=(ViewFOV=12.0,PositionMesh=SkeletalMesh'DH_Flak88_anm.flak88_turret',DriverTransitionAnim="Vt3485_driver_idle_close",ViewPitchUpLimit=8000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=8000,ViewNegativeYawLimit=-8000,bDrawOverlays=true,bExposed=true)
    GunClass=class'DH_Guns.DH_Flak88Cannon'
    CameraBone="Gun"
    bFPNoZFromCameraPitch=true
    DrivePos=(X=-15.0,Z=-5.0)
    DriveAnim="Vt3485_driver_idle_close"
    ExitPositions(0)=(X=-150.0,Y=0.0,Z=0.0)
    ExitPositions(1)=(X=-100.0,Y=0.0,Z=0.0)
    ExitPositions(2)=(X=-100.0,Y=20.0,Z=0.0)
    ExitPositions(3)=(X=-100.0,Y=-20.0,Z=0.0)
    ExitPositions(4)=(Y=50.0,Z=0.0)
    ExitPositions(5)=(Y=-50.0,Z=0.0)
    ExitPositions(6)=(X=-50.0,Y=-50.0,Z=0.0)
    ExitPositions(7)=(X=-50.0,Y=50.0,Z=0.0)
    ExitPositions(8)=(X=-75.0,Y=75.0,Z=0.0)
    ExitPositions(9)=(X=-75.0,Y=-75.0,Z=0.0)
    ExitPositions(10)=(X=-40.0,Y=0.0,Z=5.0)
    ExitPositions(11)=(X=-60.0,Y=0.0,Z=5.0)
    ExitPositions(12)=(X=-60.0,Z=10.0)
    ExitPositions(13)=(X=-60.0,Z=15.0)
    ExitPositions(14)=(X=-60.0,Z=20.0)
    ExitPositions(15)=(Z=5.0)
    EntryRadius=325.0
    bKeepDriverAuxCollision=true
    SoundVolume=100
}

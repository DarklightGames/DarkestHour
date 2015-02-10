//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_Flak88CannonPawn extends DH_ATGunTwoCannonPawn;

defaultproperties
{
    OverlayCenterSize=0.961000
    OverlayCorrectionX=-3
    CannonScopeOverlay=texture'DH_VehicleOptics_tex.Artillery.Flak36_sight_background'
    BinocPositionIndex=2
    WeaponFov=18.000000
    AmmoShellTexture=texture'InterfaceArt_tex.Tank_Hud.Tigershell'
    AmmoShellReloadTexture=texture'InterfaceArt_tex.Tank_Hud.Tigershell_reload'
    DriverPositions(0)=(ViewLocation=(X=70.000000,Y=20.000000,Z=5.000000),ViewFOV=18.000000,PositionMesh=SkeletalMesh'DH_Flak88_anm.flak88_turret',DriverTransitionAnim="Vt3485_driver_idle_close",ViewPitchUpLimit=15474,ViewPitchDownLimit=64990,ViewPositiveYawLimit=3000,ViewNegativeYawLimit=-3000,bDrawOverlays=true,bExposed=true)
    DriverPositions(1)=(ViewFOV=90.000000,PositionMesh=SkeletalMesh'DH_Flak88_anm.flak88_turret',DriverTransitionAnim="Vt3485_driver_idle_close",ViewPitchUpLimit=8000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=8000,ViewNegativeYawLimit=-8000,bExposed=true)
    DriverPositions(2)=(ViewFOV=12.000000,PositionMesh=SkeletalMesh'DH_Flak88_anm.flak88_turret',DriverTransitionAnim="Vt3485_driver_idle_close",ViewPitchUpLimit=8000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=8000,ViewNegativeYawLimit=-8000,bDrawOverlays=true,bExposed=true)
    GunClass=class'DH_Guns.DH_Flak88Cannon'
    CameraBone="Gun"
    bFPNoZFromCameraPitch=true
    DrivePos=(X=-15.000000,Z=-5.000000)
    DriveAnim="Vt3485_driver_idle_close"
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
    EntryRadius=325.000000
    bKeepDriverAuxCollision=true
    SoundVolume=100
}

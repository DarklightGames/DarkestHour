//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_Flak38CannonPawn extends DH_ATGunTwoCannonPawn;

#exec OBJ LOAD FILE=..\Animations\DH_Flak38_anm.ukx
#exec OBJ LOAD FILE=..\Textures\DH_Flak38_tex.utx

// Emptied out as shells inherits RangeSettings from Sd.Kfz.234/1 armored car, but flak 38 has no range settings on the gunsight:
function IncrementRange();
function DecrementRange();

defaultproperties
{
    CannonScopeOverlay=texture'DH_Flakvierling38_tex.flak.flakv38_sight'
    AmmoShellTexture=texture'DH_InterfaceArt_tex.Tank_Hud.2341Mag'
    AmmoShellReloadTexture=texture'DH_InterfaceArt_tex.Tank_Hud.2341Mag_reload'
    DriverPositions(0)=(ViewLocation=(X=30.0),ViewFOV=12.0,PositionMesh=SkeletalMesh'DH_Flak38_anm.Flak38_turret',TransitionUpAnim="optic_out",DriverTransitionAnim="Vt3485_driver_idle_close",bDrawOverlays=true,bExposed=true)
    DriverPositions(1)=(ViewFOV=90.0,PositionMesh=SkeletalMesh'DH_Flak38_anm.Flak38_turret',TransitionUpAnim="com_open",TransitionDownAnim="optic_in",DriverTransitionAnim="Vt3485_driver_idle_close",bExposed=true)
    DriverPositions(2)=(ViewFOV=90.0,PositionMesh=SkeletalMesh'DH_Flak38_anm.Flak38_turret',TransitionDownAnim="com_close",DriverTransitionAnim="Vt3485_driver_idle_close",ViewPitchUpLimit=6000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=20000,ViewNegativeYawLimit=-20000,bExposed=true)
    DriverPositions(3)=(ViewFOV=18.0,PositionMesh=SkeletalMesh'DH_Flak38_anm.Flak38_turret',DriverTransitionAnim="Vt3485_driver_idle_close",ViewPitchUpLimit=6000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=20000,ViewNegativeYawLimit=-20000,bDrawOverlays=true,bExposed=true)
    GunClass=class'DH_Guns.DH_Flak38Cannon'
    CameraBone="Camera_com"
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
    TPCamDistance=2048.0
    TPCamLookat=(X=25.0)
    TPCamWorldOffset=(Z=0.0)
    bKeepDriverAuxCollision=true
}

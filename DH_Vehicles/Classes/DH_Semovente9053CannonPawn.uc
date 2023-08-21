//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_Semovente9053CannonPawn extends DHAssaultGunCannonPawn;

defaultproperties
{
    GunClass=class'DH_Vehicles.DH_Semovente9053Cannon'
    DriverPositions(0)=(ViewLocation=(X=30.0,Y=-26.0,Z=1.0),ViewFOV=28.33,PositionMesh=SkeletalMesh'DH_Semovente9053_anm.semovente9053_turret_ext',ViewPitchUpLimit=2367,ViewPitchDownLimit=64625,ViewPositiveYawLimit=3822,ViewNegativeYawLimit=-3822,bDrawOverlays=true,bExposed=true)
    DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_Semovente9053_anm.semovente9053_turret_ext',TransitionUpAnim="com_open",DriverTransitionAnim="semo9053_com_close",ViewPitchUpLimit=10000,ViewPitchDownLimit=62000,ViewPositiveYawLimit=65536,ViewNegativeYawLimit=-65536,bExposed=true)
    DriverPositions(2)=(PositionMesh=SkeletalMesh'DH_Semovente9053_anm.semovente9053_turret_ext',TransitionDownAnim="com_close",DriverTransitionAnim="semo9053_com_open",ViewPitchUpLimit=10000,ViewPitchDownLimit=62000,ViewPositiveYawLimit=65536,ViewNegativeYawLimit=-65536,bExposed=true)
    DriverPositions(3)=(ViewFOV=12.0,PositionMesh=SkeletalMesh'DH_Semovente9053_anm.semovente9053_turret_ext',DriverTransitionAnim="semo9053_com_binocs",ViewPitchUpLimit=10000,ViewPitchDownLimit=62000,ViewPositiveYawLimit=65536,ViewNegativeYawLimit=-65536,bDrawOverlays=true,bExposed=true)
    UnbuttonedPositionIndex=0
    RaisedPositionIndex=2
    DriveRot=(Yaw=32768)
    DrivePos=(Z=58)
    DriveAnim="semo9053_com_idle_close"
    bHasAltFire=false
    // Figure out what gunsight to use (also maybe refactor to have the gunsights be a separate class that can just be referenced and reused by multiple vehicles)
    GunsightOverlay=Texture'DH_Semovente9053_tex.Interface.semovente9053_gunsight'
    GunsightSize=0.282 // 8 degrees visible FOV at 3x magnification (ZF 3x8 Pak sight)
    AmmoShellTexture=Texture'InterfaceArt_tex.Tank_Hud.panzer4F2shell'
    AmmoShellReloadTexture=Texture'InterfaceArt_tex.Tank_Hud.panzer4F2shell_reload'
    FireImpulse=(X=-110000)
    CameraBone="CAMERA_GUN"
}

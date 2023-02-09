//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_SdKfz2519DCannonPawn extends DHAssaultGunCannonPawn;

defaultproperties
{
    GunClass=class'DH_Vehicles.DH_SdKfz2519DCannon'

    bMustBeTankCrew=true
    bHasAltFire=false
    FireImpulse=(X=-1000.0)

    DriverPositions(0)=(ViewLocation=(X=28.0,Y=-19.0,Z=3.0),ViewFOV=28.33,PositionMesh=SkeletalMesh'DH_Stummel.stummel_ext',TransitionUpAnim="com_open",DriverTransitionAnim="stummel_com_close",ViewPitchUpLimit=4005,ViewPitchDownLimit=64623,ViewPositiveYawLimit=5825,ViewNegativeYawLimit=-5825,bDrawOverlays=true,bExposed=true)
    DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_Stummel.stummel_ext',TransitionDownAnim="com_close",DriverTransitionAnim="stummel_com_open",ViewPitchUpLimit=6000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=2400,ViewNegativeYawLimit=-5100,bExposed=true)
    DriverPositions(2)=(ViewFOV=12.0,PositionMesh=SkeletalMesh'DH_Stummel.stummel_ext',DriverTransitionAnim="stummel_com_draw_binoc",ViewPitchUpLimit=6000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=20000,ViewNegativeYawLimit=-20000,bDrawOverlays=true,bExposed=true)

    UnbuttonedPositionIndex=0
    RaisedPositionIndex=1
    BinocPositionIndex=2

    DrivePos=(X=0.0,Y=-2.0,Z=-12.0)
    DriveAnim="stummel_com_idle_close"

    GunsightOverlay=Texture'DH_VehicleOptics_tex.German.ZF_II_3x8_Pak'
    GunsightSize=0.282 // 8 degrees visible FOV at 3x magnification (ZF 3x8 Pak sight)

    AmmoShellTexture=Texture'DH_InterfaceArt_tex.Tank_Hud.Panzer3shell'
    AmmoShellReloadTexture=Texture'DH_InterfaceArt_tex.Tank_Hud.Panzer3shell_reload'

    PlayerCameraBone="com_camera"

    // Sounds
    ManualPitchSound=Sound'Vehicle_Weapons.Turret.manual_turret_elevate'
}

//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2021
//==============================================================================

class DH_M3GunCannonPawn extends DHATGunCannonPawn;

defaultproperties
{
    GunClass=class'DH_Guns.DH_M3GunCannon'
    DriverPositions(0)=(ViewLocation=(X=0.0,Y=0,Z=-16.0),ViewFOV=28.33,TransitionUpAnim="com_open",DriverTransitionAnim="crouch_idlehold_bayo",ViewPositiveYawLimit=20000,ViewNegativeYawLimit=-20000,bDrawOverlays=true,bExposed=true) // view limits only relevant during transition down, to avoid snap to front at start
    DriverPositions(1)=(TransitionDownAnim="com_close",DriverTransitionAnim="stand_idlehip_binoc",ViewPitchUpLimit=5000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=20000,ViewNegativeYawLimit=-20000,bExposed=true)
    DriverPositions(2)=(ViewFOV=12.0,DriverTransitionAnim="stand_idleiron_binoc",ViewPitchUpLimit=5000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=20000,ViewNegativeYawLimit=-20000,bDrawOverlays=true,bExposed=true)

    DrivePos=(X=5.0,Y=10,Z=46.0)
    DriveAnim="crouch_idlehold_bayo"
    CameraBone="com_camera"
    PlayerCameraBone="com_camera"

    GunsightOverlay=Texture'DH_VehicleOptics_tex.US.Stuart_sight_background'
    GunsightSize=0.435 // 12.3 degrees visible FOV at 3x magnification (M70D sight)
    DestroyedGunsightOverlay=Texture'DH_VehicleOpticsDestroyed_tex.Allied.Stuart_sight_destroyed'

    AmmoShellTexture=Texture'DH_InterfaceArt_tex.Tank_Hud.WolverineShell'
    AmmoShellReloadTexture=Texture'DH_InterfaceArt_tex.Tank_Hud.WolverineShell_reload'
}

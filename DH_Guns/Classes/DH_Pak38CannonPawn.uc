//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_Pak38CannonPawn extends DHATGunCannonPawn;

defaultproperties
{
    //Gun Class
    GunClass=class'DH_Guns.DH_Pak38Cannon'

    //Driver's position and animations
    DriverPositions(0)=(ViewLocation=(X=25.0,Y=-23.0,Z=3.0),ViewFOV=25.0,PositionMesh=SkeletalMesh'DH_Pak38_anm.Pak38_turret',TransitionUpAnim=none,DriverTransitionAnim="crouch_idle_binoc",ViewPitchUpLimit=4005,ViewPitchDownLimit=64623,ViewPositiveYawLimit=5825,ViewNegativeYawLimit=-5825,bDrawOverlays=true,bExposed=true)
    DriverPositions(1)=(ViewLocation=(X=0.0,Y=0.0,Z=5.0),PositionMesh=SkeletalMesh'DH_Pak38_anm.Pak38_turret',TransitionDownAnim=none,DriverTransitionAnim="crouch_idle_binoc",ViewPitchUpLimit=6000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=20000,ViewNegativeYawLimit=-20000,bExposed=true)
    DriverPositions(2)=(ViewLocation=(X=0.0,Y=0.0,Z=5.0),ViewFOV=12.0,PositionMesh=SkeletalMesh'DH_Pak38_anm.Pak38_turret',DriverTransitionAnim="crouch_idleiron_binoc",ViewPitchUpLimit=6000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=20000,ViewNegativeYawLimit=-20000,bDrawOverlays=true,bExposed=true)

    BinocPositionIndex=2
    DrivePos=(X=-10.0,Y=1.0,Z=5.0)
    DriveAnim="crouch_idle_binoc"

    //Gunsight
    GunsightOverlay=Texture'DH_VehicleOptics_tex.German.ZF_II_3x8_Pak'
    GunsightSize=0.32 // 8 degrees visible FOV at 3x magnification (ZF 3x8 Pak sight)

    //HUD
    AmmoShellTexture=Texture'InterfaceArt_tex.Tank_Hud.Panzer3shell'
    AmmoShellReloadTexture=Texture'InterfaceArt_tex.Tank_Hud.Panzer3shell_reload'
}

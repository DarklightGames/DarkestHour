//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_M116CannonPawn extends DHATGunCannonPawn;

defaultproperties
{
    GunClass=class'DH_Guns.DH_M116Cannon'

    // spotting scope
    DriverPositions(0)=(PositionMesh=SkeletalMesh'DH_M116_anm.m116_turret',DriverTransitionAnim="crouch_idle_binoc",TransitionUpAnim="optic_out",ViewFOV=40.0,ViewLocation=(X=10,Y=-16.0,Z=20.0),ViewPitchUpLimit=2731,ViewPitchDownLimit=64626,ViewPositiveYawLimit=6000,ViewNegativeYawLimit=-6000,bDrawOverlays=true,bExposed=true)
    // kneeling
    DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_M116_anm.m116_turret',DriverTransitionAnim="crouch_idle_binoc",TransitionUpAnim="com_open",TransitionDownAnim="optic_in",ViewPitchUpLimit=6000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=20000,ViewNegativeYawLimit=-20000,bExposed=true)
    // standing
    DriverPositions(2)=(PositionMesh=SkeletalMesh'DH_M116_anm.m116_turret',DriverTransitionAnim="stand_idlehip_binoc",TransitionDownAnim="com_close",ViewPitchUpLimit=6000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=20000,ViewNegativeYawLimit=-20000,bExposed=true)
    // binoculars
    DriverPositions(3)=(PositionMesh=SkeletalMesh'DH_M116_anm.m116_turret',DriverTransitionAnim="stand_idleiron_binoc",ViewFOV=12.0,ViewPitchUpLimit=6000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=20000,ViewNegativeYawLimit=-20000,bDrawOverlays=true,bExposed=true)

    CameraBone="gun" //changing here since we don't want pitch, only traverse/yaw of gunsight

    GunsightPositions=0
    UnbuttonedPositionIndex=0
    SpottingScopePositionIndex=0
    IntermediatePositionIndex=1 // the open sights position (used to play a special 'intermediate' firing anim in that position)
    RaisedPositionIndex=2
    BinocPositionIndex=3

    bLockCameraDuringTransition=true

    DrivePos=(X=0,Y=0.0,Z=60.0)
    DriveAnim="crouch_idle_binoc"

    GunsightOverlay=Texture'DH_VehicleOptics_tex.German.ZF_II_3x8_Pak'
    GunsightSize=0.282 // 8 degrees visible FOV at 3x magnification (ZF 3x8 Pak sight)

    OverlayCorrectionX=0
    OverlayCorrectionY=50

    AmmoShellTexture=Texture'DH_LeIG18_tex.HUD.leig18_he'   // TODO: swap it out
    AmmoShellReloadTexture=Texture'DH_LeIG18_tex.HUD.leig18_he_reload'
    ArtillerySpottingScopeClass=class'DH_Guns.DHArtillerySpottingScope_M116'
}

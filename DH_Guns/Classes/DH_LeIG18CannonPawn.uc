//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_LeIG18CannonPawn extends DHATGunCannonPawn;

defaultproperties
{
    GunClass=Class'DH_LeIG18Cannon'
    // spotting scope
    DriverPositions(0)=(PositionMesh=SkeletalMesh'DH_LeIG18_anm.leig18_turret',DriverTransitionAnim="crouch_idle_binoc",TransitionUpAnim="optic_out",ViewFOV=80.0,ViewLocation=(X=0.0,Y=-10.0,Z=40.0),ViewPitchUpLimit=2731,ViewPitchDownLimit=64626,ViewPositiveYawLimit=6000,ViewNegativeYawLimit=-6000,bDrawOverlays=true,bExposed=true)
    // kneeling
    DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_LeIG18_anm.leig18_turret',DriverTransitionAnim="crouch_idle_binoc",TransitionUpAnim="com_open",TransitionDownAnim="optic_in",ViewPitchUpLimit=6000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=20000,ViewNegativeYawLimit=-20000,bExposed=true)
    // standing
    DriverPositions(2)=(PositionMesh=SkeletalMesh'DH_LeIG18_anm.leig18_turret',DriverTransitionAnim="stand_idlehip_binoc",TransitionDownAnim="com_close",ViewPitchUpLimit=6000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=20000,ViewNegativeYawLimit=-20000,bExposed=true)
    // binoculars
    DriverPositions(3)=(PositionMesh=SkeletalMesh'DH_LeIG18_anm.leig18_turret',DriverTransitionAnim="stand_idleiron_binoc",ViewFOV=12.0,ViewPitchUpLimit=6000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=20000,ViewNegativeYawLimit=-20000,bDrawOverlays=true,bExposed=true)

    CameraBone="gun" //changing here since we don't want pitch, only traverse/yaw of gunsight

    GunsightPositions=0
    UnbuttonedPositionIndex=0
    SpottingScopePositionIndex=0
    IntermediatePositionIndex=1 // the open sights position (used to play a special 'intermediate' firing anim in that position)
    RaisedPositionIndex=2
    BinocPositionIndex=3

    DrivePos=(X=0,Y=0.0,Z=60.0)
    DriveAnim="crouch_idle_binoc"

    GunsightOverlay=none // spotting scope replaces gunsight
    GunsightSize=0

    OverlayCorrectionX=0
    OverlayCorrectionY=50

    AmmoShellTexture=Texture'DH_LeIG18_tex.leig18_he'
    AmmoShellReloadTexture=Texture'DH_LeIG18_tex.leig18_he_reload'
    ArtillerySpottingScopeClass=Class'DHArtillerySpottingScope_LeIG18'
}

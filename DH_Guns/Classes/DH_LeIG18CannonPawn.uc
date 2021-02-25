//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2021
//==============================================================================

class DH_LeIG18CannonPawn extends DHATGunCannonPawn;

defaultproperties
{
    // TODO: change all the yaw limits etc.
    GunClass=class'DH_Guns.DH_LeIG18Cannon'
    DriverPositions(0)=(PositionMesh=SkeletalMesh'DH_LeIG18_anm.leig18_turret',DriverTransitionAnim="crouch_idle_binoc",TransitionUpAnim="optic_out",ViewLocation=(X=0.0,Y=-10.0,Z=40.0),ViewFOV=80.0,bDrawOverlays=true,bExposed=true)
    DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_LeIG18_anm.leig18_turret',DriverTransitionAnim="crouch_idle_binoc",TransitionUpAnim="com_open",TransitionDownAnim="optic_in",bExposed=true)
    DriverPositions(2)=(PositionMesh=SkeletalMesh'DH_LeIG18_anm.leig18_turret',DriverTransitionAnim="stand_idlehip_binoc",TransitionDownAnim="com_close",ViewPitchUpLimit=6000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=20000,ViewNegativeYawLimit=-20000,bExposed=true)
    DriverPositions(3)=(PositionMesh=SkeletalMesh'DH_LeIG18_anm.leig18_turret',DriverTransitionAnim="stand_idleiron_binoc",ViewFOV=12.0,ViewPitchUpLimit=6000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=20000,ViewNegativeYawLimit=-20000,bDrawOverlays=true,bExposed=true)
    IntermediatePositionIndex=1 // the open sights position (used to play a special 'intermediate' firing anim in that position)
    CameraBone="turret" //changing here since we don't want pitch, only traverse/yaw of gunsight
    RaisedPositionIndex=2
    BinocPositionIndex=3
    DrivePos=(X=0,Y=0.0,Z=60.0)
    DriveAnim="crouch_idle_binoc"
    GunsightOverlay=Texture'DH_VehicleOptics_tex.German.RblF16_artillery_sight'   // TODO: REPLACE
    GunsightSize=0.47    // Rbl.F 16 panoramic sight 4x 10' FOV
    OverlayCorrectionX=-3
    AmmoShellTexture=Texture'DH_LeIG18_tex.HUD.leig18_he'
    AmmoShellReloadTexture=Texture'DH_LeIG18_tex.HUD.leig18_he_reload'
}

//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_Semovente4732CannonPawn extends DHAssaultGunCannonPawn;

defaultproperties
{
    GunClass=class'DH_Vehicles.DH_Semovente4732Cannon'
    DriverPositions(0)=(PositionMesh=SkeletalMesh'DH_Semovente4732_anm.semovente4732_turret_ext',ViewFOV=28.33,TransitionUpAnim="sight_out",bDrawOverlays=true,bExposed=true)
    DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_Semovente4732_anm.semovente4732_turret_ext',TransitionUpAnim="open",TransitionDownAnim="sight_in",DriverTransitionAnim="semo4732_gunner_close",ViewPitchUpLimit=16384,ViewPitchDownLimit=57344,bExposed=true)
    DriverPositions(2)=(PositionMesh=SkeletalMesh'DH_Semovente4732_anm.semovente4732_turret_ext',TransitionDownAnim="close",DriverTransitionAnim="semo4732_gunner_open",ViewPitchUpLimit=16384,ViewPitchDownLimit=57344,bDrawOverlays=true,bExposed=true)
    DriverPositions(3)=(PositionMesh=SkeletalMesh'DH_Semovente4732_anm.semovente4732_turret_ext',DriverTransitionAnim="semo4732_gunner_binocs",ViewPitchUpLimit=16384,ViewPitchDownLimit=57344,bDrawOverlays=true,bExposed=true)

    UnbuttonedPositionIndex=0
    InitialPositionIndex=0
    RaisedPositionIndex=2
    BinocPositionIndex=3

    DriveAnim="semo4732_gunner_closed"
    AmmoShellTexture=Texture'InterfaceArt_tex.Tank_Hud.Panzer3shell'
    AmmoShellReloadTexture=Texture'InterfaceArt_tex.Tank_Hud.Panzer3shell_reload'

    CameraBone="GUNSIGHT_CAMERA"
    PlayerCameraBone="CAMERA_COM"

    GunOpticsClass=class'DH_Vehicles.DH_Cannone4732Optics'
    
    // TODO: probably need a whole other sequence of anims here for the gunner?
    //DriveAnim=""    // HACK: This needs to be empty to prevent DHPawn from looping an animation from StartDriving.
    //AnimationDrivers(0)=(Type=ADT_Yaw,DriverPositionIndexRange=(Min=0,Max=1),Sequence="semo4732_gunner_yaw_driver",FrameCount=41,Channel=0)
    //AnimationDrivers(1)=(Type=ADT_Yaw,DriverPositionIndexRange=(Min=2,Max=2),Sequence="semo4732_gunner_stand_yaw_driver",FrameCount=41,Channel=2)

    DrivePos=(Z=58.0)
    DriveRot=(Pitch=0,Yaw=16384,Roll=0)
}

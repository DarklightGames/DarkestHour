//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_Cannone4732CannonPawn extends DHATGunCannonPawn;

defaultproperties
{
    GunClass=class'DH_Guns.DH_Cannone4732Cannon'
    DriverPositions(0)=(PositionMesh=SkeletalMesh'DH_Cannone4732_anm.cannone4732_turret',ViewFOV=28.33,TransitionUpAnim="com_sight_out",bDrawOverlays=true,bExposed=true)
    DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_Cannone4732_anm.cannone4732_turret',TransitionUpAnim="com_stand_in",TransitionDownAnim="com_sight_in",DriverTransitionAnim="cannone4732_gunner_close",ViewPitchUpLimit=16384,ViewPitchDownLimit=57344,bExposed=true)
    DriverPositions(2)=(PositionMesh=SkeletalMesh'DH_Cannone4732_anm.cannone4732_turret',TransitionDownAnim="com_stand_out",DriverTransitionAnim="cannone4732_gunner_open",ViewPitchUpLimit=16384,ViewPitchDownLimit=57344,bDrawOverlays=true,bExposed=true)
    DriverPositions(3)=(PositionMesh=SkeletalMesh'DH_Cannone4732_anm.cannone4732_turret',DriverTransitionAnim="cannone4732_gunner_binocs",ViewPitchUpLimit=16384,ViewPitchDownLimit=57344,bDrawOverlays=true,bExposed=true)

    InitialPositionIndex=0
    RaisedPositionIndex=2
    BinocPositionIndex=3

    DriveAnim="cannone4732_gunner_closed"
    AmmoShellTexture=Texture'InterfaceArt_tex.Tank_Hud.Panzer3shell'
    AmmoShellReloadTexture=Texture'InterfaceArt_tex.Tank_Hud.Panzer3shell_reload'
    CameraBone="camera_gun"

    GunOpticsClass=class'DH_Vehicles.DH_Cannone4732Optics'
    
    // DriveAnim="cannone4732_gunner_yaw"    // HACK: if this is set to "", the spine bone gets all fucked up. We should have a neutral pose here, probably.
    // AnimationDrivers(0)=(Type=ADT_Yaw,DriverPositionIndexRange=(Min=0,Max=1),Sequence="cannone4732_gunner_yaw",FrameCount=60,Channel=0)
    // AnimationDrivers(1)=(Type=ADT_Yaw,DriverPositionIndexRange=(Min=2,Max=2),Sequence="cannone4732_gunner_stand_yaw",FrameCount=60,Channel=2)

    DrivePos=(Z=28.0)
}

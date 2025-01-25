//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_Cannone4732CannonPawn extends DHATGunCannonPawn;

defaultproperties
{
    GunClass=class'DH_Guns.DH_Cannone4732Cannon'
    DriverPositions(0)=(PositionMesh=SkeletalMesh'DH_Cannone4732_anm.cannone4732_turret',ViewFOV=28.33,TransitionUpAnim="com_sight_out",DriverTransitionAnim="crouch_idle_binoc",bDrawOverlays=true,bExposed=true)
    DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_Cannone4732_anm.cannone4732_turret',TransitionUpAnim="com_stand_in",TransitionDownAnim="com_sight_in",DriverTransitionAnim="crouch_idle_binoc",ViewPitchUpLimit=16384,ViewPitchDownLimit=57344,bExposed=true)
    DriverPositions(2)=(PositionMesh=SkeletalMesh'DH_Cannone4732_anm.cannone4732_turret',TransitionDownAnim="com_stand_out",DriverTransitionAnim="stand_idlehip_binoc",ViewPitchUpLimit=16384,ViewPitchDownLimit=57344,bDrawOverlays=true,bExposed=true)
    DriverPositions(3)=(PositionMesh=SkeletalMesh'DH_Cannone4732_anm.cannone4732_turret',DriverTransitionAnim="stand_idleiron_binoc",ViewPitchUpLimit=16384,ViewPitchDownLimit=57344,bDrawOverlays=true,bExposed=true)

    //bLockCameraDuringTransition=true

    InitialPositionIndex=0
    RaisedPositionIndex=2
    BinocPositionIndex=3

    DriveAnim="cannone4732_gunner_yaw"    // HACK: if this is set to "", the spine bone gets all fucked up. We should have a neutral pose here, probably.
    AmmoShellTexture=Texture'InterfaceArt_tex.Tank_Hud.Panzer3shell'
    AmmoShellReloadTexture=Texture'InterfaceArt_tex.Tank_Hud.Panzer3shell_reload'
    CameraBone="camera_gun"

    GunOpticsClass=class'DH_Vehicles.DH_Cannone4732Optics'
    
    // AnimationDrivers(0)=(Type=ADT_Yaw,DriverPositionIndexRange=(Min=0,Max=1),Sequence="cannone4732_gunner_yaw",FrameCount=60,Channel=0)
    // AnimationDrivers(1)=(Type=ADT_Yaw,DriverPositionIndexRange=(Min=2,Max=2),Sequence="cannone4732_gunner_stand_yaw",FrameCount=60,Channel=2)

    DrivePos=(Z=28.0)
}

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

    DriveAnim="crouch_idle_binoc"
    AmmoShellTexture=Texture'InterfaceArt_tex.Tank_Hud.Panzer3shell'
    AmmoShellReloadTexture=Texture'InterfaceArt_tex.Tank_Hud.Panzer3shell_reload'
    CameraBone="camera_gun"

    GunOpticsClass=class'DH_Vehicles.DHGunOptics_Italian'
    ProjectileGunOpticRangeTableIndices(1)=1
    ProjectileGunOpticRangeTableIndices(2)=1
    
    AnimationDrivers(0)=(Type=ADT_Yaw,DriverPositionIndexRange=(Min=0,Max=1),Sequence="cannone4732_gunner_yaw",FrameCount=61)

    DrivePos=(Z=28.0)
}

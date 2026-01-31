//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_R35CannonPawn extends DHVehicleCannonPawn;

defaultproperties
{
    GunClass=Class'DH_R35Cannon'
    DriverPositions(0)=(ViewLocation=(X=12.0,Y=-9.5,Z=7.0),ViewFOV=28.33,PositionMesh=SkeletalMesh'DH_R35_anm.R35_TURRET_ITA_EXT',ViewPitchUpLimit=3641,ViewPitchDownLimit=63352,bDrawOverlays=true)
    DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_R35_anm.R35_TURRET_ITA_EXT',TransitionUpAnim="com_open",ViewPitchUpLimit=1,ViewPitchDownLimit=65535,ViewPositiveYawLimit=65536,ViewNegativeYawLimit=-65536,bDrawOverlays=true)
    DriverPositions(2)=(PositionMesh=SkeletalMesh'DH_R35_anm.R35_TURRET_ITA_EXT',TransitionDownAnim="com_close",DriverTransitionAnim="stand_idlehip_binoc",ViewPitchUpLimit=10000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=65536,ViewNegativeYawLimit=-65536,bExposed=true)
    DriverPositions(3)=(ViewFOV=12.0,PositionMesh=SkeletalMesh'DH_R35_anm.R35_TURRET_ITA_EXT',DriverTransitionAnim="stand_idleiron_binoc",ViewPitchUpLimit=10000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=65536,ViewNegativeYawLimit=-65536,bDrawOverlays=true,bExposed=true)
    PeriscopePositionIndex=1
    DrivePos=(X=8.0,Y=8.0,Z=-5.0)
    DriveAnim="stand_idlehip_binoc"
    GunsightOverlay=Texture'DH_VehicleOptics_tex.Stuart_sight_background'
    GunsightSize=0.435 // 12.3 degrees visible FOV at 3x magnification (M70D sight)
    DestroyedGunsightOverlay=Texture'DH_VehicleOpticsDestroyed_tex.Stuart_sight_destroyed'
    AmmoShellTexture=Texture'DH_InterfaceArt_tex.StuartShell'
    AmmoShellReloadTexture=Texture'DH_InterfaceArt_tex.StuartShell_reload'
    PoweredRotateSound=Sound'DH_AlliedVehicleSounds.ShermanTurretTraverse'
    PoweredPitchSound=Sound'Vehicle_Weapons.manual_turret_elevate'
    PoweredRotateAndPitchSound=Sound'DH_AlliedVehicleSounds.ShermanTurretTraverse'
    FireImpulse=(X=-30000.0)
    CameraBone="GUNSIGHT_CAMERA"
    // TODO: replace this when we add a proper camera
    PlayerCameraBone="GUNSIGHT_CAMERA"
    bManualTraverseOnly=true
}

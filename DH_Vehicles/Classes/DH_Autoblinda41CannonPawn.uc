//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_Autoblinda41CannonPawn extends DHVehicleCannonPawn;

defaultproperties
{
    GunClass=Class'DH_Autoblinda41Cannon'
    
    // Gunsight
    DriverPositions(0)=(PositionMesh=SkeletalMesh'DH_FiatL640_anm.fiatl640_turret_int',ViewFOV=24.0,TransitionUpAnim="gunsight_out",ViewPitchUpLimit=6000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=19000,ViewNegativeYawLimit=-20000,bDrawOverlays=true)
    // Periscope
    DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_FiatL640_anm.fiatl640_turret_int',ViewFOV=40.0,TransitionDownAnim="gunsight_in",TransitionUpAnim="open",ViewPitchUpLimit=2366,ViewPitchDownLimit=63170,ViewPositiveYawLimit=6000,ViewNegativeYawLimit=-10000,bDrawOverlays=true,DriverTransitionAnim="fiatl640_gunner_close")
    // Exposed
    DriverPositions(2)=(PositionMesh=SkeletalMesh'DH_FiatL640_anm.fiatl640_turret_int',TransitionDownAnim="close",ViewPitchUpLimit=5000,ViewPitchDownLimit=60000,ViewPositiveYawLimit=10000,ViewNegativeYawLimit=-10000,bExposed=true,DriverTransitionAnim="fiatl640_gunner_open")
    // Binocs
    DriverPositions(3)=(PositionMesh=SkeletalMesh'DH_FiatL640_anm.fiatl640_turret_int',ViewFOV=12.0,ViewPitchUpLimit=5000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=10000,ViewNegativeYawLimit=-10000,bDrawOverlays=true,bExposed=true,DriverTransitionAnim="fiatl640_gunner_binocs")
    
    bManualTraverseOnly=true
    DrivePos=(X=0.0,Y=0.0,Z=58.0)
    DriveRot=(Yaw=16384)
    DriveAnim="fiatl640_gunner_closed"
    bLockCameraDuringTransition=true
    GunsightOverlay=Texture'DH_VehicleOptics_tex.20mmBreda_sight_background'
    GunsightSize=0.3
    OverlayCorrectionX=-4.0
    OverlayCorrectionY=12.0
    DestroyedGunsightOverlay=Texture'DH_VehicleOpticsDestroyed_tex.PZ3_sight_destroyed'  // TODO: we need one made, or do it programmatically
    BinocPositionIndex=3
    AmmoShellTexture=Texture'DH_FiatL640_tex.breda2065_ammo_icon'
    AmmoShellReloadTexture=Texture'DH_FiatL640_tex.breda2065_ammo_reload'
    FireImpulse=(X=-5000.0)
    FPCamPos=(X=0,Y=0,Z=0)
    CameraBone="GUN_CAMERA"
    UnbuttonedPositionIndex=0

    // Periscope
    PeriscopeCameraBone="PERISCOPE_CAMERA"
    PeriscopeOverlay=Texture'DH_VehicleOptics_tex.MG_sight'
    PeriscopeSize=0.65
    PeriscopePositionIndex=1
}

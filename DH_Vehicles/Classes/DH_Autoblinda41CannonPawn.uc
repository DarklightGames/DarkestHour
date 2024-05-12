//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_Autoblinda41CannonPawn extends DHVehicleCannonPawn;

defaultproperties
{
    GunClass=class'DH_Vehicles.DH_Autoblinda41Cannon'
    
    // Gunsight
    DriverPositions(0)=(PositionMesh=SkeletalMesh'DH_FiatL640_anm.fiatl640_turret_int',ViewFOV=24.0,TransitionUpAnim="gunsight_out",ViewPitchUpLimit=6000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=19000,ViewNegativeYawLimit=-20000,bDrawOverlays=true)
    // Neutral
    DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_FiatL640_anm.fiatl640_turret_int',ViewFOV=90.0,TransitionUpAnim="periscope_in",TransitionDownAnim="gunsight_in",ViewPitchUpLimit=2366,ViewPitchDownLimit=63170,ViewPositiveYawLimit=6000,ViewNegativeYawLimit=-10000,bDrawOverlays=false)
    // Periscope
    DriverPositions(2)=(PositionMesh=SkeletalMesh'DH_FiatL640_anm.fiatl640_turret_int',ViewFOV=40.0,TransitionDownAnim="periscope_out",TransitionUpAnim="open",ViewPitchUpLimit=2366,ViewPitchDownLimit=63170,ViewPositiveYawLimit=6000,ViewNegativeYawLimit=-10000,bDrawOverlays=true,DriverTransitionAnim="fiatl640_gunner_close")
    // Exposed
    DriverPositions(3)=(PositionMesh=SkeletalMesh'DH_FiatL640_anm.fiatl640_turret_int',ViewFOV=90.0,TransitionDownAnim="close",ViewPitchUpLimit=5000,ViewPitchDownLimit=60000,ViewPositiveYawLimit=10000,ViewNegativeYawLimit=-10000,bExposed=true,DriverTransitionAnim="fiatl640_gunner_open")
    // Binocs
    DriverPositions(4)=(PositionMesh=SkeletalMesh'DH_FiatL640_anm.fiatl640_turret_int',ViewFOV=12.0,ViewPitchUpLimit=5000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=10000,ViewNegativeYawLimit=-10000,bDrawOverlays=true,bExposed=true,DriverTransitionAnim="fiatl640_gunner_binocs")
    
    bManualTraverseOnly=true
    DrivePos=(X=0.0,Y=0.0,Z=58.0)
    DriveRot=(Yaw=16384)
    DriveAnim="fiatl640_gunner_closed"
    bLockCameraDuringTransition=true
    GunsightOverlay=Texture'DH_VehicleOptics_tex.Italian.20mmBreda_sight_background'
    GunsightSize=0.3
    OverlayCorrectionX=-4.0
    DestroyedGunsightOverlay=Texture'DH_VehicleOpticsDestroyed_tex.German.PZ3_sight_destroyed'  // TODO: we need one made.
    BinocPositionIndex=4
    AmmoShellTexture=Texture'InterfaceArt_tex.Tank_Hud.Panzer3shell'
    AmmoShellReloadTexture=Texture'InterfaceArt_tex.Tank_Hud.Panzer3shell_reload'
    FireImpulse=(X=-7500.0)
    FPCamPos=(X=0,Y=0,Z=0)
    CameraBone="GUN_CAMERA"
    UnbuttonedPositionIndex=3

    // Periscope
    PeriscopeCameraBone="PERISCOPE_CAMERA"
    PeriscopeOverlay=Texture'DH_VehicleOptics_tex.General.MG_sight'
    PeriscopeSize=0.65
    PeriscopePositionIndex=2
}

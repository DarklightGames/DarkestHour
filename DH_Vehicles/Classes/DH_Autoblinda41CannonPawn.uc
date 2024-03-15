//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_Autoblinda41CannonPawn extends DHVehicleCannonPawn;

defaultproperties
{
    GunClass=class'DH_Vehicles.DH_Autoblinda41Cannon'
    DriverPositions(0)=(PositionMesh=SkeletalMesh'DH_FiatL640_anm.fiatl640_turret_ext',ViewFOV=34.0,ViewPitchUpLimit=6000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=19000,ViewNegativeYawLimit=-20000,bDrawOverlays=true)
    DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_FiatL640_anm.fiatl640_turret_ext',ViewFOV=40.0,TransitionUpAnim="com_open",ViewPitchUpLimit=0,ViewPitchDownLimit=65536,ViewPositiveYawLimit=6000,ViewNegativeYawLimit=-10000,bDrawOverlays=true)
    DriverPositions(2)=(PositionMesh=SkeletalMesh'DH_FiatL640_anm.fiatl640_turret_ext',TransitionDownAnim="com_close",DriverTransitionAnim="stand_idlehip_binoc",ViewPitchUpLimit=5000,ViewPitchDownLimit=60000,ViewPositiveYawLimit=10000,ViewNegativeYawLimit=-10000,bExposed=true)
    DriverPositions(3)=(PositionMesh=SkeletalMesh'DH_FiatL640_anm.fiatl640_turret_ext',ViewFOV=12.0,DriverTransitionAnim="stand_idleiron_binoc",ViewPitchUpLimit=5000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=10000,ViewNegativeYawLimit=-10000,bDrawOverlays=true,bExposed=true)
    
    bManualTraverseOnly=true
    DrivePos=(X=0.0,Y=2.0,Z=-30.0)
    DriveAnim="stand_idlehip_binoc"
    bLockCameraDuringTransition=true
    CannonScopeCenter=Texture'DH_VehicleOptics_tex.German.PZ3_sight_graticule'
    GunsightSize=0.735 // 25 degrees visible FOV at 2.5x magnification (TZF4b sight)
    DestroyedGunsightOverlay=Texture'DH_VehicleOpticsDestroyed_tex.German.PZ3_sight_destroyed'

    AmmoShellTexture=Texture'InterfaceArt_tex.Tank_Hud.Panzer3shell'
    AmmoShellReloadTexture=Texture'InterfaceArt_tex.Tank_Hud.Panzer3shell_reload'
    FireImpulse=(X=-7500.0)
    FPCamPos=(X=0,Y=0,Z=0)
    CameraBone="GUN_CAMERA"

    // Periscope
    PeriscopeCameraBone="PERISCOPE_CAMERA"
    PeriscopeOverlay=Texture'DH_VehicleOptics_tex.General.MG_sight'
    PeriscopeSize=0.65
    PeriscopePositionIndex=1

}

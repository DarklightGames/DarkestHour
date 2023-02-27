//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_Sdkfz2342CannonPawn extends DHGermanCannonPawn;

defaultproperties
{
    GunClass=class'DH_Vehicles.DH_Sdkfz2342Cannon'
    DriverPositions(0)=(ViewLocation=(X=30.0,Y=-14.0),ViewFOV=34.0,PositionMesh=SkeletalMesh'DH_Sdkfz234ArmoredCar_anm.Puma_turret_ext',ViewPitchUpLimit=6000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=19000,ViewNegativeYawLimit=-20000,bDrawOverlays=true)
    DriverPositions(1)=(ViewLocation=(X=16.0,Y=-2.5,Z=14.0),PositionMesh=SkeletalMesh'DH_Sdkfz234ArmoredCar_anm.Puma_turret_ext',TransitionUpAnim="com_open",ViewPitchUpLimit=0,ViewPitchDownLimit=65536,ViewPositiveYawLimit=6000,ViewNegativeYawLimit=-10000,bDrawOverlays=true)
    DriverPositions(2)=(PositionMesh=SkeletalMesh'DH_Sdkfz234ArmoredCar_anm.Puma_turret_ext',TransitionDownAnim="com_close",DriverTransitionAnim="stand_idlehip_binoc",ViewPitchUpLimit=5000,ViewPitchDownLimit=60000,ViewPositiveYawLimit=10000,ViewNegativeYawLimit=-10000,bExposed=true)
    DriverPositions(3)=(ViewFOV=12.0,PositionMesh=SkeletalMesh'DH_Sdkfz234ArmoredCar_anm.Puma_turret_ext',DriverTransitionAnim="stand_idleiron_binoc",ViewPitchUpLimit=5000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=10000,ViewNegativeYawLimit=-10000,bDrawOverlays=true,bExposed=true)
    PeriscopePositionIndex=1
    bManualTraverseOnly=true
    DrivePos=(X=0.0,Y=2.0,Z=-30.0)
    DriveAnim="stand_idlehip_binoc"
    bLockCameraDuringTransition=true
    CannonScopeCenter=Texture'DH_VehicleOptics_tex.German.PZ3_sight_graticule'
    GunsightSize=0.735 // 25 degrees visible FOV at 2.5x magnification (TZF4b sight)
    RangeRingRotator=TexRotator'DH_VehicleOptics_tex.German.PZ3_Sight_Center'
    RangeRingRotationFactor=985
    DestroyedGunsightOverlay=Texture'DH_VehicleOpticsDestroyed_tex.German.PZ3_sight_destroyed'
    PeriscopeOverlay=Texture'DH_VehicleOptics_tex.General.PERISCOPE_overlay_German'
    AmmoShellTexture=Texture'InterfaceArt_tex.Tank_Hud.Panzer3shell'
    AmmoShellReloadTexture=Texture'InterfaceArt_tex.Tank_Hud.Panzer3shell_reload'
    FireImpulse=(X=-15000.0)
}

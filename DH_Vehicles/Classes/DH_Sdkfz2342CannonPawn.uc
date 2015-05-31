//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_Sdkfz2342CannonPawn extends DHGermanTankCannonPawn;

defaultproperties
{
    PeriscopeOverlay=texture'DH_VehicleOptics_tex.German.PERISCOPE_overlay_German'
    ScopeCenterScale=0.635
    ScopeCenterRotator=TexRotator'DH_VehicleOptics_tex.German.PZ3_Sight_Center'
    CenterRotationFactor=985
    OverlayCenterSize=0.83
    PeriscopePositionIndex=1
    DestroyedScopeOverlay=texture'DH_VehicleOpticsDestroyed_tex.German.PZ3_sight_destroyed'
    bManualTraverseOnly=true
    CannonScopeCenter=texture'DH_VehicleOptics_tex.German.PZ3_sight_graticule'
    ScopePositionX=0.237
    ScopePositionY=0.15
    bLockCameraDuringTransition=true
    WeaponFOV=30.0
    AmmoShellTexture=texture'InterfaceArt_tex.Tank_Hud.Panzer3shell'
    AmmoShellReloadTexture=texture'InterfaceArt_tex.Tank_Hud.Panzer3shell_reload'
    DriverPositions(0)=(ViewLocation=(X=30.0,Y=-14.0),ViewFOV=30.0,PositionMesh=SkeletalMesh'DH_Sdkfz234ArmoredCar_anm.Puma_turret_ext',ViewPitchUpLimit=6000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=19000,ViewNegativeYawLimit=-20000,bDrawOverlays=true)
    DriverPositions(1)=(ViewLocation=(X=16.0,Y=-2.5,Z=14.0),ViewFOV=90.0,PositionMesh=SkeletalMesh'DH_Sdkfz234ArmoredCar_anm.Puma_turret_ext',TransitionUpAnim="com_open",DriverTransitionAnim="VPanzer3_com_close",ViewPitchUpLimit=0,ViewPitchDownLimit=65536,ViewPositiveYawLimit=6000,ViewNegativeYawLimit=-10000,bDrawOverlays=true)
    DriverPositions(2)=(ViewFOV=90.0,PositionMesh=SkeletalMesh'DH_Sdkfz234ArmoredCar_anm.Puma_turret_ext',TransitionDownAnim="com_close",DriverTransitionAnim="VPanzer3_com_open",ViewPitchUpLimit=5000,ViewPitchDownLimit=60000,ViewPositiveYawLimit=10000,ViewNegativeYawLimit=-10000,bExposed=true)
    DriverPositions(3)=(ViewFOV=12.0,PositionMesh=SkeletalMesh'DH_Sdkfz234ArmoredCar_anm.Puma_turret_ext',ViewPitchUpLimit=5000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=10000,ViewNegativeYawLimit=-10000,bDrawOverlays=true,bExposed=true)
    bMustBeTankCrew=false
    FireImpulse=(X=-15000.0)
    GunClass=class'DH_Vehicles.DH_Sdkfz2342Cannon'
    CameraBone="Gun"
    DrivePos=(X=4.0,Z=-8.0)
    DriveAnim="VPanzer3_com_idle_close"
    EntryRadius=130.0
    PitchUpLimit=6000
    PitchDownLimit=64000
    SoundVolume=130
}

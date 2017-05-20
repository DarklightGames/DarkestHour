//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_Sdkfz2341CannonPawn extends DHGermanCannonPawn;

defaultproperties
{
    RangeRingScale=0.499
    RangeRingRotator=TexRotator'DH_VehicleOptics_tex.German.20mmFlak_sight_center'
    RangeRingRotationFactor=2048
    GunsightSize=0.73333
    UnbuttonedPositionIndex=2
    DestroyedGunsightOverlay=texture'DH_VehicleOpticsDestroyed_tex.German.PZ4_sight_destroyed'
    bManualTraverseOnly=true
    CannonScopeCenter=texture'DH_VehicleOptics_tex.German.tiger_sight_graticule'
    BinocPositionIndex=3
    AmmoShellTexture=texture'DH_InterfaceArt_tex.Tank_Hud.2341Mag'
    AmmoShellReloadTexture=texture'DH_InterfaceArt_tex.Tank_Hud.2341Mag_reload'
    DriverPositions(0)=(ViewLocation=(X=40.0,Y=12.0,Z=3.0),ViewFOV=30.0,PositionMesh=SkeletalMesh'DH_Sdkfz234ArmoredCar_anm.Sdkfz234_turret_ext',ViewPitchUpLimit=12743,ViewPitchDownLimit=64443,bDrawOverlays=true,bExposed=true)
    DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_Sdkfz234ArmoredCar_anm.Sdkfz234_turret_ext',TransitionUpAnim="com_open",ViewPitchUpLimit=10000,ViewPitchDownLimit=62000,ViewPositiveYawLimit=10000,ViewNegativeYawLimit=-10000,bExposed=true)
    DriverPositions(2)=(PositionMesh=SkeletalMesh'DH_Sdkfz234ArmoredCar_anm.Sdkfz234_turret_ext',TransitionDownAnim="com_close",DriverTransitionAnim="stand_idlehip_binoc",ViewPitchUpLimit=10000,ViewPitchDownLimit=62000,ViewPositiveYawLimit=10000,ViewNegativeYawLimit=-10000,bExposed=true)
    DriverPositions(3)=(ViewFOV=12.0,PositionMesh=SkeletalMesh'DH_Sdkfz234ArmoredCar_anm.Sdkfz234_turret_ext',DriverTransitionAnim="stand_idleiron_binoc",ViewPitchUpLimit=10000,ViewPitchDownLimit=62000,ViewPositiveYawLimit=10000,ViewNegativeYawLimit=-10000,bDrawOverlays=true,bExposed=true)
    bMustBeTankCrew=true
    FireImpulse=(X=-15000.0)
    GunClass=class'DH_Vehicles.DH_Sdkfz2341Cannon'
    bHasFireImpulse=false
    DrivePos=(X=9.0,Y=1.0,Z=-6.0)
    DriveAnim="stand_idlehip_binoc"
}

//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_PanzerIIINCannonPawn extends DHGermanCannonPawn;

defaultproperties
{
    GunClass=class'DH_Vehicles.DH_PanzerIIINCannon'
    DriverPositions(0)=(ViewLocation=(X=12.0,Y=-27.0,Z=3.0),ViewFOV=34.0,PositionMesh=SkeletalMesh'DH_Panzer3_anm.Panzer3n_turret_int',ViewPitchUpLimit=3641,ViewPitchDownLimit=64080,ViewPositiveYawLimit=19000,ViewNegativeYawLimit=-20000,bDrawOverlays=true)
    DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_Panzer3_anm.Panzer3n_turret_int',TransitionUpAnim="com_open",DriverTransitionAnim="VKV1_com_close",ViewPitchUpLimit=5000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=6000,ViewNegativeYawLimit=-10000)
    DriverPositions(2)=(PositionMesh=SkeletalMesh'DH_Panzer3_anm.Panzer3n_turret_int',TransitionDownAnim="com_close",DriverTransitionAnim="VKV1_com_open",ViewPitchUpLimit=5000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=10000,ViewNegativeYawLimit=-10000,bExposed=true)
    DriverPositions(3)=(ViewFOV=12.0,PositionMesh=SkeletalMesh'DH_Panzer3_anm.Panzer3n_turret_int',DriverTransitionAnim="stand_idleiron_binoc",ViewPitchUpLimit=5000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=10000,ViewNegativeYawLimit=-10000,bDrawOverlays=true,bExposed=true)
    bManualTraverseOnly=true
    DrivePos=(X=3.0,Y=0.0,Z=-6.0)
    DriveAnim="VKV1_com_idle_close"
    CannonScopeCenter=Texture'DH_VehicleOptics_tex.German.PZ3_sight_graticule'
    GunsightSize=0.735 // 25 degrees visible FOV at 2.5x magnification
    RangeRingRotator=TexRotator'DH_VehicleOptics_tex.German.PZ4_sight_Center'
    RangeRingRotationFactor=985
    DestroyedGunsightOverlay=Texture'DH_VehicleOpticsDestroyed_tex.German.PZ4_sight_destroyed'
    AmmoShellTexture=Texture'DH_InterfaceArt_tex.Tank_Hud.Panzer3shell'
    AmmoShellReloadTexture=Texture'DH_InterfaceArt_tex.Tank_Hud.Panzer3shell_reload'
}

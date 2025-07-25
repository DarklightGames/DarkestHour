//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_PanzerIIILCannonPawn extends DHGermanCannonPawn;

defaultproperties
{
    GunClass=Class'DH_PanzerIIILCannon'
    DriverPositions(0)=(ViewLocation=(X=30.0,Y=-22.0,Z=1.5),ViewFOV=34.0,PositionMesh=SkeletalMesh'DH_Panzer3_anm.Panzer3L_turret_int',ViewPitchUpLimit=3641,ViewPitchDownLimit=63715,ViewPositiveYawLimit=19000,ViewNegativeYawLimit=-20000,bDrawOverlays=true)
    DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_Panzer3_anm.Panzer3L_turret_int',TransitionUpAnim="com_open",DriverTransitionAnim="VPanzer3_com_close",ViewPitchUpLimit=5000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=6000,ViewNegativeYawLimit=-10000)
    DriverPositions(2)=(PositionMesh=SkeletalMesh'DH_Panzer3_anm.Panzer3L_turret_int',TransitionDownAnim="com_close",DriverTransitionAnim="VPanzer3_com_open",ViewPitchUpLimit=5000,ViewPitchDownLimit=60000,ViewPositiveYawLimit=10000,ViewNegativeYawLimit=-10000,bExposed=true)
    DriverPositions(3)=(ViewFOV=12.0,PositionMesh=SkeletalMesh'DH_Panzer3_anm.Panzer3L_turret_int',DriverTransitionAnim="stand_idleiron_binoc",ViewPitchUpLimit=5000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=10000,ViewNegativeYawLimit=-10000,bDrawOverlays=true,bExposed=true)
    bManualTraverseOnly=true
    DrivePos=(X=2.0,Y=0.0,Z=0.0)
    DriveAnim="VPanzer3_com_idle_close"
    CannonScopeCenter=Texture'DH_VehicleOptics_tex.PZ3_sight_graticule'
    GunsightSize=0.735 // 25 degrees visible FOV at 2.5x magnification
    RangeRingRotator=TexRotator'DH_VehicleOptics_tex.PZ3_Sight_Center'
    RangeRingRotationFactor=985
    DestroyedGunsightOverlay=Texture'DH_VehicleOpticsDestroyed_tex.PZ3_sight_destroyed'
    AmmoShellTexture=Texture'InterfaceArt_tex.Panzer3shell'
    AmmoShellReloadTexture=Texture'InterfaceArt_tex.Panzer3shell_reload'
    FireImpulse=(X=-80000.0)
}

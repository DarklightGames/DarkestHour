//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_ShermanCannonPawn_M4A3105 extends DHAmericanCannonPawn;

defaultproperties
{
    GunClass=class'DH_Vehicles.DH_ShermanCannon_M4A3105'
    DriverPositions(0)=(ViewLocation=(X=25.0,Y=18.0,Z=2.0),ViewFOV=24.0,PositionMesh=SkeletalMesh'DH_ShermanM4A3_anm.shermanM4A3105_turret_int',TransitionUpAnim="Periscope_in",ViewPitchUpLimit=4551,ViewPitchDownLimit=63715,ViewPositiveYawLimit=19000,ViewNegativeYawLimit=-20000,bDrawOverlays=true)
    DriverPositions(1)=(ViewFOV=90.0,PositionMesh=SkeletalMesh'DH_ShermanM4A3_anm.shermanM4A3105_turret_int',TransitionUpAnim="periscope_out",ViewPitchUpLimit=1,ViewPitchDownLimit=65535,ViewPositiveYawLimit=65536,ViewNegativeYawLimit=-65536,bDrawOverlays=true)
    DriverPositions(2)=(ViewFOV=90.0,PositionMesh=SkeletalMesh'DH_ShermanM4A3_anm.shermanM4A3105_turret_int',TransitionUpAnim="com_open",TransitionDownAnim="Periscope_in",ViewPitchUpLimit=1,ViewPitchDownLimit=65535,ViewPositiveYawLimit=65536,ViewNegativeYawLimit=-65536)
    DriverPositions(3)=(ViewFOV=90.0,PositionMesh=SkeletalMesh'DH_ShermanM4A3_anm.shermanM4A3105_turret_int',TransitionDownAnim="com_close",DriverTransitionAnim="stand_idlehip_binoc",ViewPitchUpLimit=10000,ViewPitchDownLimit=65535,ViewPositiveYawLimit=10000,ViewNegativeYawLimit=-10000,bExposed=true)
    DriverPositions(4)=(ViewFOV=12.0,PositionMesh=SkeletalMesh'DH_ShermanM4A3_anm.shermanM4A3105_turret_int',DriverTransitionAnim="stand_idleiron_binoc",ViewPitchUpLimit=10000,ViewPitchDownLimit=62500,ViewPositiveYawLimit=10000,ViewNegativeYawLimit=-10000,bDrawOverlays=true,bExposed=true)
    PeriscopePositionIndex=1
    BinocPositionIndex=4
    UnbuttonedPositionIndex=3
    DrivePos=(X=3.0,Y=2.5,Z=4.5)
    DriveAnim="stand_idlehip_binoc"
    bManualTraverseOnly=true
    CannonScopeOverlay=texture'DH_VehicleOptics_tex.Allied.sherman105_sight_background'
    OverlayCenterSize=0.542
    DestroyedScopeOverlay=texture'DH_VehicleOpticsDestroyed_tex.Allied.Sherman_sight_destroyed'
    AmmoShellTexture=texture'DH_InterfaceArt_tex.Tank_Hud.Sherman105Shell'
    AmmoShellReloadTexture=texture'DH_InterfaceArt_tex.Tank_Hud.Sherman105Shell_reload'
    FireImpulse=(X=-110000.0)
}

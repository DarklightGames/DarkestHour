//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_Tiger2BCannonPawn extends DHGermanCannonPawn;

defaultproperties
{
    GunClass=class'DH_Vehicles.DH_Tiger2BCannon'
    DriverPositions(0)=(ViewLocation=(Y=-27.0),ViewFOV=14.4,PositionMesh=SkeletalMesh'DH_Tiger2B_anm.tiger2B_turret_int',ViewPitchUpLimit=2731,ViewPitchDownLimit=64189,ViewPositiveYawLimit=19000,ViewNegativeYawLimit=-20000,bDrawOverlays=true)
    DriverPositions(1)=(ViewLocation=(Y=-27.0),ViewFOV=28.8,PositionMesh=SkeletalMesh'DH_Tiger2B_anm.tiger2B_turret_int',ViewPitchUpLimit=2731,ViewPitchDownLimit=64189,ViewPositiveYawLimit=19000,ViewNegativeYawLimit=-20000,bDrawOverlays=true)
    DriverPositions(2)=(ViewFOV=90.0,PositionMesh=SkeletalMesh'DH_Tiger2B_anm.tiger2B_turret_int',TransitionUpAnim="com_open",DriverTransitionAnim="VPanther_com_close",ViewPitchUpLimit=5000,ViewPitchDownLimit=64000,ViewPositiveYawLimit=6000,ViewNegativeYawLimit=-10000)
    DriverPositions(3)=(ViewFOV=90.0,PositionMesh=SkeletalMesh'DH_Tiger2B_anm.tiger2B_turret_int',TransitionDownAnim="com_close",DriverTransitionAnim="VPanther_com_open",ViewPitchUpLimit=10000,ViewPitchDownLimit=64000,ViewPositiveYawLimit=6000,ViewNegativeYawLimit=-10000,bExposed=true)
    DriverPositions(4)=(ViewFOV=12.0,PositionMesh=SkeletalMesh'DH_Tiger2B_anm.tiger2B_turret_int',DriverTransitionAnim="stand_idleiron_binoc",ViewPitchUpLimit=10000,ViewPitchDownLimit=64000,ViewPositiveYawLimit=6000,ViewNegativeYawLimit=-10000,bDrawOverlays=true,bExposed=true)
    GunsightPositions=2
    UnbuttonedPositionIndex=3
    BinocPositionIndex=4
    DrivePos=(X=1.0,Y=6.0,Z=6.0)
    DriveAnim="VPanther_com_idle_close"
    CannonScopeCenter=texture'DH_VehicleOptics_tex.German.tiger_sight_graticule'
    OverlayCenterSize=0.87
    ScopeCenterScale=0.715
    ScopeCenterRotator=TexRotator'DH_VehicleOptics_tex.German.tiger2B_sight_center'
    CenterRotationFactor=502
    DestroyedScopeOverlay=texture'DH_VehicleOpticsDestroyed_tex.German.tiger_sight_destroyed'
    AmmoShellTexture=texture'DH_InterfaceArt_tex.Tank_Hud.KingTigerShell'
    AmmoShellReloadTexture=texture'DH_InterfaceArt_tex.Tank_Hud.KingTigerShell_reload'
    PoweredRotateSound=sound'DH_GerVehicleSounds2.Tiger2B.tiger2B_turret_traverse_loop'
    PoweredPitchSound=sound'Vehicle_Weapons.Turret.manual_turret_travelevate'
    PoweredRotateAndPitchSound=sound'DH_GerVehicleSounds2.Tiger2B.tiger2B_turret_traverse_loop'
    FireImpulse=(X=-110000.0)
}

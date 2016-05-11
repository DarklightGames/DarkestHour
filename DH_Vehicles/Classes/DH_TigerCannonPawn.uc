//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_TigerCannonPawn extends DHGermanCannonPawn;

defaultproperties
{
    GunClass=class'DH_Vehicles.DH_TigerCannon'
    DriverPositions(0)=(ViewLocation=(X=35.0,Y=-32.0,Z=3.0),ViewFOV=28.8,PositionMesh=SkeletalMesh'DH_Tiger_anm.Tiger_turret_int',ViewPitchUpLimit=3095,ViewPitchDownLimit=64353,ViewPositiveYawLimit=19000,ViewNegativeYawLimit=-20000,bDrawOverlays=true)
    DriverPositions(1)=(ViewFOV=90.0,PositionMesh=SkeletalMesh'DH_Tiger_anm.Tiger_turret_int',TransitionUpAnim="com_open",DriverTransitionAnim="VTiger_com_close",ViewPitchUpLimit=5000,ViewPitchDownLimit=64000,ViewPositiveYawLimit=6000,ViewNegativeYawLimit=-10000)
    DriverPositions(2)=(ViewFOV=90.0,PositionMesh=SkeletalMesh'DH_Tiger_anm.Tiger_turret_int',TransitionDownAnim="com_close",DriverTransitionAnim="VTiger_com_open",ViewPitchUpLimit=10000,ViewPitchDownLimit=64000,ViewPositiveYawLimit=6000,ViewNegativeYawLimit=-10000,bExposed=true)
    DriverPositions(3)=(ViewFOV=12.0,PositionMesh=SkeletalMesh'DH_Tiger_anm.Tiger_turret_int',DriverTransitionAnim="stand_idleiron_binoc",ViewPitchUpLimit=10000,ViewPitchDownLimit=64000,ViewPositiveYawLimit=6000,ViewNegativeYawLimit=-10000,bDrawOverlays=true,bExposed=true)
    DriveAnim="VTiger_com_idle_close"
    CannonScopeCenter=texture'DH_VehicleOptics_tex.German.tiger_sight_graticule'
    OverlayCenterSize=0.87
    RangeRingScale=0.68
    RangeRingRotator=TexRotator'DH_VehicleOptics_tex.German.tiger_sight_center'
    RangeRingRotationFactor=820
    DestroyedGunsightOverlay=texture'DH_VehicleOpticsDestroyed_tex.German.tiger_sight_destroyed'
    AmmoShellTexture=texture'InterfaceArt_tex.Tank_Hud.Tigershell'
    AmmoShellReloadTexture=texture'InterfaceArt_tex.Tank_Hud.Tigershell_reload'
    PoweredRotateSound=sound'DH_GerVehicleSounds2.Tiger2B.tiger2B_turret_traverse_loop'
    PoweredPitchSound=sound'Vehicle_Weapons.Turret.manual_turret_travelevate'
    PoweredRotateAndPitchSound=sound'DH_GerVehicleSounds2.Tiger2B.tiger2B_turret_traverse_loop'
    FireImpulse=(X=-110000.0)
}

//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_TigerCannonPawn extends DHGermanCannonPawn;

defaultproperties
{
    GunClass=class'DH_Vehicles.DH_TigerCannon_Late'
    DriverPositions(0)=(ViewLocation=(X=35.0,Y=-32.0,Z=3.0),ViewFOV=30.0,PositionMesh=SkeletalMesh'DH_Tiger_anm.Tiger_turret_int',ViewPitchUpLimit=3095,ViewPitchDownLimit=64353,ViewPositiveYawLimit=19000,ViewNegativeYawLimit=-20000,bDrawOverlays=true)
    DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_Tiger_anm.Tiger_turret_int',TransitionUpAnim="com_open",DriverTransitionAnim="VTiger_com_close",ViewPitchUpLimit=5000,ViewPitchDownLimit=64000,ViewPositiveYawLimit=6000,ViewNegativeYawLimit=-10000)
    DriverPositions(2)=(PositionMesh=SkeletalMesh'DH_Tiger_anm.Tiger_turret_int',TransitionDownAnim="com_close",DriverTransitionAnim="VTiger_com_open",ViewPitchUpLimit=10000,ViewPitchDownLimit=64000,ViewPositiveYawLimit=6000,ViewNegativeYawLimit=-10000,bExposed=true)
    DriverPositions(3)=(ViewFOV=12.0,PositionMesh=SkeletalMesh'DH_Tiger_anm.Tiger_turret_int',DriverTransitionAnim="stand_idleiron_binoc",ViewPitchUpLimit=10000,ViewPitchDownLimit=64000,ViewPositiveYawLimit=6000,ViewNegativeYawLimit=-10000,bDrawOverlays=true,bExposed=true)
    DriveAnim="VTiger_com_idle_close"
    CannonScopeCenter=Texture'DH_VehicleOptics_tex.German.tiger_sight_graticule'
    GunsightSize=0.933 // 28 degrees visible FOV at 2.5x magnification (TZF9b sight)
    RangeRingRotator=TexRotator'DH_VehicleOptics_tex.German.tiger_sight_center'
    RangeRingScale=0.68
    RangeRingRotationFactor=820
    DestroyedGunsightOverlay=Texture'DH_VehicleOpticsDestroyed_tex.German.tiger_sight_destroyed'
    AmmoShellTexture=Texture'InterfaceArt_tex.Tank_Hud.Tigershell'
    AmmoShellReloadTexture=Texture'InterfaceArt_tex.Tank_Hud.Tigershell_reload'
    PoweredRotateSound=Sound'DH_GerVehicleSounds2.Tiger2B.tiger2B_turret_traverse_loop'
    PoweredPitchSound=Sound'Vehicle_Weapons.Turret.manual_turret_travelevate'
    PoweredRotateAndPitchSound=Sound'DH_GerVehicleSounds2.Tiger2B.tiger2B_turret_traverse_loop'
    FireImpulse=(X=-110000.0)
}

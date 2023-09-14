//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_ShermanCannonPawn_M4A3E2_Jumbo extends DHAmericanCannonPawn;

defaultproperties
{
    GunClass=class'DH_Vehicles.DH_ShermanCannon_M4A3E2_Jumbo'
    DriverPositions(0)=(ViewLocation=(X=24.0,Y=18.0,Z=2.0),ViewFOV=17.0,PositionMesh=SkeletalMesh'DH_ShermanM4A3_anm.ShermanM4A3E2_turret_int',ViewPitchUpLimit=4551,ViewPitchDownLimit=63715,ViewPositiveYawLimit=19000,ViewNegativeYawLimit=-20000,bDrawOverlays=true)
    DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_ShermanM4A3_anm.ShermanM4A3E2_turret_int',TransitionUpAnim="Periscope_in",ViewPitchUpLimit=1,ViewPitchDownLimit=65535,ViewPositiveYawLimit=65536,ViewNegativeYawLimit=-65536,bDrawOverlays=true)
    DriverPositions(2)=(PositionMesh=SkeletalMesh'DH_ShermanM4A3_anm.ShermanM4A3E2_turret_int',TransitionUpAnim="com_open",TransitionDownAnim="periscope_out",ViewPitchUpLimit=10000,ViewPitchDownLimit=65535,ViewPositiveYawLimit=10000,ViewNegativeYawLimit=-10000)
    DriverPositions(3)=(PositionMesh=SkeletalMesh'DH_ShermanM4A3_anm.ShermanM4A3E2_turret_int',TransitionDownAnim="com_close",DriverTransitionAnim="stand_idlehip_binoc",ViewPitchUpLimit=10000,ViewPitchDownLimit=62500,ViewPositiveYawLimit=10000,ViewNegativeYawLimit=-10000,bExposed=true)
    DriverPositions(4)=(ViewFOV=12.0,PositionMesh=SkeletalMesh'DH_ShermanM4A3_anm.ShermanM4A3E2_turret_int',DriverTransitionAnim="stand_idleiron_binoc",ViewPitchUpLimit=10000,ViewPitchDownLimit=62500,ViewPositiveYawLimit=10000,ViewNegativeYawLimit=-10000,bDrawOverlays=true,bExposed=true)
    PeriscopePositionIndex=1
    UnbuttonedPositionIndex=3
    BinocPositionIndex=4
    DrivePos=(X=6.0,Y=3.0,Z=0.0)
    DriveAnim="stand_idlehip_binoc"
    GunsightOverlay=Texture'DH_VehicleOptics_tex.US.Sherman_sight_background'
    GunsightSize=0.765 // 13 degrees visible FOV at 5x magnification (M71G sight)
    DestroyedGunsightOverlay=Texture'DH_VehicleOpticsDestroyed_tex.Allied.Sherman_sight_destroyed'
    AmmoShellTexture=Texture'DH_InterfaceArt_tex.Tank_Hud.ShermanShell'
    AmmoShellReloadTexture=Texture'DH_InterfaceArt_tex.Tank_Hud.ShermanShell_reload'
    PoweredRotateSound=Sound'DH_AlliedVehicleSounds.Sherman.ShermanTurretTraverse'
    PoweredPitchSound=Sound'Vehicle_Weapons.Turret.manual_turret_elevate'
    PoweredRotateAndPitchSound=Sound'DH_AlliedVehicleSounds.Sherman.ShermanTurretTraverse'
}

//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_ShermanCannonPawn_M4A3E2 extends DHAmericanTankCannonPawn;

defaultproperties
{
    OverlayCenterSize=0.542
    UnbuttonedPositionIndex=3
    DestroyedScopeOverlay=texture'DH_VehicleOpticsDestroyed_tex.Allied.Sherman_sight_destroyed'
    PoweredRotateSound=sound'DH_AlliedVehicleSounds.Sherman.ShermanTurretTraverse'
    PoweredPitchSound=sound'Vehicle_Weapons.Turret.manual_turret_elevate'
    PoweredRotateAndPitchSound=sound'DH_AlliedVehicleSounds.Sherman.ShermanTurretTraverse'
    CannonScopeOverlay=texture'DH_VehicleOptics_tex.Allied.Sherman_sight_background'
    BinocPositionIndex=4
    WeaponFOV=24.0
    AmmoShellTexture=texture'DH_InterfaceArt_tex.Tank_Hud.ShermanShell'
    AmmoShellReloadTexture=texture'DH_InterfaceArt_tex.Tank_Hud.ShermanShell_reload'
    DriverPositions(0)=(ViewLocation=(X=24.0,Y=18.0,Z=2.0),ViewFOV=24.0,PositionMesh=SkeletalMesh'DH_ShermanM4A3E2_anm.ShermanM4A3E2_turret_int',ViewPitchUpLimit=4551,ViewPitchDownLimit=63715,ViewPositiveYawLimit=19000,ViewNegativeYawLimit=-20000,bDrawOverlays=true)
    DriverPositions(1)=(ViewFOV=90.0,PositionMesh=SkeletalMesh'DH_ShermanM4A3E2_anm.ShermanM4A3E2_turret_int',TransitionUpAnim="Periscope_in",ViewPitchUpLimit=1,ViewPitchDownLimit=65535,ViewPositiveYawLimit=65536,ViewNegativeYawLimit=-65536,bDrawOverlays=true)
    DriverPositions(2)=(ViewFOV=90.0,PositionMesh=SkeletalMesh'DH_ShermanM4A3E2_anm.ShermanM4A3E2_turret_int',TransitionUpAnim="com_open",TransitionDownAnim="periscope_out",ViewPitchUpLimit=10000,ViewPitchDownLimit=65535,ViewPositiveYawLimit=10000,ViewNegativeYawLimit=-10000)
    DriverPositions(3)=(ViewFOV=90.0,PositionMesh=SkeletalMesh'DH_ShermanM4A3E2_anm.ShermanM4A3E2_turret_int',TransitionDownAnim="com_close",ViewPitchUpLimit=10000,ViewPitchDownLimit=62500,ViewPositiveYawLimit=10000,ViewNegativeYawLimit=-10000,bExposed=true)
    DriverPositions(4)=(ViewFOV=12.0,PositionMesh=SkeletalMesh'DH_ShermanM4A3E2_anm.ShermanM4A3E2_turret_int',DriverTransitionAnim="stand_idleiron_binoc",ViewPitchUpLimit=10000,ViewPitchDownLimit=62500,ViewPositiveYawLimit=10000,ViewNegativeYawLimit=-10000,bDrawOverlays=true,bExposed=true)
    FireImpulse=(X=-95000.0)
    GunClass=class'DH_Vehicles.DH_ShermanCannon_M4A3E2'
    CameraBone="Gun"
    DrivePos=(X=3.0,Z=8.0)
    DriveAnim="stand_idlehip_binoc"
    EntryRadius=130.0
    TPCamDistance=300.0
    TPCamLookat=(X=-25.0,Z=0.0)
    TPCamWorldOffset=(Z=120.0)
    PitchUpLimit=6000
    PitchDownLimit=64000
    SoundVolume=130
    PeriscopePositionIndex=1
}

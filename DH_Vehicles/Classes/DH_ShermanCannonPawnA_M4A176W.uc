//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_ShermanCannonPawnA_M4A176W extends DHAmericanTankCannonPawn;

defaultproperties
{
    OverlayCenterSize=0.972
    DestroyedScopeOverlay=texture'DH_VehicleOpticsDestroyed_tex.Allied.Wolverine_sight_destroyed'
    PoweredRotateSound=sound'DH_AlliedVehicleSounds.Sherman.ShermanTurretTraverse'
    PoweredPitchSound=sound'Vehicle_Weapons.Turret.manual_turret_elevate'
    PoweredRotateAndPitchSound=sound'DH_AlliedVehicleSounds.Sherman.ShermanTurretTraverse'
    CannonScopeOverlay=texture'DH_VehicleOptics_tex.Allied.Sherman76mm_sight_background'
    WeaponFOV=14.4
    AmmoShellTexture=texture'DH_InterfaceArt_tex.Tank_Hud.WolverineShell'
    AmmoShellReloadTexture=texture'DH_InterfaceArt_tex.Tank_Hud.WolverineShell_reload'
    DriverPositions(0)=(ViewLocation=(X=18.0,Y=20.0,Z=7.0),ViewFOV=14.4,PositionMesh=SkeletalMesh'DH_ShermanM4A176W_anm.shermanM4A1w_turret_extA',ViewPitchUpLimit=5461,ViewPitchDownLimit=63715,ViewPositiveYawLimit=19000,ViewNegativeYawLimit=-20000,bDrawOverlays=true)
    DriverPositions(1)=(ViewLocation=(Z=10.0),ViewFOV=90.0,PositionMesh=SkeletalMesh'DH_ShermanM4A176W_anm.shermanM4A1w_turret_extA',TransitionUpAnim="com_open",ViewPitchUpLimit=1,ViewPitchDownLimit=65535,ViewPositiveYawLimit=65536,ViewNegativeYawLimit=-65536,bDrawOverlays=true)
    DriverPositions(2)=(ViewLocation=(Z=4.0),ViewFOV=90.0,PositionMesh=SkeletalMesh'DH_ShermanM4A176W_anm.shermanM4A1w_turret_extA',TransitionDownAnim="com_close",DriverTransitionAnim="stand_idlehip_binoc",ViewPitchUpLimit=10000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=10000,ViewNegativeYawLimit=-10000,bExposed=true)
    DriverPositions(3)=(ViewLocation=(Z=4.0),ViewFOV=12.0,PositionMesh=SkeletalMesh'DH_ShermanM4A176W_anm.shermanM4A1w_turret_extA',DriverTransitionAnim="stand_idleiron_binoc",ViewPitchUpLimit=10000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=10000,ViewNegativeYawLimit=-10000,bDrawOverlays=true,bExposed=true)
    FireImpulse=(X=-95000.0)
    GunClass=class'DH_Vehicles.DH_ShermanCannonA_M4A176W'
    CameraBone="Gun"
    DrivePos=(X=3.0,Z=-8.0)
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

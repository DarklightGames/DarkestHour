//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_StuH42CannonPawn extends DH_AssaultGunCannonPawn;

defaultproperties
{
    OverlayCenterSize=0.555000
    PeriscopePositionIndex=1
    UnbuttonedPositionIndex=3
    bManualTraverseOnly=true
    PoweredRotateSound=sound'Vehicle_Weapons.Turret.manual_gun_traverse'
    PoweredPitchSound=sound'Vehicle_Weapons.Turret.manual_turret_elevate'
    PoweredRotateAndPitchSound=sound'Vehicle_Weapons.Turret.manual_gun_traverse'
    CannonScopeOverlay=texture'DH_VehicleOptics_tex.German.stug3_SflZF1a_sight'
    DestroyedScopeOverlay=texture'DH_VehicleOpticsDestroyed_tex.German.stug3_SflZF1a_destroyed'
    BinocPositionIndex=4
    WeaponFOV=14.400000
    AmmoShellTexture=texture'InterfaceArt_tex.Tank_Hud.panzer4F2shell'
    AmmoShellReloadTexture=texture'InterfaceArt_tex.Tank_Hud.panzer4F2shell_reload'
    DriverPositions(0)=(ViewLocation=(Y=-32.000000,Z=30.000000),ViewFOV=14.400000,PositionMesh=SkeletalMesh'DH_Stug3G_anm.StuH_turret_int',ViewPitchUpLimit=3641,ViewPitchDownLimit=64444,ViewPositiveYawLimit=2000,ViewNegativeYawLimit=-2000,bDrawOverlays=true)
    DriverPositions(1)=(ViewLocation=(Z=10.000000),ViewFOV=7.200000,PositionMesh=SkeletalMesh'DH_Stug3G_anm.StuH_turret_int',ViewPitchUpLimit=1200,ViewPitchDownLimit=64500,ViewPositiveYawLimit=12000,ViewNegativeYawLimit=-12000,bDrawOverlays=true)
    DriverPositions(2)=(ViewFOV=90.000000,PositionMesh=SkeletalMesh'DH_Stug3G_anm.StuH_turret_int',TransitionUpAnim="com_open",DriverTransitionAnim="stand_idlehip_binoc",ViewPitchUpLimit=10000,ViewPitchDownLimit=64500,ViewPositiveYawLimit=65536,ViewNegativeYawLimit=-65536)
    DriverPositions(3)=(ViewFOV=90.000000,PositionMesh=SkeletalMesh'DH_Stug3G_anm.StuH_turret_int',TransitionDownAnim="com_close",DriverTransitionAnim="VStug3_com_open",ViewPitchUpLimit=10000,ViewPitchDownLimit=64500,ViewPositiveYawLimit=65536,ViewNegativeYawLimit=-65536,bExposed=true)
    DriverPositions(4)=(ViewFOV=12.000000,PositionMesh=SkeletalMesh'DH_Stug3G_anm.StuH_turret_int',DriverTransitionAnim="stand_idleiron_binoc",ViewPitchUpLimit=10000,ViewPitchDownLimit=60000,ViewPositiveYawLimit=65536,ViewNegativeYawLimit=-65536,bDrawOverlays=true,bExposed=true)
    GunClass=class'DH_Vehicles.DH_StuH42Cannon'
    CameraBone="Turret"
    MinRotateThreshold=0.500000
    MaxRotateThreshold=2.500000
    DrivePos=(Z=-6.000000)
    DriveAnim="stand_idlehip_binoc"
    EntryRadius=130.000000
    FPCamPos=(Z=5.000000)
    TPCamDistance=300.000000
    TPCamLookat=(X=-25.000000,Z=0.000000)
    TPCamWorldOffset=(Z=120.000000)
    PitchUpLimit=6000
    PitchDownLimit=64000
    SoundVolume=130
}

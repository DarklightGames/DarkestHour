//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_StuH42CannonPawn extends DHAssaultGunCannonPawn;

defaultproperties
{
    OverlayCenterSize=0.555
    PeriscopePositionIndex=1
    UnbuttonedPositionIndex=3
    bManualTraverseOnly=true
    ManualRotateSound=sound'Vehicle_Weapons.Turret.manual_gun_traverse'
    ManualRotateAndPitchSound=sound'Vehicle_Weapons.Turret.manual_gun_traverse'
    CannonScopeOverlay=texture'DH_VehicleOptics_tex.German.stug3_SflZF1a_sight'
    DestroyedScopeOverlay=texture'DH_VehicleOpticsDestroyed_tex.German.stug3_SflZF1a_destroyed'
    BinocPositionIndex=4
    WeaponFOV=14.4
    AmmoShellTexture=texture'InterfaceArt_tex.Tank_Hud.panzer4F2shell'
    AmmoShellReloadTexture=texture'InterfaceArt_tex.Tank_Hud.panzer4F2shell_reload'
    DriverPositions(0)=(ViewLocation=(Y=-32.0,Z=30.0),ViewFOV=14.4,PositionMesh=SkeletalMesh'DH_Stug3G_anm.StuH_turret_int',ViewPitchUpLimit=3641,ViewPitchDownLimit=64444,ViewPositiveYawLimit=2000,ViewNegativeYawLimit=-2000,bDrawOverlays=true)
    DriverPositions(1)=(ViewLocation=(Z=10.0),ViewFOV=45.0,PositionMesh=SkeletalMesh'DH_Stug3G_anm.StuH_turret_int',ViewPitchUpLimit=0,ViewPitchDownLimit=65536,ViewPositiveYawLimit=12000,ViewNegativeYawLimit=-12000,bDrawOverlays=true)
    DriverPositions(2)=(ViewFOV=90.0,PositionMesh=SkeletalMesh'DH_Stug3G_anm.StuH_turret_int',TransitionUpAnim="com_open",DriverTransitionAnim="stand_idlehip_binoc",ViewPitchUpLimit=10000,ViewPitchDownLimit=64500,ViewPositiveYawLimit=65536,ViewNegativeYawLimit=-65536)
    DriverPositions(3)=(ViewFOV=90.0,PositionMesh=SkeletalMesh'DH_Stug3G_anm.StuH_turret_int',TransitionDownAnim="com_close",DriverTransitionAnim="VStug3_com_open",ViewPitchUpLimit=10000,ViewPitchDownLimit=64500,ViewPositiveYawLimit=65536,ViewNegativeYawLimit=-65536,bExposed=true)
    DriverPositions(4)=(ViewFOV=12.0,PositionMesh=SkeletalMesh'DH_Stug3G_anm.StuH_turret_int',DriverTransitionAnim="stand_idleiron_binoc",ViewPitchUpLimit=10000,ViewPitchDownLimit=60000,ViewPositiveYawLimit=65536,ViewNegativeYawLimit=-65536,bDrawOverlays=true,bExposed=true)
    GunClass=class'DH_Vehicles.DH_StuH42Cannon'
    CameraBone="Turret"
    ManualMinRotateThreshold=0.5
    ManualMaxRotateThreshold=3.0
    DrivePos=(Z=-6.0)
    DriveAnim="stand_idlehip_binoc"
    EntryRadius=130.0
    FPCamPos=(Z=5.0)
    TPCamDistance=300.0
    TPCamLookat=(X=-25.0,Z=0.0)
    TPCamWorldOffset=(Z=120.0)
    PitchUpLimit=6000
    PitchDownLimit=64000
    SoundVolume=130
}

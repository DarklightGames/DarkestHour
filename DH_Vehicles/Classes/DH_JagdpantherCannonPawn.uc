//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_JagdpantherCannonPawn extends DHAssaultGunCannonPawn;

defaultproperties
{
    OverlayCenterSize=0.555
    PeriscopePositionIndex=1
    bManualTraverseOnly=true
    ManualRotateSound=sound'Vehicle_Weapons.Turret.manual_gun_traverse'
    ManualRotateAndPitchSound=sound'Vehicle_Weapons.Turret.manual_gun_traverse'
    CannonScopeOverlay=texture'DH_Artillery_Tex.ATGun_Hud.ZF_II_3x8_Pak'
    DestroyedScopeOverlay=texture'DH_VehicleOpticsDestroyed_tex.German.stug3_SflZF1a_destroyed'
    bLockCameraDuringTransition=true
    WeaponFOV=14.4
    AmmoShellTexture=texture'DH_InterfaceArt_tex.Tank_Hud.KingTigerShell'
    AmmoShellReloadTexture=texture'DH_InterfaceArt_tex.Tank_Hud.KingTigerShell_reload'
    DriverPositions(0)=(ViewLocation=(X=70.0,Y=-23.0,Z=15.0),ViewFOV=14.4,PositionMesh=SkeletalMesh'DH_Jagdpanther_anm.Jagdpanther_turret_int',ViewPitchUpLimit=2548,ViewPitchDownLimit=64079,ViewPositiveYawLimit=3000,ViewNegativeYawLimit=-3000,bDrawOverlays=true)
    DriverPositions(1)=(ViewFOV=45.0,PositionMesh=SkeletalMesh'DH_Jagdpanther_anm.Jagdpanther_turret_int',TransitionUpAnim="com_open",ViewPitchUpLimit=1200,ViewPitchDownLimit=64500,ViewPositiveYawLimit=18000,ViewNegativeYawLimit=-18000,bDrawOverlays=true)
    DriverPositions(2)=(ViewFOV=90.0,PositionMesh=SkeletalMesh'DH_Jagdpanther_anm.Jagdpanther_turret_int',TransitionDownAnim="com_close",DriverTransitionAnim="VStug3_com_open",ViewPitchUpLimit=6000,ViewPitchDownLimit=65000,ViewPositiveYawLimit=100000,ViewNegativeYawLimit=-100000,bExposed=true)
    DriverPositions(3)=(ViewFOV=12.0,PositionMesh=SkeletalMesh'DH_Jagdpanther_anm.Jagdpanther_turret_int',ViewPitchUpLimit=6000,ViewPitchDownLimit=65000,ViewPositiveYawLimit=100000,ViewNegativeYawLimit=-100000,bDrawOverlays=true,bExposed=true)
    FireImpulse=(X=-110000.0)
    GunClass=class'DH_Vehicles.DH_JagdpantherCannon'
    bHasAltFire=false
    CameraBone="Turret_placement1"
    ManualMinRotateThreshold=0.5
    ManualMaxRotateThreshold=3.0
    DrivePos=(Z=-4.0)
    DriveAnim="VStug3_com_idle_close"
    EntryRadius=130.0
    TPCamDistance=300.0
    TPCamLookat=(X=-25.0,Z=0.0)
    TPCamWorldOffset=(Z=120.0)
    PitchUpLimit=6000
    PitchDownLimit=64000
    SoundVolume=130
}

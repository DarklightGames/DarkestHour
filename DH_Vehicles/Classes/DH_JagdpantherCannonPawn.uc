//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_JagdpantherCannonPawn extends DHAssaultGunCannonPawn;

defaultproperties
{
    GunClass=class'DH_Vehicles.DH_JagdpantherCannon'
    DriverPositions(0)=(ViewLocation=(X=60.0,Y=-21.0,Z=10.0),ViewFOV=28.33,PositionMesh=SkeletalMesh'DH_Jagdpanther_anm.Jagdpanther_turret_int',ViewPitchUpLimit=2548,ViewPitchDownLimit=64079,ViewPositiveYawLimit=3000,ViewNegativeYawLimit=-3000,bDrawOverlays=true)
    DriverPositions(1)=(ViewFOV=10.67,PositionMesh=SkeletalMesh'DH_Jagdpanther_anm.Jagdpanther_turret_int',TransitionUpAnim="com_open",DriverTransitionAnim="VStug3_com_close",ViewPitchUpLimit=500,ViewPitchDownLimit=62940,ViewPositiveYawLimit=12000,ViewNegativeYawLimit=-12000,bDrawOverlays=true)
    DriverPositions(2)=(PositionMesh=SkeletalMesh'DH_Jagdpanther_anm.Jagdpanther_turret_int',TransitionDownAnim="com_close",DriverTransitionAnim="VStug3_com_open",ViewPitchUpLimit=6000,ViewPitchDownLimit=65000,ViewPositiveYawLimit=100000,ViewNegativeYawLimit=-100000,bExposed=true)
    DriverPositions(3)=(ViewFOV=12.0,PositionMesh=SkeletalMesh'DH_Jagdpanther_anm.Jagdpanther_turret_int',DriverTransitionAnim="stand_idleiron_binoc",ViewPitchUpLimit=6000,ViewPitchDownLimit=65000,ViewPositiveYawLimit=100000,ViewNegativeYawLimit=-100000,bDrawOverlays=true,bExposed=true)
    PeriscopePositionIndex=1
    DrivePos=(X=-3.0,Y=-2.0,Z=-6.0)
    DriveAnim="VStug3_com_idle_close"
    bHasAltFire=false
    bLockCameraDuringTransition=true
    GunsightOverlay=Texture'DH_VehicleOptics_tex.German.ZF_II_3x8_Pak'
    GunsightSize=0.282 // 8 degrees visible FOV at 3x magnification (Sfl.ZF5 sight) // TODO: some sources say ZF1 or ZF1a with 5x mag (mid production?) & late JP had WZF1/4 sight with 10x mag & 7 degs FOV
    AmmoShellTexture=Texture'DH_InterfaceArt_tex.Tank_Hud.KingTigerShell'
    AmmoShellReloadTexture=Texture'DH_InterfaceArt_tex.Tank_Hud.KingTigerShell_reload'
    FireImpulse=(X=-110000.0)
}

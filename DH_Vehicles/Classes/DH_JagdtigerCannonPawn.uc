//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_JagdtigerCannonPawn extends DHAssaultGunCannonPawn;

defaultproperties
{
    GunClass=class'DH_Vehicles.DH_JagdtigerCannon'
    DriverPositions(0)=(ViewLocation=(X=25.0,Y=-25.0,Z=5.0),ViewFOV=8.5,bDrawOverlays=true)
    DriverPositions(1)=(ViewLocation=(X=55.0,Y=7.0,Z=12.0),ViewFOV=10.67,TransitionUpAnim="com_open",ViewPitchUpLimit=500,ViewPitchDownLimit=62940,ViewPositiveYawLimit=12000,ViewNegativeYawLimit=-12000,bDrawOverlays=true)
    DriverPositions(2)=(TransitionDownAnim="com_close",DriverTransitionAnim="stand_idlehip_binoc",ViewPitchUpLimit=6000,ViewPitchDownLimit=65000,ViewPositiveYawLimit=100000,ViewNegativeYawLimit=-100000,bExposed=true)
    DriverPositions(3)=(ViewFOV=12.0,DriverTransitionAnim="stand_idleiron_binoc",ViewPitchUpLimit=6000,ViewPitchDownLimit=65000,ViewPositiveYawLimit=100000,ViewNegativeYawLimit=-100000,bDrawOverlays=true,bExposed=true)
    PeriscopePositionIndex=1
    bLockCameraDuringTransition=true
    DrivePos=(X=2.0,Y=6.0,Z=-3.0)
    DriveAnim="stand_idlehip_binoc"
    bHasAltFire=false
    GunsightOverlay=Texture'DH_VehicleOptics_tex.German.ZF_II_3x8_Pak'
    GunsightSize=0.824 // 7 degrees visible FOV at 10x magnification (WZF2/7 sight) // TODO: for some reason shell tracers aren't visible if FOV < 10.67 (equivalent to approx 8x magnification),
    RangePositionX=0.02                                                             //       so need to either (1) fudge magnification or (2) use tracer static mesh for projectile SM (like German 20mm)
    AmmoShellTexture=Texture'DH_InterfaceArt_tex.Tank_Hud.JagdTiger_shell'
    AmmoShellReloadTexture=Texture'DH_InterfaceArt_tex.Tank_Hud.JagdTiger_shell_reload'
    FireImpulse=(X=-110000.0)
}

//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_HetzerCannonPawn extends DHAssaultGunCannonPawn;

defaultproperties
{
    //Gun Class
    GunClass=Class'DH_Vehicles.DH_HetzerCannon'

    //Driver's positions & anims
    DriverPositions(0)=(ViewLocation=(X=37.000000,Y=-35.000000,Z=12.000000),ViewFOV=15.0,bDrawOverlays=true)
    DriverPositions(1)=(ViewLocation=(Z=10.000000),ViewFOV=7.200000,TransitionUpAnim="com_open",DriverTransitionAnim="VStug3_com_close",ViewPitchUpLimit=1200,ViewPitchDownLimit=64500,ViewPositiveYawLimit=12000,ViewNegativeYawLimit=-12000,bDrawOverlays=true)
    DriverPositions(2)=(TransitionDownAnim="com_close",DriverTransitionAnim="VStug3_com_open",ViewPitchUpLimit=5000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=65535,ViewNegativeYawLimit=-65535,bExposed=true)
    DriverPositions(3)=(ViewFOV=12.000000,DriverTransitionAnim="stand_idleiron_binoc",ViewPitchUpLimit=5000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=65535,ViewNegativeYawLimit=-65535,bDrawOverlays=true,bExposed=true)

    PeriscopePositionIndex=1
    DrivePos=(X=5.000000,Z=-29.000000)
    bHasAltFire=false
    DriveAnim="VStug3_com_idle_close"

    //Gunsight
    bIsPeriscopicGunsight=true
    GunsightOverlay=Texture'DH_VehicleOptics_tex.German.stug3_SflZF1a_sight'
    GunsightSize=0.533 // 8 degrees visible FOV at 5x magnification (Sfl.ZF1a sight)

    //HUD
    AmmoShellTexture=Texture'InterfaceArt_tex.Tank_Hud.panzer4F2shell'
    AmmoShellReloadTexture=Texture'InterfaceArt_tex.Tank_Hud.panzer4F2shell_reload'
}

//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DH_Stug3GCannonPawn extends DHAssaultGunCannonPawn;

defaultproperties
{
    GunClass=class'DH_Vehicles.DH_Stug3GCannon'
    DriverPositions(0)=(ViewLocation=(Y=-32.0,Z=30.0),ViewFOV=17.0,PositionMesh=SkeletalMesh'DH_Stug3G_anm.Stug3g_turret_int',ViewPitchUpLimit=3641,ViewPitchDownLimit=64444,ViewPositiveYawLimit=2000,ViewNegativeYawLimit=-2000,bDrawOverlays=true) //gunsight
    DriverPositions(1)=(ViewLocation=(Z=16.0),ViewFOV=11.25,PositionMesh=SkeletalMesh'DH_Stug3G_anm.Stug3g_turret_int',ViewPitchUpLimit=500,ViewPitchDownLimit=62940,ViewPositiveYawLimit=12000,ViewNegativeYawLimit=-12000,bDrawOverlays=true) //periscope
    DriverPositions(2)=(ViewLocation=(Z=0.0),ViewFOV=50.0,PositionMesh=SkeletalMesh'DH_Stug3G_anm.Stug3g_turret_int',TransitionUpAnim="com_open",DriverTransitionAnim="stand_idlehip_binoc",ViewPitchUpLimit=10000,ViewPitchDownLimit=64500,ViewPositiveYawLimit=65536,ViewNegativeYawLimit=-65536)//cupola, buttoned up
    DriverPositions(3)=(PositionMesh=SkeletalMesh'DH_Stug3G_anm.Stug3g_turret_int',TransitionDownAnim="com_close",DriverTransitionAnim="VStug3_com_open",ViewPitchUpLimit=10000,ViewPitchDownLimit=64500,ViewPositiveYawLimit=65536,ViewNegativeYawLimit=-65536,bExposed=true) //cupola, exposed
    DriverPositions(4)=(ViewFOV=12.0,PositionMesh=SkeletalMesh'DH_Stug3G_anm.Stug3g_turret_int',DriverTransitionAnim="stand_idleiron_binoc",ViewPitchUpLimit=10000,ViewPitchDownLimit=60000,ViewPositiveYawLimit=65536,ViewNegativeYawLimit=-65536,bDrawOverlays=true,bExposed=true) //cupola, exposed, binocs
    PeriscopePositionIndex=1
    UnbuttonedPositionIndex=4
    BinocPositionIndex=5
    DrivePos=(X=0.0,Y=0.0,Z=-7.0)
    DriveAnim="stand_idlehip_binoc"
    CameraBone="Turret"
    GunsightOverlay=Texture'DH_VehicleOptics_tex.German.stug3_SflZF1a_sight'
    GunsightSize=0.471 // 8 degrees visible FOV at 5x magnification (Sfl.ZF1a sight)
    AmmoShellTexture=Texture'InterfaceArt_tex.Tank_Hud.panzer4F2shell'
    AmmoShellReloadTexture=Texture'InterfaceArt_tex.Tank_Hud.panzer4F2shell_reload'
    OverlayCorrectionX=10
    
}

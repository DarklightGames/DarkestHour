//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_AchillesCannonPawn extends DHBritishCannonPawn;

defaultproperties
{
    //Gun Class
    GunClass=class'DH_Vehicles.DH_AchillesCannon'

    //Driver's positions & anims
    DriverPositions(0)=(ViewLocation=(X=25.0,Y=-25.2,Z=8.0),ViewFOV=25.0,PositionMesh=SkeletalMesh'DH_Wolverine_anm.Achilles_turret_ext',TransitionUpAnim="com_open",DriverTransitionAnim="VSU76_com_close",ViewPitchUpLimit=3641,ViewPitchDownLimit=64653,ViewPositiveYawLimit=65536,ViewNegativeYawLimit=-65536,bDrawOverlays=true,bExposed=true)
    DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_Wolverine_anm.Achilles_turret_ext',TransitionDownAnim="com_close",DriverTransitionAnim="VSU76_com_open",ViewPitchUpLimit=10000,ViewPitchDownLimit=60000,ViewPositiveYawLimit=65536,ViewNegativeYawLimit=-65536,bExposed=true)
    DriverPositions(2)=(ViewFOV=12.0,PositionMesh=SkeletalMesh'DH_Wolverine_anm.Achilles_turret_ext',DriverTransitionAnim="stand_idleiron_binoc",ViewPitchUpLimit=10000,ViewPitchDownLimit=60000,ViewPositiveYawLimit=10000,ViewNegativeYawLimit=-10000,bDrawOverlays=true,bExposed=true)

    UnbuttonedPositionIndex=0
    RaisedPositionIndex=1
    BinocPositionIndex=2
    DrivePos=(X=12.0,Y=8.0,Z=1.0) // MG can poke into player's chest, but can't move further back or he pokes through the rear of the superstructure
    DriveAnim="VSU76_com_idle_close"

    //Traverse & Fire
    bManualTraverseOnly=true
    bHasAltFire=false
    FireImpulse=(X=-100000.0)

    //Gunsight
    GunsightOverlay=Texture'DH_VehicleOptics_tex.British.17Pdr_sight_background'
    CannonScopeCenter=Texture'DH_VehicleOptics_tex.British.17pdr_sight_mover'
    GunsightSize=0.52 // 13 degrees visible FOV at 3x magnification (No.51 sight)
    RangePositionX=0.16

    //HUD
    DestroyedGunsightOverlay=Texture'DH_VehicleOpticsDestroyed_tex.Allied.17pdr_sight_destroyed'
    AmmoShellTexture=Texture'InterfaceArt_tex.Tank_Hud.T3485shell'
    AmmoShellReloadTexture=Texture'InterfaceArt_tex.Tank_Hud.T3485shell_reload'
}

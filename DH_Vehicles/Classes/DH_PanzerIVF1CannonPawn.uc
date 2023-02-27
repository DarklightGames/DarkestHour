//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_PanzerIVF1CannonPawn extends DHGermanCannonPawn;

defaultproperties
{
    VehiclePositionString="in a Panzer IV F1 cannon"
    VehicleNameString="Panzer IV F1 Cannon"
    GunClass=class'DH_Vehicles.DH_PanzerIVF1Cannon'

    DriverPositions(0)=(ViewLocation=(X=12.0,Y=-27.0,Z=3.0),ViewFOV=34.0,PositionMesh=SkeletalMesh'DH_Panzer4F1_anm.Panzer4F1_turret_int',ViewPitchUpLimit=3641,ViewPitchDownLimit=64080,ViewPositiveYawLimit=19000,ViewNegativeYawLimit=-20000,bDrawOverlays=true)
    DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_Panzer4F1_anm.Panzer4F1_turret_int',TransitionUpAnim="com_open",DriverTransitionAnim="VPanzer4_com_close",ViewPitchUpLimit=5000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=6000,ViewNegativeYawLimit=-10000)
    DriverPositions(2)=(PositionMesh=SkeletalMesh'DH_Panzer4F1_anm.Panzer4F1_turret_int',TransitionDownAnim="com_close",DriverTransitionAnim="VPanzer4_com_open",ViewPitchUpLimit=5000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=10000,ViewNegativeYawLimit=-10000,bExposed=true)
    DriverPositions(3)=(ViewFOV=12.0,PositionMesh=SkeletalMesh'DH_Panzer4F1_anm.Panzer4F1_turret_int',DriverTransitionAnim="stand_idleiron_binoc",ViewPitchUpLimit=5000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=10000,ViewNegativeYawLimit=-10000,bDrawOverlays=true,bExposed=true)
    DrivePos=(X=0.0,Y=0.0,Z=0.0)

    DriveAnim=VPanzer4_com_idle_close

    //Gunsight
    CannonScopeCenter=Texture'DH_VehicleOptics_tex.German.PZ3_sight_graticule'
    GunsightSize=0.735 // 25 degrees visible FOV at 2.5x magnification
    RangeRingRotator=TexRotator'DH_VehicleOptics_tex.German.PZ4_sight_Center'
    RangeRingRotationFactor=985
    DestroyedGunsightOverlay=Texture'DH_VehicleOpticsDestroyed_tex.German.PZ4_sight_destroyed'

    //HUD
    AmmoShellTexture=Texture'InterfaceArt_tex.Tank_Hud.Panzer4F1shell'
    AmmoShellReloadTexture=Texture'InterfaceArt_tex.Tank_Hud.Panzer4F1shell_reload'

    //Turret rotation sounds
    PoweredRotateSound=Sound'Vehicle_Weapons.Turret.electric_turret_traverse'
    PoweredPitchSound=Sound'Vehicle_Weapons.Turret.manual_turret_elevate'
    PoweredRotateAndPitchSound=Sound'Vehicle_Weapons.Turret.electric_turret_traverse'
}

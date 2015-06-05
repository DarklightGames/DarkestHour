//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_PanzerIVGLateCannonPawn extends DHGermanCannonPawn;

defaultproperties
{
    ScopeCenterScale=0.635
    ScopeCenterRotator=TexRotator'DH_VehicleOptics_tex.German.PZ4_sight_Center'
    CenterRotationFactor=985
    OverlayCenterSize=0.87
    DestroyedScopeOverlay=texture'DH_VehicleOpticsDestroyed_tex.German.PZ4_sight_destroyed'
    PoweredRotateSound=sound'Vehicle_Weapons.Turret.electric_turret_traverse'
    PoweredPitchSound=sound'Vehicle_Weapons.Turret.manual_turret_elevate'
    PoweredRotateAndPitchSound=sound'Vehicle_Weapons.Turret.electric_turret_traverse'
    CannonScopeCenter=texture'DH_VehicleOptics_tex.German.PZ3_sight_graticule'
    WeaponFOV=28.8
    AmmoShellTexture=texture'InterfaceArt_tex.Tank_Hud.panzer4F2shell'
    AmmoShellReloadTexture=texture'InterfaceArt_tex.Tank_Hud.panzer4F2shell_reload'
    DriverPositions(0)=(ViewLocation=(X=12.0,Y=-27.0,Z=3.0),ViewFOV=28.8,PositionMesh=SkeletalMesh'DH_PanzerIV_anm.Panzer4Glate_turret_int',ViewPitchUpLimit=3641,ViewPitchDownLimit=64080,ViewPositiveYawLimit=19000,ViewNegativeYawLimit=-20000,bDrawOverlays=true)
    DriverPositions(1)=(ViewFOV=90.0,PositionMesh=SkeletalMesh'DH_PanzerIV_anm.Panzer4Glate_turret_int',TransitionUpAnim="com_open",DriverTransitionAnim="VPanzer4_com_close",ViewPitchUpLimit=4000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=6000,ViewNegativeYawLimit=-10000)
    DriverPositions(2)=(ViewFOV=90.0,PositionMesh=SkeletalMesh'DH_PanzerIV_anm.Panzer4Glate_turret_int',TransitionDownAnim="com_close",DriverTransitionAnim="VPanzer4_com_open",ViewPitchUpLimit=5000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=10000,ViewNegativeYawLimit=-10000,bExposed=true)
    DriverPositions(3)=(ViewFOV=12.0,PositionMesh=SkeletalMesh'DH_PanzerIV_anm.Panzer4Glate_turret_int',ViewPitchUpLimit=5000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=10000,ViewNegativeYawLimit=-10000,bDrawOverlays=true,bExposed=true)
    GunClass=class'DH_Vehicles.DH_PanzerIVGLateCannon'
    CameraBone="Gun"
    EntryRadius=130.0
    PitchUpLimit=6000
    PitchDownLimit=64000
    SoundVolume=130
}

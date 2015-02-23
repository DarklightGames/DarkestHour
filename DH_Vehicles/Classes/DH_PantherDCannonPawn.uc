//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_PantherDCannonPawn extends DH_GermanTankCannonPawn;

defaultproperties
{
    ScopeCenterScale=0.715
    ScopeCenterRotator=TexRotator'DH_VehicleOptics_tex.German.Panther_sight_center'
    CenterRotationFactor=502
    OverlayCenterSize=0.972
    DestroyedScopeOverlay=texture'DH_VehicleOpticsDestroyed_tex.German.Panther_sight_destroyed'
    PoweredRotateSound=sound'Vehicle_Weapons.Turret.hydraul_turret_traverse'
    PoweredPitchSound=sound'Vehicle_Weapons.Turret.manual_turret_elevate'
    PoweredRotateAndPitchSound=sound'Vehicle_Weapons.Turret.hydraul_turret_traverse'
    CannonScopeCenter=texture'DH_VehicleOptics_tex.German.Panther_sight_graticule'
    ScopePositionX=0.237
    ScopePositionY=0.15
    WeaponFOV=28.8
    AmmoShellTexture=texture'InterfaceArt_tex.Tank_Hud.Panthershell'
    AmmoShellReloadTexture=texture'InterfaceArt_tex.Tank_Hud.Panthershell_reload'
    DriverPositions(0)=(ViewLocation=(X=34.0,Y=-27.0,Z=7.0),ViewFOV=28.8,PositionMesh=SkeletalMesh'axis_pantherg_anm.PantherG_turret_int',ViewPitchUpLimit=3276,ViewPitchDownLimit=64080,ViewPositiveYawLimit=19000,ViewNegativeYawLimit=-20000,bDrawOverlays=true)
    DriverPositions(1)=(ViewFOV=90.0,PositionMesh=SkeletalMesh'axis_pantherg_anm.PantherG_turret_int',TransitionUpAnim="com_open",DriverTransitionAnim="VPanther_com_close",ViewPitchUpLimit=5000,ViewPitchDownLimit=64000,ViewPositiveYawLimit=6000,ViewNegativeYawLimit=-10000)
    DriverPositions(2)=(ViewFOV=90.0,PositionMesh=SkeletalMesh'axis_pantherg_anm.PantherG_turret_int',TransitionDownAnim="com_close",DriverTransitionAnim="VPanther_com_open",ViewPitchUpLimit=10000,ViewPitchDownLimit=64000,ViewPositiveYawLimit=6000,ViewNegativeYawLimit=-10000,bExposed=true)
    DriverPositions(3)=(ViewFOV=12.0,PositionMesh=SkeletalMesh'axis_pantherg_anm.PantherG_turret_int',ViewPitchUpLimit=10000,ViewPitchDownLimit=64000,ViewPositiveYawLimit=6000,ViewNegativeYawLimit=-10000,bDrawOverlays=true,bExposed=true)
    FireImpulse=(X=-110000.0)
    GunClass=class'DH_Vehicles.DH_PantherDCannon'
    CameraBone="Gun"
    DriveAnim="VPanther_com_idle_close"
    EntryRadius=130.0
    TPCamDistance=300.0
    TPCamLookat=(X=-25.0,Z=0.0)
    TPCamWorldOffset=(Z=120.0)
    PitchUpLimit=6000
    PitchDownLimit=64000
    SoundVolume=130
}

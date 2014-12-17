//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_PantherGCannonPawn extends DH_GermanTankCannonPawn;

defaultproperties
{
    ScopeCenterScale=0.715000
    ScopeCenterRotator=TexRotator'DH_VehicleOptics_tex.German.Panther_sight_center'
    CenterRotationFactor=502
    OverlayCenterSize=0.972000
    GunsightPositions=2
    UnbuttonedPositionIndex=3
    DestroyedScopeOverlay=texture'DH_VehicleOpticsDestroyed_tex.German.Panther_sight_destroyed'
    PoweredRotateSound=sound'Vehicle_Weapons.Turret.hydraul_turret_traverse'
    PoweredPitchSound=sound'Vehicle_Weapons.Turret.manual_turret_elevate'
    PoweredRotateAndPitchSound=sound'Vehicle_Weapons.Turret.hydraul_turret_traverse'
    CannonScopeCenter=texture'DH_VehicleOptics_tex.German.Panther_sight_graticule'
    ScopePositionX=0.237000
    ScopePositionY=0.150000
    BinocPositionIndex=4
    WeaponFov=28.799999
    AmmoShellTexture=texture'InterfaceArt_tex.Tank_Hud.Panthershell'
    AmmoShellReloadTexture=texture'InterfaceArt_tex.Tank_Hud.Panthershell_reload'
    DriverPositions(0)=(ViewLocation=(X=34.000000,Y=-27.000000,Z=7.000000),ViewFOV=14.400000,PositionMesh=SkeletalMesh'axis_pantherg_anm.PantherG_turret_int',ViewPitchUpLimit=3276,ViewPitchDownLimit=64080,ViewPositiveYawLimit=19000,ViewNegativeYawLimit=-20000,bDrawOverlays=true)
    DriverPositions(1)=(ViewLocation=(X=34.000000,Y=-27.000000,Z=7.000000),ViewFOV=28.799999,PositionMesh=SkeletalMesh'axis_pantherg_anm.PantherG_turret_int',ViewPitchUpLimit=3276,ViewPitchDownLimit=64080,ViewPositiveYawLimit=19000,ViewNegativeYawLimit=-20000,bDrawOverlays=true)
    DriverPositions(2)=(ViewFOV=90.000000,PositionMesh=SkeletalMesh'axis_pantherg_anm.PantherG_turret_int',TransitionUpAnim="com_open",DriverTransitionAnim="VPanther_com_close",ViewPitchUpLimit=5000,ViewPitchDownLimit=64000,ViewPositiveYawLimit=6000,ViewNegativeYawLimit=-10000)
    DriverPositions(3)=(ViewFOV=90.000000,PositionMesh=SkeletalMesh'axis_pantherg_anm.PantherG_turret_int',TransitionDownAnim="com_close",DriverTransitionAnim="VPanther_com_open",ViewPitchUpLimit=10000,ViewPitchDownLimit=64000,ViewPositiveYawLimit=6000,ViewNegativeYawLimit=-10000,bExposed=true)
    DriverPositions(4)=(ViewFOV=12.000000,PositionMesh=SkeletalMesh'axis_pantherg_anm.PantherG_turret_int',ViewPitchUpLimit=10000,ViewPitchDownLimit=64000,ViewPositiveYawLimit=6000,ViewNegativeYawLimit=-10000,bDrawOverlays=true,bExposed=true)
    FireImpulse=(X=-100000.000000)
    GunClass=class'DH_Vehicles.DH_PantherGCannon'
    CameraBone="Gun"
    bPCRelativeFPRotation=true
    bFPNoZFromCameraPitch=true
    DriveAnim="VPanther_com_idle_close"
    EntryRadius=130.000000
    TPCamDistance=300.000000
    TPCamLookat=(X=-25.000000,Z=0.000000)
    TPCamWorldOffset=(Z=120.000000)
    VehiclePositionString="in a Panzer V Ausf.G cannon"
    VehicleNameString="Panzer V Ausf.G Cannon"
    PitchUpLimit=6000
    PitchDownLimit=64000
    SoundVolume=130
}

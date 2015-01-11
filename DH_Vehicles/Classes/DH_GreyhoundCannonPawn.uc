//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_GreyhoundCannonPawn extends DH_AmericanTankCannonPawn;

defaultproperties
{
    OverlayCenterSize=0.542000
    UnbuttonedPositionIndex=0
    DestroyedScopeOverlay=texture'DH_VehicleOpticsDestroyed_tex.Allied.Stuart_sight_destroyed'
    bManualTraverseOnly=true
    PoweredRotateSound=sound'Vehicle_Weapons.Turret.manual_turret_traverse2'
    PoweredPitchSound=sound'Vehicle_Weapons.Turret.manual_turret_elevate'
    PoweredRotateAndPitchSound=sound'Vehicle_Weapons.Turret.manual_turret_traverse'
    CannonScopeOverlay=texture'DH_VehicleOptics_tex.Allied.Stuart_sight_background'
    BinocPositionIndex=2
    WeaponFOV=24.000000
    AmmoShellTexture=texture'DH_InterfaceArt_tex.Tank_Hud.StuartShell'
    AmmoShellReloadTexture=texture'DH_InterfaceArt_tex.Tank_Hud.StuartShell_reload'
    DriverPositions(0)=(ViewLocation=(X=25.000000,Y=-17.000000,Z=3.000000),ViewFOV=24.000000,PositionMesh=SkeletalMesh'DH_Greyhound_anm.Greyhound_turret_ext',TransitionUpAnim="com_open",DriverTransitionAnim="VSU76_com_close",ViewPitchUpLimit=3641,ViewPitchDownLimit=63716,bDrawOverlays=true)
    DriverPositions(1)=(ViewFOV=90.000000,PositionMesh=SkeletalMesh'DH_Greyhound_anm.Greyhound_turret_ext',TransitionDownAnim="com_close",DriverTransitionAnim="VSU76_com_open",ViewPitchUpLimit=10000,ViewPitchDownLimit=62000,ViewPositiveYawLimit=10000,ViewNegativeYawLimit=-10000,bExposed=true)
    DriverPositions(2)=(ViewFOV=12.000000,PositionMesh=SkeletalMesh'DH_Greyhound_anm.Greyhound_turret_ext',ViewPitchUpLimit=10000,ViewPitchDownLimit=62000,ViewPositiveYawLimit=10000,ViewNegativeYawLimit=-10000,bDrawOverlays=true,bExposed=true)
    bMustBeTankCrew=true
    FireImpulse=(X=-30000.000000)
    GunClass=class'DH_Vehicles.DH_GreyhoundCannon'
    CameraBone="Gun"
    bPCRelativeFPRotation=true
    bFPNoZFromCameraPitch=true
    DrivePos=(X=8.000000,Y=4.800000,Z=-5.750000)
    DriveAnim="VSU76_com_idle_close"
    EntryRadius=130.000000
    TPCamDistance=300.000000
    TPCamLookat=(X=-25.000000,Z=0.000000)
    TPCamWorldOffset=(Z=120.000000)
    VehicleNameString="M8 Armored Car Cannon"
    PitchUpLimit=6000
    PitchDownLimit=64000
    SoundVolume=130
}

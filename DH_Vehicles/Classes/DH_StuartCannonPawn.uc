//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_StuartCannonPawn extends DH_AmericanTankCannonPawn;

defaultproperties
{
    OverlayCenterSize=0.542
    DestroyedScopeOverlay=texture'DH_VehicleOpticsDestroyed_tex.Allied.Stuart_sight_destroyed'
    PoweredRotateSound=sound'DH_AlliedVehicleSounds.Sherman.ShermanTurretTraverse'
    PoweredPitchSound=sound'Vehicle_Weapons.Turret.manual_turret_elevate'
    PoweredRotateAndPitchSound=sound'DH_AlliedVehicleSounds.Sherman.ShermanTurretTraverse'
    CannonScopeOverlay=texture'DH_VehicleOptics_tex.Allied.Stuart_sight_background'
    WeaponFOV=24.0
    AmmoShellTexture=texture'DH_InterfaceArt_tex.Tank_Hud.StuartShell'
    AmmoShellReloadTexture=texture'DH_InterfaceArt_tex.Tank_Hud.StuartShell_reload'
    DriverPositions(0)=(ViewLocation=(X=12.0,Y=-9.5,Z=7.0),ViewFOV=24.0,PositionMesh=SkeletalMesh'DH_Stuart_anm.Stuart_turret_ext',TransitionUpAnim="Periscope_in",ViewPitchUpLimit=3641,ViewPitchDownLimit=63352,bDrawOverlays=true)
    DriverPositions(1)=(ViewFOV=90.0,PositionMesh=SkeletalMesh'DH_Stuart_anm.Stuart_turret_ext',TransitionUpAnim="com_open",DriverTransitionAnim="VT60_com_close",ViewPitchUpLimit=1,ViewPitchDownLimit=65535,ViewPositiveYawLimit=65536,ViewNegativeYawLimit=-65536,bDrawOverlays=true)
    DriverPositions(2)=(ViewFOV=90.0,PositionMesh=SkeletalMesh'DH_Stuart_anm.Stuart_turret_ext',TransitionDownAnim="com_close",DriverTransitionAnim="VT60_com_open",ViewPitchUpLimit=10000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=65536,ViewNegativeYawLimit=-65536,bExposed=true)
    DriverPositions(3)=(ViewFOV=12.0,PositionMesh=SkeletalMesh'DH_Stuart_anm.Stuart_turret_ext',ViewPitchUpLimit=10000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=65536,ViewNegativeYawLimit=-65536,bDrawOverlays=true,bExposed=true)
    GunClass=class'DH_Vehicles.DH_StuartCannon'
    CameraBone="Gun"
    DrivePos=(X=8.0,Y=4.8,Z=-5.75)
    DriveAnim="VT60_com_idle_close"
    EntryRadius=130.0
    TPCamDistance=300.0
    TPCamLookat=(X=-25.0,Z=0.0)
    TPCamWorldOffset=(Z=120.0)
    PitchUpLimit=6000
    PitchDownLimit=64000
    SoundVolume=130
    PeriscopePositionIndex=1
}

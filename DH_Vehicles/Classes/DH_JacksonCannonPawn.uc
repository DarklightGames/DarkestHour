//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_JacksonCannonPawn extends DHAmericanCannonPawn;

defaultproperties
{
    OverlayCenterSize=0.895
    UnbuttonedPositionIndex=0
    DestroyedScopeOverlay=texture'DH_VehicleOpticsDestroyed_tex.Allied.Wolverine_sight_destroyed'
    PoweredRotateSound=sound'Vehicle_Weapons.Turret.hydraul_turret_traverse'
    PoweredPitchSound=sound'Vehicle_Weapons.Turret.manual_turret_elevate'
    PoweredRotateAndPitchSound=sound'Vehicle_Weapons.Turret.hydraul_turret_traverse'
    CannonScopeOverlay=texture'DH_VehicleOptics_tex.Allied.Jackson_sight_background'
    RaisedPositionIndex=1
    BinocPositionIndex=2
    WeaponFOV=24.0
    AmmoShellTexture=texture'InterfaceArt_tex.Tank_Hud.IS2shell'
    AmmoShellReloadTexture=texture'InterfaceArt_tex.Tank_Hud.IS2shell_reload'
    DriverPositions(0)=(ViewLocation=(X=12.0,Y=25.0,Z=6.0),ViewFOV=24.0,PositionMesh=SkeletalMesh'DH_Jackson_anm.Jackson_turret_ext',TransitionUpAnim="com_open",DriverTransitionAnim="VSU76_com_close",ViewPitchUpLimit=3641,ViewPitchDownLimit=63715,ViewPositiveYawLimit=19000,ViewNegativeYawLimit=-20000,bDrawOverlays=true,bExposed=true)
    DriverPositions(1)=(ViewFOV=90.0,PositionMesh=SkeletalMesh'DH_Jackson_anm.Jackson_turret_ext',TransitionDownAnim="com_close",DriverTransitionAnim="VSU76_com_open",ViewPitchUpLimit=10000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=100000,ViewNegativeYawLimit=-100000,bExposed=true)
    DriverPositions(2)=(ViewFOV=12.0,PositionMesh=SkeletalMesh'DH_Jackson_anm.Jackson_turret_ext',DriverTransitionAnim="stand_idleiron_binoc",ViewPitchUpLimit=10000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=100000,ViewNegativeYawLimit=-100000,bDrawOverlays=true,bExposed=true)
    FireImpulse=(X=-100000.0)
    GunClass=class'DH_Vehicles.DH_JacksonCannon'
    bHasAltFire=false
    CameraBone="Gun"
    DrivePos=(X=13.0,Y=0.0,Z=7.0)
    DriveAnim="VSU76_com_idle_close"
    EntryRadius=130.0
    PitchUpLimit=6000
    PitchDownLimit=64000
    SoundVolume=130
}

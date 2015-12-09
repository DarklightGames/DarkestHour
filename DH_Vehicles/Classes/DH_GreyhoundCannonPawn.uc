//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_GreyhoundCannonPawn extends DHAmericanCannonPawn;

defaultproperties
{
    OverlayCenterSize=0.542
    UnbuttonedPositionIndex=0
    DestroyedScopeOverlay=texture'DH_VehicleOpticsDestroyed_tex.Allied.Stuart_sight_destroyed'
    bManualTraverseOnly=true
    CannonScopeOverlay=texture'DH_VehicleOptics_tex.Allied.Stuart_sight_background'
    RaisedPositionIndex=1
    BinocPositionIndex=2
    WeaponFOV=24.0
    AmmoShellTexture=texture'DH_InterfaceArt_tex.Tank_Hud.StuartShell'
    AmmoShellReloadTexture=texture'DH_InterfaceArt_tex.Tank_Hud.StuartShell_reload'
    DriverPositions(0)=(ViewLocation=(X=25.0,Y=-17.0,Z=3.0),ViewFOV=24.0,PositionMesh=SkeletalMesh'DH_Greyhound_anm.Greyhound_turret_ext',ViewPitchUpLimit=3641,ViewPitchDownLimit=63716,bDrawOverlays=true,bExposed=true)
    DriverPositions(1)=(ViewFOV=90.0,PositionMesh=SkeletalMesh'DH_Greyhound_anm.Greyhound_turret_ext',TransitionUpAnim="com_open",DriverTransitionAnim="VSU76_com_close",ViewPitchUpLimit=10000,ViewPitchDownLimit=62000,ViewPositiveYawLimit=10000,ViewNegativeYawLimit=-10000,bExposed=true)
    DriverPositions(2)=(ViewFOV=90.0,PositionMesh=SkeletalMesh'DH_Greyhound_anm.Greyhound_turret_ext',TransitionDownAnim="com_close",DriverTransitionAnim="VSU76_com_open",ViewPitchUpLimit=10000,ViewPitchDownLimit=62000,ViewPositiveYawLimit=10000,ViewNegativeYawLimit=-10000,bExposed=true)
    DriverPositions(3)=(ViewFOV=12.0,PositionMesh=SkeletalMesh'DH_Greyhound_anm.Greyhound_turret_ext',DriverTransitionAnim="stand_idleiron_binoc",ViewPitchUpLimit=10000,ViewPitchDownLimit=62000,ViewPositiveYawLimit=10000,ViewNegativeYawLimit=-10000,bDrawOverlays=true,bExposed=true)
    bMustBeTankCrew=true
    FireImpulse=(X=-30000.0)
    GunClass=class'DH_Vehicles.DH_GreyhoundCannon'
    CameraBone="Gun"
    DrivePos=(X=8.0,Y=3.0,Z=-4.5)
    DriveAnim="VSU76_com_idle_close"
    EntryRadius=130.0
    PitchUpLimit=6000
    PitchDownLimit=64000
    SoundVolume=130
}

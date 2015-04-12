//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_TigerCannonPawn_Late extends DHGermanTankCannonPawn;

defaultproperties
{
    ScopeCenterScale=0.68
    ScopeCenterRotator=TexRotator'DH_VehicleOptics_tex.German.tiger_sight_center'
    CenterRotationFactor=820
    OverlayCenterSize=0.87
    GunsightPositions=2
    UnbuttonedPositionIndex=3
    DestroyedScopeOverlay=texture'DH_VehicleOpticsDestroyed_tex.German.tiger_sight_destroyed'
    PoweredRotateSound=sound'DH_GerVehicleSounds2.Tiger2B.tiger2B_turret_traverse_loop'
    PoweredPitchSound=sound'Vehicle_Weapons.Turret.manual_turret_travelevate'
    PoweredRotateAndPitchSound=sound'DH_GerVehicleSounds2.Tiger2B.tiger2B_turret_traverse_loop'
    CannonScopeCenter=texture'DH_VehicleOptics_tex.German.tiger_sight_graticule'
    ScopePositionX=0.237
    ScopePositionY=0.15
    BinocPositionIndex=4
    WeaponFOV=28.8
    AmmoShellTexture=texture'InterfaceArt_tex.Tank_Hud.Tigershell'
    AmmoShellReloadTexture=texture'InterfaceArt_tex.Tank_Hud.Tigershell_reload'
    DriverPositions(0)=(ViewLocation=(X=35.0,Y=-31.0,Z=3.0),ViewFOV=14.4,PositionMesh=SkeletalMesh'axis_tiger1_anm.Tiger1_turret_int',ViewPitchUpLimit=3095,ViewPitchDownLimit=64353,ViewPositiveYawLimit=19000,ViewNegativeYawLimit=-20000,bDrawOverlays=true)
    DriverPositions(1)=(ViewLocation=(X=35.0,Y=-31.0,Z=3.0),ViewFOV=28.8,PositionMesh=SkeletalMesh'axis_tiger1_anm.Tiger1_turret_int',ViewPitchUpLimit=3095,ViewPitchDownLimit=64353,ViewPositiveYawLimit=19000,ViewNegativeYawLimit=-20000,bDrawOverlays=true)
    DriverPositions(2)=(ViewFOV=90.0,PositionMesh=SkeletalMesh'axis_tiger1_anm.Tiger1_turret_int',TransitionUpAnim="com_open",DriverTransitionAnim="VTiger_com_close",ViewPitchUpLimit=5000,ViewPitchDownLimit=64000,ViewPositiveYawLimit=6000,ViewNegativeYawLimit=-10000)
    DriverPositions(3)=(ViewFOV=90.0,PositionMesh=SkeletalMesh'axis_tiger1_anm.Tiger1_turret_int',TransitionDownAnim="com_close",DriverTransitionAnim="VTiger_com_open",ViewPitchUpLimit=10000,ViewPitchDownLimit=64000,ViewPositiveYawLimit=6000,ViewNegativeYawLimit=-10000,bExposed=true)
    DriverPositions(4)=(ViewFOV=12.0,PositionMesh=SkeletalMesh'axis_tiger1_anm.Tiger1_turret_int',ViewPitchUpLimit=10000,ViewPitchDownLimit=64000,ViewPositiveYawLimit=6000,ViewNegativeYawLimit=-10000,bDrawOverlays=true,bExposed=true)
    FireImpulse=(X=-110000.0)
    GunClass=class'DH_Vehicles.DH_TigerCannon'
    CameraBone="Gun"
    DriveAnim="VTiger_com_idle_close"
    EntryRadius=130.0
    FPCamPos=(X=50.0,Y=-30.0,Z=11.0)
    TPCamDistance=300.0
    TPCamLookat=(X=-25.0,Z=0.0)
    PitchUpLimit=6000
    PitchDownLimit=64000
}

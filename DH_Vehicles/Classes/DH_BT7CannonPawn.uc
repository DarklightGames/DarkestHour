//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_BT7CannonPawn extends DHVehicleCannonPawn;

defaultproperties
{
    VehicleNameString="BT-7 Cannon"
    EntryPosition=(X=0,Y=0,Z=0)
    EntryRadius=130.0
    ExitPositions(0)=(X=0,Y=200,Z=100)
    ExitPositions(1)=(X=0,Y=-200,Z=100)
    GunClass=class'DH_Vehicles.DH_BT7Cannon'
    CameraBone=gun
    FPCamPos=(X=0,Y=0,Z=0)
    FPCamViewOffset=(X=0,Y=0,Z=0) //was 0
    bFPNoZFromCameraPitch=False
    TPCamLookat=(X=-25,Y=0,Z=0)  //was 0
    TPCamWorldOffset=(X=0,Y=0,Z=120)
    TPCamDistance=300
    DrivePos=(X=8.0,Y=-3.0,Z=-5.0)    //adjusted to move right and down
    bDrawDriverInTP=True //False
    bDrawMeshInFP=True
    DriverDamageMult=1.0
    bPCRelativeFPRotation=true
    WeaponFov=29 // 2.5X
    PitchUpLimit=6000
    PitchDownLimit=64000
    RotateSound=Sound'Vehicle_Weapons.Turret.manual_turret_traverse'
    PitchSound=Sound'Vehicle_Weapons.Turret.manual_turret_elevate'
    RotateAndPitchSound=Sound'Vehicle_Weapons.Turret.manual_turret_traverse'
    SoundVolume=140
    GunsightOverlay=texture'DH_VehicleOptics_tex.Allied.M1937_optics'
    CannonScopeCenter=texture'Vehicle_Optic.T3476_sight_mover'
    //ScopePositionX=0.075
    //ScopeCenterScaleX=1.0
    //ScopeCenterScaleY=2.0
    OverlayCorrectionX=1
    OverlayCorrectionY=1
    OverlayCenterSize=0.6944 //(20deg * 2.5x gives 50deg apparent FOV,  TMF-1, T-70, 2.5x20 ???)
    DriveAnim=VPanzer4_com_idle_close
    // Driver positions - revise location from gun                                                                                                            //VT3476_com_close
    DriverPositions(0)=(ViewLocation=(X=0,Y=-7,Z=4),ViewFOV=29,PositionMesh=Mesh'allies_ahz_bt7_anm.BT7_turret_int',DriverTransitionAnim=VPanzer4_com_close,TransitionUpAnim=com_open,ViewPitchUpLimit=6000,ViewPitchDownLimit=64500,ViewPositiveYawLimit=19000,ViewNegativeYawLimit=-20000,bDrawOverlays=true,bExposed=false)
    DriverPositions(1)=(ViewLocation=(X=0,Y=0,Z=0),ViewFOV=80,PositionMesh=Mesh'allies_ahz_bt7_anm.BT7_turret_int',DriverTransitionAnim=VT3476_com_open,TransitionDownAnim=com_close,ViewPitchUpLimit=5000,ViewPitchDownLimit=62000,ViewPositiveYawLimit=6000,ViewNegativeYawLimit=-10000,bDrawOverlays=false,bExposed=true)
    DriverPositions(2)=(ViewLocation=(X=0,Y=0,Z=0),ViewFOV=12,PositionMesh=Mesh'allies_ahz_bt7_anm.BT7_turret_int',DriverTransitionAnim=none,ViewPitchUpLimit=5000,ViewPitchDownLimit=62000,ViewPositiveYawLimit=6000,ViewNegativeYawLimit=-10000,bDrawOverlays=true,bExposed=true)
    UnbuttonedPositionIndex=1
    BinocPositionIndex=2
    // Use the custom 45mm textures.
    AmmoShellTexture=Texture'InterfaceArt_ahz_tex.Tank_Hud.45mmShell'
    AmmoShellReloadTexture=Texture'InterfaceArt_ahz_tex.Tank_Hud.45mmShell_reload'
    PositionInArray=0
}


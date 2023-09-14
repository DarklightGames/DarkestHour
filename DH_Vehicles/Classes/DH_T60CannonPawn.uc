//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_T60CannonPawn extends DHSovietCannonPawn;

defaultproperties
{
    //Gun Class
    GunClass=class'DH_Vehicles.DH_T60Cannon'

    //Driver's positions & anims
    DriverPositions(0)=(ViewLocation=(X=15,Y=-2,Z=-1),ViewFOV=30,PositionMesh=Mesh'DH_T60_anm.T60_turret_int',DriverTransitionAnim=none,ViewPitchUpLimit=6000,ViewPitchDownLimit=64500,ViewPositiveYawLimit=19000,ViewNegativeYawLimit=-20000,bDrawOverlays=true,bExposed=false)
    DriverPositions(1)=(ViewLocation=(X=-9.0,Y=-12.0,Z=0.0),ViewFOV=75,PositionMesh=Mesh'DH_T60_anm.T60_turret_int',ViewPitchUpLimit=5000,ViewPitchDownLimit=65535,ViewPositiveYawLimit=6000,ViewNegativeYawLimit=-10000,bDrawOverlays=false,bExposed=false)
    DriverPositions(2)=(ViewLocation=(X=-9.0,Y=12.0,Z=0.0),ViewFOV=75,PositionMesh=Mesh'DH_T60_anm.T60_turret_int',DriverTransitionAnim=VT60_com_close,TransitionUpAnim=com_open,ViewPitchUpLimit=5000,ViewPitchDownLimit=65535,ViewPositiveYawLimit=6000,ViewNegativeYawLimit=-10000,bDrawOverlays=false,bExposed=false)
    DriverPositions(3)=(ViewLocation=(X=0,Y=0,Z=0),PositionMesh=Mesh'DH_T60_anm.T60_turret_int',DriverTransitionAnim=VT60_com_open,TransitionDownAnim=com_close,ViewPitchUpLimit=5000,ViewPitchDownLimit=62000,ViewPositiveYawLimit=6000,ViewNegativeYawLimit=-10000,bDrawOverlays=false,bExposed=true)
    DriverPositions(4)=(ViewLocation=(X=0,Y=0,Z=0),ViewFOV=12,PositionMesh=Mesh'DH_T60_anm.T60_turret_int',DriverTransitionAnim="stand_idleiron_binoc",ViewPitchUpLimit=5000,ViewPitchDownLimit=62000,ViewPositiveYawLimit=6000,ViewNegativeYawLimit=-10000,bDrawOverlays=true,bExposed=true)

    UnbuttonedPositionIndex=3
    BinocPositionIndex=4
    DrivePos=(X=0.0,Y=0.0,Z=-2.0)
    DriveAnim=VT60_com_idle_close

    //Gunsight
    GunsightOverlay=Texture'DH_VehicleOptics_tex.Soviet.45mmATGun_sight_background' // TODO: not sure this AHZ overlay is correct; it could be the telescopic sight used in tanks with the 45mm gun?
    GunsightSize=0.441 // 15 degrees visible FOV at 2.5x magnification (PP-1 sight)
    CannonScopeCenter=Texture'Vehicle_Optic.Scopes.T3476_sight_mover'
    ScopeCenterPositionX=0.001 //0.035
    ScopeCenterScaleX=2.4
    ScopeCenterScaleY=2.0 //2.0
    DestroyedGunsightOverlay=Texture'DH_VehicleOpticsDestroyed_tex.German.PZ4_sight_destroyed'

    //Traverse & Fire
    bManualTraverseOnly=true
    FireImpulse=(X=-10000,Y=0.0,Z=0.0)

    //HUD
    AmmoShellTexture=Texture'InterfaceArt_tex.Tank_Hud.t60shell'
    AmmoShellReloadTexture=Texture'InterfaceArt_tex.Tank_Hud.t60_reload'
}


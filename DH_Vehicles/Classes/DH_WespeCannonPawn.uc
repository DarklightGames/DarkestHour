//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_WespeCannonPawn extends DHGermanCannonPawn;

defaultproperties
{
    GunClass=class'DH_Vehicles.DH_WespeCannon'
    
    // gunsight
    DriverPositions(0)=(ViewLocation=(Y=-19.8,Z=47.4),ViewFOV=28.33,ViewPitchUpLimit=4551,ViewPitchDownLimit=64079,ViewPositiveYawLimit=19000,ViewNegativeYawLimit=-20000,bDrawOverlays=true,bExposed=true)
    // spotting scope
    DriverPositions(1)=(ViewLocation=(Y=-19.8,Z=47.4),TransitionUpAnim="gunsight_out",ViewFOV=60.0,bDrawOverlays=true,bExposed=true)
    // kneeling
    DriverPositions(2)=(DriverTransitionAnim="crouch_idle_binoc",TransitionDownAnim="gunsight_in",TransitionUpAnim="stand",ViewPitchUpLimit=10000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=65536,ViewNegativeYawLimit=-65536,bExposed=true)
    // standing
    DriverPositions(3)=(DriverTransitionAnim="stand_idlehip_binoc",TransitionDownAnim="sit",ViewPitchUpLimit=10000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=65536,ViewNegativeYawLimit=-65536,bExposed=true)
    // binoculars
    DriverPositions(4)=(ViewFOV=12.0,DriverTransitionAnim="stand_idleiron_binoc",ViewPitchUpLimit=10000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=65536,ViewNegativeYawLimit=-65536,bDrawOverlays=true,bExposed=true)

    UnbuttonedPositionIndex=0
    SpottingScopePositionIndex=1
    RaisedPositionIndex=3
    BinocPositionIndex=4

    DriveAnim="crouch_idle_binoc"
    bManualTraverseOnly=true
    bHasAltFire=false
    OverlayCorrectionY=0
    OverlayCorrectionX=0
    GunsightOverlay=Texture'DH_VehicleOptics_tex.US.m12a7_sight_2' // TODO: believe M12 is panoramic sight for indirect fire; we ought to have direct fire M16 telescopic sight (see http://www.strijdbewijs.nl/tanks/priest.htm)
    GunsightSize=0.40
    DestroyedGunsightOverlay=Texture'DH_VehicleOpticsDestroyed_tex.Allied.Sherman_sight_destroyed'
    AmmoShellTexture=Texture'DH_InterfaceArt_tex.Tank_Hud.ShermanShell'
    AmmoShellReloadTexture=Texture'DH_InterfaceArt_tex.Tank_Hud.ShermanShell_reload'
    FireImpulse=(X=-120000.0)
    ArtillerySpottingScopeClass=class'DH_Vehicles.DH_WespeArtillerySpottingScope'
    PlayerCameraBone=PLAYER_CAMERA
    CameraBone=GUNSIGHT_CAMERA
}

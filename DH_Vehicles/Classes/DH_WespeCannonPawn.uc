//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_WespeCannonPawn extends DHGermanCannonPawn;

defaultproperties
{
    GunClass=class'DH_WespeCannon'
    
    DriverPositions(0)=(TransitionUpAnim="gunsight_out",ViewFOV=40.0,bDrawOverlays=true,bExposed=true)
    DriverPositions(1)=(DriverTransitionAnim="wespe_gunner_lower",TransitionDownAnim="gunsight_in",TransitionUpAnim="raise",ViewPitchUpLimit=8192,ViewPitchDownLimit=57344,ViewPositiveYawLimit=65536,ViewNegativeYawLimit=-65536,bExposed=true)
    DriverPositions(2)=(DriverTransitionAnim="wespe_gunner_raise",TransitionDownAnim="lower",ViewPitchUpLimit=8192,ViewPitchDownLimit=57344,ViewPositiveYawLimit=65536,ViewNegativeYawLimit=-65536,bExposed=true)
    DriverPositions(3)=(ViewFOV=12.0,DriverTransitionAnim="wespe_gunner_binocs",ViewPitchUpLimit=8192,ViewPitchDownLimit=57344,ViewPositiveYawLimit=65536,ViewNegativeYawLimit=-65536,bDrawOverlays=true,bExposed=true)
    
    GunsightPositions=-1    // This has no "gunsight" position.
    UnbuttonedPositionIndex=0
    SpottingScopePositionIndex=0
    RaisedPositionIndex=2
    BinocPositionIndex=3

    DrivePos=(Z=58)

    DriveAnim="wespe_gunner_idle"
    bManualTraverseOnly=true
    bHasAltFire=false
    OverlayCorrectionY=0
    OverlayCorrectionX=0
    GunsightOverlay=Texture'DH_VehicleOptics_tex.m12a7_sight_2' // TODO: believe M12 is panoramic sight for indirect fire; we ought to have direct fire M16 telescopic sight (see http://www.strijdbewijs.nl/tanks/priest.htm)
    GunsightSize=0.40
    DestroyedGunsightOverlay=Texture'DH_VehicleOpticsDestroyed_tex.Sherman_sight_destroyed'
    AmmoShellTexture=Texture'DH_InterfaceArt_tex.ShermanShell'
    AmmoShellReloadTexture=Texture'DH_InterfaceArt_tex.ShermanShell_reload'
    FireImpulse=(X=-120000.0)
    ArtillerySpottingScopeClass=class'DH_WespeArtillerySpottingScope'
    PlayerCameraBone="PLAYER_CAMERA"
    CameraBone="GUNSIGHT_CAMERA"
}

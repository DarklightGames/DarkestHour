//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_M7PriestCannonPawn extends DHAmericanCannonPawn;

// Modified to update sight rotation, if gun pitch has changed
function HandleTurretRotation(float DeltaTime, float YawChange, float PitchChange)
{
    local rotator R;

    super.HandleTurretRotation(DeltaTime, YawChange, PitchChange);

    if (Level.NetMode != NM_DedicatedServer && ((YawChange != 0.0 && !bTurretRingDamaged) || (PitchChange != 0.0 && !bGunPivotDamaged)) && Gun != none)
    {
        R = Gun.GetBoneRotation('gun');
        R.Yaw = 0;
        Gun.SetBoneRotation('gunsight', R);
    }
}

defaultproperties
{
    GunClass=class'DH_Vehicles.DH_M7PriestCannon'
    // gunsight
    DriverPositions(0)=(ViewLocation=(Y=-19.8,Z=47.4),ViewFOV=28.33,ViewPitchUpLimit=4551,ViewPitchDownLimit=64079,ViewPositiveYawLimit=19000,ViewNegativeYawLimit=-20000,bDrawOverlays=true,bExposed=true)
    // spotting scope
    DriverPositions(1)=(ViewLocation=(Y=-19.8,Z=47.4),ViewFOV=60.0,bDrawOverlays=true,bExposed=true)
    // kneeling
    DriverPositions(2)=(DriverTransitionAnim="crouch_idle_binoc",TransitionUpAnim="com_open",ViewPitchUpLimit=10000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=65536,ViewNegativeYawLimit=-65536,bExposed=true)
    // standing
    DriverPositions(3)=(DriverTransitionAnim="stand_idlehip_binoc",TransitionDownAnim="com_close",ViewPitchUpLimit=10000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=65536,ViewNegativeYawLimit=-65536,bExposed=true)
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
    FireImpulse=(X=-110000.0)
    ArtillerySpottingScopeClass=class'DH_Vehicles.DHArtillerySpottingScope_M7Priest'
}


//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
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
    DriverPositions(0)=(ViewLocation=(Y=-19.8,Z=47.4),ViewFOV=28.33,ViewPitchUpLimit=4551,ViewPitchDownLimit=64079,ViewPositiveYawLimit=19000,ViewNegativeYawLimit=-20000,bDrawOverlays=true,bExposed=true)// kneeling
    // spotting scope
    DriverPositions(1)=(ViewLocation=(Y=-19.8,Z=47.4),ViewFOV=60.0,bDrawOverlays=true,bExposed=true)
    // kneeling
    DriverPositions(2)=(DriverTransitionAnim="crouch_idle_binoc",TransitionUpAnim="com_open",ViewPitchUpLimit=10000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=65536,ViewNegativeYawLimit=-65536,bExposed=true)
    // standing
    DriverPositions(3)=(DriverTransitionAnim="stand_idlehip_binoc",TransitionDownAnim="com_close",ViewPitchUpLimit=10000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=65536,ViewNegativeYawLimit=-65536,bExposed=true)
    // binoculars
    DriverPositions(4)=(ViewFOV=12.0,DriverTransitionAnim="stand_idleiron_binoc",ViewPitchUpLimit=10000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=65536,ViewNegativeYawLimit=-65536,bDrawOverlays=true,bExposed=true)

    // Spotting Scope Size
    SpottingScopeOverlay=Texture'DH_VehicleOptics_tex.German.RblF16_artillery_sight'   // TODO: REPLACE
    SpottingScopeSize=0.35

    UnbuttonedPositionIndex=0
    RaisedPositionIndex=3
    BinocPositionIndex=4
    SpottingScopePositionIndex=1

    DriveAnim="crouch_idle_binoc"
    bManualTraverseOnly=true
    bHasAltFire=false
    OverlayCorrectionY=-80
    OverlayCorrectionX=0
    GunsightOverlay=Texture'DH_VehicleOptics_tex.US.m12a7_sight_2' // TODO: believe M12 is panoramic sight for indirect fire; we ought to have direct fire M16 telescopic sight (see http://www.strijdbewijs.nl/tanks/priest.htm)
    GunsightSize=0.40
    DestroyedGunsightOverlay=Texture'DH_VehicleOpticsDestroyed_tex.Allied.Sherman_sight_destroyed'
    AmmoShellTexture=Texture'DH_InterfaceArt_tex.Tank_Hud.ShermanShell'
    AmmoShellReloadTexture=Texture'DH_InterfaceArt_tex.Tank_Hud.ShermanShell_reload'
    FireImpulse=(X=-110000.0)

    YawScaleStep=5.0
    PitchScaleStep=2.0

    RangeTable(0)=(Mils=0,Range=115)
    RangeTable(1)=(Mils=25,Range=200)
    RangeTable(2)=(Mils=55,Range=300)
    RangeTable(3)=(Mils=75,Range=400)
    RangeTable(4)=(Mils=100,Range=500)
    RangeTable(5)=(Mils=125,Range=600)
    RangeTable(6)=(Mils=150,Range=700)
    RangeTable(7)=(Mils=180,Range=800)
    RangeTable(8)=(Mils=205,Range=900)
    RangeTable(9)=(Mils=230,Range=1000)
    RangeTable(10)=(Mils=255,Range=1100)
    RangeTable(11)=(Mils=285,Range=1200)
    RangeTable(12)=(Mils=315,Range=1300)
    RangeTable(13)=(Mils=345,Range=1400)
    RangeTable(14)=(Mils=380,Range=1500)
    RangeTable(15)=(Mils=415,Range=1600)
    RangeTable(16)=(Mils=455,Range=1700)
    RangeTable(17)=(Mils=500,Range=1800)
    RangeTable(18)=(Mils=555,Range=1900)
}


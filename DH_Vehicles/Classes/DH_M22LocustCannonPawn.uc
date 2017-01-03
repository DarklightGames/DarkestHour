//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_M22LocustCannonPawn extends DHAmericanCannonPawn;
/*
function HandleTurretRotation(float DeltaTime, float YawChange, float PitchChange) // TEMP hack fix until rig is fixed
{
    super.HandleTurretRotation(DeltaTime, -YawChange, PitchChange);
}
*/
defaultproperties
{
    GunClass=class'DH_Vehicles.DH_M22LocustCannon'
    DriverPositions(0)=(ViewLocation=(X=12.0,Y=-9.5,Z=7.0),ViewFOV=24.0,TransitionUpAnim="Periscope_in",ViewPitchUpLimit=3641,ViewPitchDownLimit=63352,bDrawOverlays=true)
    // TEMP hacked ViewLocation offsets until anims are made
    DriverPositions(1)=(ViewLocation=(Z=20.0),ViewFOV=90.0,TransitionUpAnim="com_open",ViewPitchUpLimit=1,ViewPitchDownLimit=65535,ViewPositiveYawLimit=65536,ViewNegativeYawLimit=-65536,bDrawOverlays=true)
    DriverPositions(2)=(ViewLocation=(Z=40.0),ViewFOV=90.0,TransitionDownAnim="com_close",DriverTransitionAnim="stand_idlehip_binoc",ViewPitchUpLimit=10000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=65536,ViewNegativeYawLimit=-65536,bExposed=true)
    DriverPositions(3)=(ViewLocation=(Z=40.0),ViewFOV=12.0,DriverTransitionAnim="stand_idleiron_binoc",ViewPitchUpLimit=10000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=65536,ViewNegativeYawLimit=-65536,bDrawOverlays=true,bExposed=true)
    PeriscopePositionIndex=1
    DrivePos=(X=0.0,Y=5.0,Z=-50.0) // SET // TODO: reposition attachment bone to remove need for this offset, then delete this line
    DriveAnim="stand_idlehip_binoc"
    bManualTraverseOnly=true
    GunsightOverlay=texture'DH_VehicleOptics_tex.Allied.Stuart_sight_background'
    OverlayCenterSize=0.542
    DestroyedGunsightOverlay=texture'DH_VehicleOpticsDestroyed_tex.Allied.Stuart_sight_destroyed'
    AmmoShellTexture=texture'DH_InterfaceArt_tex.Tank_Hud.StuartShell'
    AmmoShellReloadTexture=texture'DH_InterfaceArt_tex.Tank_Hud.StuartShell_reload'
}

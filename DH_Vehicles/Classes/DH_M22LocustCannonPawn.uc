//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_M22LocustCannonPawn extends DHAmericanCannonPawn;

exec function SetTex(int Slot) // TEMP
{
    DH_M22LocustTank(VehicleBase).SetTex(Slot);
}

defaultproperties
{
    GunClass=class'DH_Vehicles.DH_M22LocustCannon'
    DriverPositions(0)=(ViewLocation=(X=12.0,Y=-10.0,Z=0.0),ViewFOV=24.0,TransitionUpAnim="Periscope_in",ViewPitchUpLimit=3641,ViewPitchDownLimit=63352,bDrawOverlays=true)
    // TEMP added ViewLocation to fake camera position changes, until anims are made
    DriverPositions(1)=(ViewLocation=(X=-4.0,Y=0.0,Z=12.0),ViewFOV=90.0,TransitionUpAnim="com_open",ViewPitchUpLimit=1,ViewPitchDownLimit=65535,ViewPositiveYawLimit=65536,ViewNegativeYawLimit=-65536,bDrawOverlays=true)
    DriverPositions(2)=(ViewLocation=(X=8.0,Y=1.0,Z=31.0),ViewFOV=90.0,TransitionDownAnim="com_close",DriverTransitionAnim="stand_idlehip_binoc",ViewPitchUpLimit=10000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=65536,ViewNegativeYawLimit=-65536,bExposed=true)
    DriverPositions(3)=(ViewLocation=(X=8.0,Y=1.0,Z=31.0),ViewFOV=12.0,DriverTransitionAnim="stand_idleiron_binoc",ViewPitchUpLimit=10000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=65536,ViewNegativeYawLimit=-65536,bDrawOverlays=true,bExposed=true)
    PeriscopePositionIndex=1
    DrivePos=(X=6.0,Y=1.0,Z=-17.0) // TODO: reposition attachment bone to remove need for this offset, then delete this line
    DriveRot=(Yaw=55536) // have to turn commander to the left so he just about squeezes inside the hatch without clipping the turret
    DriveAnim="stand_idlehip_binoc"
    bManualTraverseOnly=true
    GunsightOverlay=texture'DH_VehicleOptics_tex.Allied.Stuart_sight_background'
    OverlayCenterSize=0.542
    DestroyedGunsightOverlay=texture'DH_VehicleOpticsDestroyed_tex.Allied.Stuart_sight_destroyed'
    AmmoShellTexture=texture'DH_InterfaceArt_tex.Tank_Hud.StuartShell'
    AmmoShellReloadTexture=texture'DH_InterfaceArt_tex.Tank_Hud.StuartShell_reload'
    FireImpulse=(X=-30000.0)
}

//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DH_ChurchillMkVIICannonPawn extends DHBritishCannonPawn;

exec function SetAnim(name NewAnim) // TEMPDEBUG - execs to try different commander animations
{
    if (IsDebugModeAllowed())
    {
        Driver.StopAnimating(true);
        Driver.PlayAnim(NewAnim);
    }
}
exec function SetDTAnim(int Position, name NewAnim)
{
    if (IsDebugModeAllowed())
    {
        Log(Name @ "DriverTransitionAnim for DriverPositions" @ Position @ "=" @ NewAnim @ " was" @ DriverPositions[Position].DriverTransitionAnim);
        DriverPositions[Position].DriverTransitionAnim = NewAnim;
    }
}

defaultproperties
{
    GunClass=class'DH_Vehicles.DH_ChurchillMkVIICannon'
    DriverPositions(0)=(ViewLocation=(X=12.0,Y=-9.5,Z=-0.75),ViewFOV=24.0,bDrawOverlays=true)
    DriverPositions(1)=(ViewLocation=(X=44.0,Y=-8.5,Z=3.0),TransitionUpAnim="com_open",ViewPitchUpLimit=1,ViewPitchDownLimit=0,bDrawOverlays=true)
    DriverPositions(2)=(ViewLocation=(X=5.0,Y=3.0,Z=0.0),TransitionDownAnim="com_close",DriverTransitionAnim="stand_idlehip_binoc",ViewPitchUpLimit=10000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=10000,ViewNegativeYawLimit=-10000,bExposed=true)
    DriverPositions(3)=(ViewFOV=12.0,DriverTransitionAnim="stand_idleiron_binoc",ViewPitchUpLimit=10000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=10000,ViewNegativeYawLimit=-10000,bDrawOverlays=true,bExposed=true)
    PeriscopePositionIndex=1
    DriveAnim="stand_idlehip_binoc"
    DrivePos=(X=-10.0,Y=3.5.0,Z=-10.0) // commander clips the cupola whatever animation or position is used, as hatch is so small - this is as good as I could get it
    GunsightOverlay=texture'DH_VehicleOptics_tex.Allied.Cromwell_sight_background'
    CannonScopeCenter=texture'DH_VehicleOptics_tex.Allied.British_sight_mover'
    DestroyedGunsightOverlay=texture'DH_VehicleOpticsDestroyed_tex.Allied.Cromwell_sight_destroyed'
    AmmoShellTexture=texture'DH_InterfaceArt_tex.Tank_Hud.ShermanShell'
    AmmoShellReloadTexture=texture'DH_InterfaceArt_tex.Tank_Hud.ShermanShell_reload'
    PoweredRotateSound=Sound'Vehicle_Weapons.Turret.electric_turret_traverse'
    PoweredPitchSound=Sound'Vehicle_Weapons.Turret.manual_turret_elevate'
    PoweredRotateAndPitchSound=Sound'Vehicle_Weapons.Turret.electric_turret_traverse'
}

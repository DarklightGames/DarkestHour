//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_Flak38CannonPawn extends DHATGunCannonPawn;

simulated function InitializeCannon() // TEMP
{
    super.InitializeCannon();
    VehicleBase.SetDrawScale(1.5);
    Gun.SetDrawScale(1.5);
}

exec function SetScale(float NewValue) // TEMP
{
    if (NewValue > 0.0)
    {
        VehicleBase.SetDrawScale(NewValue);
        Gun.SetDrawScale(NewValue);
        log("DrawScale =" @ Gun.DrawScale);
    }
}

// Emptied out as shells inherits RangeSettings from Sd.Kfz.234/1 armored car, but flak 38 has no range settings on the gunsight:
function IncrementRange();
function DecrementRange();

// Modified to update sight rotation, if gun pitch has changed
function HandleTurretRotation(float DeltaTime, float YawChange, float PitchChange)
{
    super.HandleTurretRotation(DeltaTime, YawChange, PitchChange);

    if (Level.NetMode != NM_DedicatedServer && PitchChange != 0.0 && !bGunPivotDamaged && DH_Flak38Cannon(Gun) != none)
    {
        DH_Flak38Cannon(Gun).UpdateSightRotation();
    }
}

defaultproperties
{
    OverlayCenterSize=1.0
    CannonScopeOverlay=texture'DH_Artillery_tex.ATGun_Hud.Flakvierling38_sight'
    AmmoShellTexture=texture'DH_InterfaceArt_tex.Tank_Hud.2341Mag'
    AmmoShellReloadTexture=texture'DH_InterfaceArt_tex.Tank_Hud.2341Mag_reload'
    RaisedPositionIndex=2
    DriverPositions(0)=(ViewLocation=(X=30.0),ViewFOV=12.0,PositionMesh=SkeletalMesh'DH_Flak38_anm.Flak38_turret',TransitionUpAnim="optic_out",bDrawOverlays=true,bExposed=true)
    DriverPositions(1)=(ViewFOV=90.0,PositionMesh=SkeletalMesh'DH_Flak38_anm.Flak38_turret',TransitionUpAnim="com_open",TransitionDownAnim="optic_in",bExposed=true)
    DriverPositions(2)=(ViewFOV=90.0,PositionMesh=SkeletalMesh'DH_Flak38_anm.Flak38_turret',TransitionDownAnim="com_close",ViewPitchUpLimit=6000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=20000,ViewNegativeYawLimit=-20000,bExposed=true)
    DriverPositions(3)=(ViewFOV=18.0,PositionMesh=SkeletalMesh'DH_Flak38_anm.Flak38_turret',ViewPitchUpLimit=6000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=20000,ViewNegativeYawLimit=-20000,bDrawOverlays=true,bExposed=true)
    GunClass=class'DH_Guns.DH_Flak38Cannon'
    CameraBone="Camera_com"
    DriveAnim="Vt3485_driver_idle_close"
    DrivePos=(X=0.0,Y=-1.0,Z=17.0)  // TEMP - suits DrawScale of 1.5
}

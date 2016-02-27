//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_Flak38CannonPawn extends DHATGunCannonPawn;

// Modified to update sight rotation, if gun pitch has changed
function HandleTurretRotation(float DeltaTime, float YawChange, float PitchChange)
{
    super.HandleTurretRotation(DeltaTime, YawChange, PitchChange);

    if (Level.NetMode != NM_DedicatedServer && ((YawChange != 0.0 && !bTurretRingDamaged) || (PitchChange != 0.0 && !bGunPivotDamaged)) && DH_Flak38Cannon(Gun) != none)
    {
        DH_Flak38Cannon(Gun).UpdateSightAndWheelRotation();
    }
}

// From Sd.Kfz.234/1 cannon pawn
simulated exec function ROManualReload()
{
    if (DH_Sdkfz2341Cannon(Cannon) != none && Cannon.CannonReloadState == CR_Waiting && DH_Sdkfz2341Cannon(Cannon).HasMagazines(Cannon.GetPendingRoundIndex())
        && ROPlayer(Controller) != none && ROPlayer(Controller).bManualTankShellReloading)
    {
        Cannon.ServerManualReload();
    }
}

// From Sd.Kfz.234/1 cannon pawn
function Fire(optional float F)
{
    if (CanFire() && Cannon != none)
    {
        if (Cannon.CannonReloadState == CR_ReadyToFire && Cannon.bClientCanFireCannon)
        {
            super(VehicleWeaponPawn).Fire(F);
        }
        else if (Cannon.CannonReloadState == CR_Waiting && DH_Sdkfz2341Cannon(Cannon) != none && DH_Sdkfz2341Cannon(Cannon).HasMagazines(Cannon.GetPendingRoundIndex())
            && ROPlayer(Controller) != none && ROPlayer(Controller).bManualTankShellReloading)
        {
            Cannon.ServerManualReload();
        }
    }
}

// From Sd.Kfz.234/1 cannon pawn
function float GetAmmoReloadState()
{
    if (ROTankCannon(Gun) != none)
    {
        switch (ROTankCannon(Gun).CannonReloadState)
        {
            case CR_ReadyToFire:    return 0.0;
            case CR_Waiting:
            case CR_Empty:
            case CR_ReloadedPart1:  return 1.0;
            case CR_ReloadedPart2:  return 0.6;
            case CR_ReloadedPart3:  return 0.5;
            case CR_ReloadedPart4:  return 0.4;
        }
    }

    return 0.0;
}

defaultproperties
{
    OverlayCenterSize=1.0
    CannonScopeOverlay=texture'DH_Artillery_tex.ATGun_Hud.Flakvierling38_sight'
    AmmoShellTexture=texture'DH_InterfaceArt_tex.Tank_Hud.2341Mag'
    AmmoShellReloadTexture=texture'DH_InterfaceArt_tex.Tank_Hud.2341Mag_reload'
    IntermediatePositionIndex=1 // the open sights position (used to play a special 'intermediate' firing anim in that position)
    RaisedPositionIndex=2
    BinocPositionIndex=3
    DriverPositions(0)=(ViewLocation=(X=25.0,Y=0.0,Z=0.0),ViewFOV=12.0,PositionMesh=SkeletalMesh'DH_Flak38_anm.Flak38_turret',TransitionUpAnim="optic_out",bDrawOverlays=true,bExposed=true)
    DriverPositions(1)=(ViewFOV=90.0,PositionMesh=SkeletalMesh'DH_Flak38_anm.Flak38_turret',TransitionUpAnim="lookover_up",TransitionDownAnim="optic_in",bExposed=true)
    DriverPositions(2)=(ViewFOV=90.0,PositionMesh=SkeletalMesh'DH_Flak38_anm.Flak38_turret',TransitionDownAnim="lookover_down",ViewPitchUpLimit=6000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=20000,ViewNegativeYawLimit=-20000,bExposed=true)
    DriverPositions(3)=(ViewFOV=12.0,PositionMesh=SkeletalMesh'DH_Flak38_anm.Flak38_turret',ViewPitchUpLimit=6000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=20000,ViewNegativeYawLimit=-20000,bDrawOverlays=true,bExposed=true)
    GunClass=class'DH_Vehicles.DH_Flak38Cannon'
    bHasFireImpulse=false
    CameraBone="Camera_com"
    DriveAnim="VIS2_driver_idle_close"
    DrivePos=(X=-35.0,Y=26.0,Z=13.0)
}

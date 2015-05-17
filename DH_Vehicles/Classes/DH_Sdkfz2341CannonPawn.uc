//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_Sdkfz2341CannonPawn extends DHGermanTankCannonPawn;

// Modified as need to check if has spare magazines (the normal HasAmmo check returns AmmoCharge, not mags)
simulated exec function ROManualReload()
{
    if (DH_Sdkfz2341Cannon(Cannon) != none && Cannon.CannonReloadState == CR_Waiting && DH_Sdkfz2341Cannon(Cannon).HasMagazines(Cannon.GetPendingRoundIndex())
        && ROPlayer(Controller) != none && ROPlayer(Controller).bManualTankShellReloading)
    {
        Cannon.ServerManualReload();
    }
}

// Modified as need to check if has spare magazines if a manual reload is required (the normal HasAmmo check returns AmmoCharge, not mags)
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

// 1.0 = 0% reloaded, 0.0 = 100% reloaded (e.g. finished reloading)
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

// Modified as 234/1 uses FireCountdown for cannon AND coaxial MG, so we need to check it against both FireInterval & AltFireInterval (in super)
function float GetAltAmmoReloadState()
{
    if (Gun.FireCountdown <= Gun.FireInterval)
    {
        return 0.0;
    }
    else
    {
        return super.GetAltAmmoReloadState();
    }
}

defaultproperties
{
    ScopeCenterScale=0.635
    ScopeCenterRotator=TexRotator'DH_VehicleOptics_tex.German.20mmFlak_sight_center'
    CenterRotationFactor=2048
    OverlayCenterSize=0.73333
    UnbuttonedPositionIndex=1
    DestroyedScopeOverlay=texture'DH_VehicleOpticsDestroyed_tex.German.PZ4_sight_destroyed'
    bManualTraverseOnly=true
    CannonScopeCenter=texture'DH_VehicleOptics_tex.German.tiger_sight_graticule'
    ScopePositionX=0.237
    ScopePositionY=0.15
    BinocPositionIndex=2
    WeaponFOV=30.0
    AmmoShellTexture=texture'DH_InterfaceArt_tex.Tank_Hud.2341Mag'
    AmmoShellReloadTexture=texture'DH_InterfaceArt_tex.Tank_Hud.2341Mag_reload'
    DriverPositions(0)=(ViewLocation=(X=40.0,Y=12.0,Z=3.0),ViewFOV=30.0,PositionMesh=SkeletalMesh'DH_Sdkfz234ArmoredCar_anm.Sdkfz234_turret_ext',TransitionUpAnim="com_open",DriverTransitionAnim="VSU76_com_close",ViewPitchUpLimit=12743,ViewPitchDownLimit=64443,bDrawOverlays=true)
    DriverPositions(1)=(ViewFOV=90.0,PositionMesh=SkeletalMesh'DH_Sdkfz234ArmoredCar_anm.Sdkfz234_turret_ext',TransitionDownAnim="com_close",DriverTransitionAnim="VSU76_com_open",ViewPitchUpLimit=10000,ViewPitchDownLimit=62000,ViewPositiveYawLimit=10000,ViewNegativeYawLimit=-10000,bExposed=true)
    DriverPositions(2)=(ViewFOV=12.0,PositionMesh=SkeletalMesh'DH_Sdkfz234ArmoredCar_anm.Sdkfz234_turret_ext',ViewPitchUpLimit=10000,ViewPitchDownLimit=62000,ViewPositiveYawLimit=10000,ViewNegativeYawLimit=-10000,bDrawOverlays=true,bExposed=true)
    bMustBeTankCrew=true
    FireImpulse=(X=-15000.0)
    GunClass=class'DH_Vehicles.DH_Sdkfz2341Cannon'
    bHasFireImpulse=false
    CameraBone="Gun"
    DrivePos=(X=4.0,Y=-2.0)
    DriveAnim="VSU76_com_idle_close"
    EntryRadius=130.0
    FPCamPos=(X=50.0,Y=-30.0,Z=11.0)
    PitchUpLimit=6000
    PitchDownLimit=64000
    SoundVolume=130
}

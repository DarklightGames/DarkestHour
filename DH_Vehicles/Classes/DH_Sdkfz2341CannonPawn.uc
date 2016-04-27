//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_Sdkfz2341CannonPawn extends DHGermanCannonPawn;

// 1.0 = 0% reloaded, 0.0 = 100% reloaded (e.g. finished reloading)
function float GetAmmoReloadState()
{
    if (Cannon != none)
    {
        switch (Cannon.ReloadState)
        {
            case RL_ReadyToFire:    return 0.0;
            case RL_Waiting:
            case RL_Empty:
            case RL_ReloadedPart1:  return 1.0;
            case RL_ReloadedPart2:  return 0.6;
            case RL_ReloadedPart3:  return 0.5;
            case RL_ReloadedPart4:  return 0.4;
        }
    }

    return 0.0;
}

defaultproperties
{
    ScopeCenterScale=0.635
    ScopeCenterRotator=TexRotator'DH_VehicleOptics_tex.German.20mmFlak_sight_center'
    CenterRotationFactor=2048
    OverlayCenterSize=0.73333
    UnbuttonedPositionIndex=2
    DestroyedScopeOverlay=texture'DH_VehicleOpticsDestroyed_tex.German.PZ4_sight_destroyed'
    bManualTraverseOnly=true
    CannonScopeCenter=texture'DH_VehicleOptics_tex.German.tiger_sight_graticule'
    BinocPositionIndex=3
    AmmoShellTexture=texture'DH_InterfaceArt_tex.Tank_Hud.2341Mag'
    AmmoShellReloadTexture=texture'DH_InterfaceArt_tex.Tank_Hud.2341Mag_reload'
    DriverPositions(0)=(ViewLocation=(X=40.0,Y=12.0,Z=3.0),ViewFOV=30.0,PositionMesh=SkeletalMesh'DH_Sdkfz234ArmoredCar_anm.Sdkfz234_turret_ext',ViewPitchUpLimit=12743,ViewPitchDownLimit=64443,bDrawOverlays=true,bExposed=true)
    DriverPositions(1)=(ViewFOV=90.0,PositionMesh=SkeletalMesh'DH_Sdkfz234ArmoredCar_anm.Sdkfz234_turret_ext',TransitionUpAnim="com_open",ViewPitchUpLimit=10000,ViewPitchDownLimit=62000,ViewPositiveYawLimit=10000,ViewNegativeYawLimit=-10000,bExposed=true)
    DriverPositions(2)=(ViewFOV=90.0,PositionMesh=SkeletalMesh'DH_Sdkfz234ArmoredCar_anm.Sdkfz234_turret_ext',TransitionDownAnim="com_close",DriverTransitionAnim="stand_idlehip_binoc",ViewPitchUpLimit=10000,ViewPitchDownLimit=62000,ViewPositiveYawLimit=10000,ViewNegativeYawLimit=-10000,bExposed=true)
    DriverPositions(3)=(ViewFOV=12.0,PositionMesh=SkeletalMesh'DH_Sdkfz234ArmoredCar_anm.Sdkfz234_turret_ext',DriverTransitionAnim="stand_idleiron_binoc",ViewPitchUpLimit=10000,ViewPitchDownLimit=62000,ViewPositiveYawLimit=10000,ViewNegativeYawLimit=-10000,bDrawOverlays=true,bExposed=true)
    bMustBeTankCrew=true
    FireImpulse=(X=-15000.0)
    GunClass=class'DH_Vehicles.DH_Sdkfz2341Cannon'
    bHasFireImpulse=false
    DrivePos=(X=9.0,Y=1.0,Z=-6.0)
    DriveAnim="stand_idlehip_binoc"
}

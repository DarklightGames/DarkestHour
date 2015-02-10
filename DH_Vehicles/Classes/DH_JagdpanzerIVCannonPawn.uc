//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_JagdpanzerIVCannonPawn extends DH_AssaultGunCannonPawn
    abstract;

defaultproperties
{
    PeriscopeOverlay=texture'DH_VehicleOptics_tex.German.PERISCOPE_overlay_German'
    OverlayCenterSize=0.555000
    PeriscopePositionIndex=1
    bManualTraverseOnly=true
    ManualRotateSound=sound'Vehicle_Weapons.Turret.manual_gun_traverse'
    ManualRotateAndPitchSound=sound'Vehicle_Weapons.Turret.manual_gun_traverse'
    CannonScopeOverlay=texture'DH_VehicleOptics_tex.German.stug3_SflZF1a_sight'
    DestroyedScopeOverlay=texture'DH_VehicleOpticsDestroyed_tex.German.stug3_SflZF1a_destroyed'
    WeaponFOV=14.400000
    bHasAltFire=false
    CameraBone="Turret"
    ManualMinRotateThreshold=0.500000
    ManualMaxRotateThreshold=3.000000
    DrivePos=(X=5.000000,Z=-30.000000)
    DriveAnim="VStug3_com_idle_close"
    EntryRadius=130.000000
    FPCamPos=(Z=5.000000)
    TPCamDistance=300.000000
    TPCamLookat=(X=-25.000000,Z=0.000000)
    TPCamWorldOffset=(Z=120.000000)
    PitchUpLimit=6000
    PitchDownLimit=64000
    SoundVolume=130
}

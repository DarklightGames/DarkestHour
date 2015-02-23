//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_JagdpanzerIVCannonPawn extends DH_AssaultGunCannonPawn
    abstract;

defaultproperties
{
    PeriscopeOverlay=texture'DH_VehicleOptics_tex.German.PERISCOPE_overlay_German'
    OverlayCenterSize=0.555
    PeriscopePositionIndex=1
    bManualTraverseOnly=true
    ManualRotateSound=sound'Vehicle_Weapons.Turret.manual_gun_traverse'
    ManualRotateAndPitchSound=sound'Vehicle_Weapons.Turret.manual_gun_traverse'
    CannonScopeOverlay=texture'DH_VehicleOptics_tex.German.stug3_SflZF1a_sight'
    DestroyedScopeOverlay=texture'DH_VehicleOpticsDestroyed_tex.German.stug3_SflZF1a_destroyed'
    WeaponFOV=14.4
    bHasAltFire=false
    CameraBone="Turret"
    ManualMinRotateThreshold=0.5
    ManualMaxRotateThreshold=3.0
    DrivePos=(X=5.0,Z=-30.0)
    DriveAnim="VStug3_com_idle_close"
    EntryRadius=130.0
    FPCamPos=(Z=5.0)
    TPCamDistance=300.0
    TPCamLookat=(X=-25.0,Z=0.0)
    TPCamWorldOffset=(Z=120.0)
    PitchUpLimit=6000
    PitchDownLimit=64000
    SoundVolume=130
}

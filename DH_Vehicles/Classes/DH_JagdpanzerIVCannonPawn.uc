//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_JagdpanzerIVCannonPawn extends DHAssaultGunCannonPawn
    abstract;

defaultproperties
{
    PeriscopeOverlay=texture'DH_VehicleOptics_tex.German.PERISCOPE_overlay_German'
    OverlayCenterSize=0.555
    PeriscopePositionIndex=1
    CannonScopeOverlay=texture'DH_VehicleOptics_tex.German.stug3_SflZF1a_sight'
    WeaponFOV=14.4
    bHasAltFire=false
    CameraBone="Turret"
    DrivePos=(X=5.0,Z=-30.0)
    DriveAnim="VStug3_com_idle_close"
    EntryRadius=130.0
    PitchUpLimit=6000
    PitchDownLimit=64000
    SoundVolume=130
}

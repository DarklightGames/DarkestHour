//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DHAssaultGunCannonPawn extends DHVehicleCannonPawn
    abstract;

defaultproperties
{
    bManualTraverseOnly=true
    ManualMinRotateThreshold=0.5
    ManualMaxRotateThreshold=3.0
    ManualRotateSound=Sound'Vehicle_Weapons.Turret.manual_gun_traverse'
    ManualRotateAndPitchSound=Sound'Vehicle_Weapons.Turret.manual_gun_traverse'
    DestroyedGunsightOverlay=Texture'DH_VehicleOpticsDestroyed_tex.German.stug3_SflZF1a_destroyed'
    PeriscopeOverlay=Texture'DH_VehicleOptics_tex.German.Sf14z_periscope'
    BinocsOverlay=Texture'DH_VehicleOptics_tex.General.BINOC_overlay_6x30Germ'
}

//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
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
    PeriscopeOverlay=Texture'DH_VehicleOptics_tex.German.Sf14z_periscope' // SF14Z stereo binocular periscope with 10x magnification                                                                         // But have to fudge to approx 8x magnification (ViewFOV=10.67) as for some reason shell tracers aren't visible if FOV is lower
}

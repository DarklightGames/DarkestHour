//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_CromwellMountedMGPawn extends DHVehicleMGPawn;

defaultproperties
{
    GunClass=Class'DH_CromwellMountedMG'
    GunsightOverlay=Texture'DH_VehicleOptics_tex.British.BesaMG_sight'
    GunsightSize=0.469 // 21 degrees visible FOV at 1.9x magnification (No.50 x1.9 Mk IS sight)
    WeaponFOV=44.74
    FPCamPos=(X=5.0,Y=-8.0,Z=-1.0)
    PitchUpLimit=4500
    PitchDownLimit=64000
}

//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_6PounderGunCannonPawn extends DH_AT57CannonPawn;

defaultproperties
{
    GunClass=class'DH_Guns.DH_6PounderGunCannon'
    GunsightOverlay=Texture'DH_VehicleOptics_tex.British.17Pdr_sight_background'
    CannonScopeCenter=Texture'DH_VehicleOptics_tex.British.17Pdr_sight_mover'
    GunsightSize=0.459 // 13 degrees visible FOV at 3x magnification (No.22C Mk.III sight)
    RangeUnit=DU_Yards
}

//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_ShermanTankB_M4A176W extends DH_ShermanTankA_M4A176W; // later version with HVAP instead of smoke rounds, & with muzzle brake & sandbags on hull front

defaultproperties
{
    PassengerWeapons(0)=(WeaponPawnClass=Class'DH_ShermanCannonPawnB_76mm')
    VehicleAttachments(0)=(StaticMesh=StaticMesh'DH_allies_vehicles_stc.ShermanM4A1_sandbags') // sandbags stacked on front hull
    DestroyedVehicleMesh=StaticMesh'DH_allies_vehicles_stc2.ShermanM4A1W_DestB'
    SpawnOverlay(0)=Material'DH_InterfaceArt_tex.sherman_m4a1_76_b'
}

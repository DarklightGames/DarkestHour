//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_AchillesTank extends DH_WolverineTank;

defaultproperties
{
    VehicleNameString="Achilles Mk.IC"
    PassengerWeapons(0)=(WeaponPawnClass=Class'DH_AchillesCannonPawn')
    Skins(0)=Texture'DH_VehiclesUK_tex.Achilles_body_ext'
    Skins(1)=Texture'DH_VehiclesUK_tex.Achilles_turret_ext'
    DestroyedVehicleMesh=StaticMesh'DH_allies_vehicles_stc.Achilles_dest'
    SpawnOverlay(0)=Material'DH_InterfaceArt_tex.achilles'
}

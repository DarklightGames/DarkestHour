//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_JacksonTank_Early extends DH_JacksonTank; // earlier version without HVAP & without muzzle brake

defaultproperties
{
    PassengerWeapons(0)=(WeaponPawnClass=Class'DH_JacksonCannonPawn_Early')
    DestroyedMeshSkins(5)=Texture'DH_VehiclesGE_tex2.ext_vehicles.Alpha' // hides the muzzle brake in the DestroyedVehicleMesh
    SpawnOverlay(0)=Material'DH_InterfaceArt_tex.Vehicles.m36_jackson_early'
}

//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_UniversalCarrierTransport extends DH_BrenCarrierTransport;

defaultproperties
{
    VehicleNameString="Universal Carrier"
    PassengerWeapons(0)=(WeaponPawnClass=Class'DH_UniversalCarrierMGPawn')
    Skins(0)=Texture'allies_vehicles_tex2.universal_carrier'
    DestroyedMeshSkins(0)=Combiner'DH_VehiclesSOV_tex.universal_carrier_dest'
    DestroyedMeshSkins(1)=Combiner'DH_VehiclesSOV_tex.T60_treads_dest'
}

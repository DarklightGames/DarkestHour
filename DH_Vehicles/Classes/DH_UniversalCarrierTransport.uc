//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_UniversalCarrierTransport extends DH_BrenCarrierTransport;

defaultproperties
{
    VehicleNameString="Universal Carrier"
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_UniversalCarrierMGPawn')
    Skins(0)=Texture'allies_vehicles_tex2.ext_vehicles.universal_carrier'
    DestroyedMeshSkins(0)=Combiner'DH_VehiclesSOV_tex.Destroyed.universal_carrier_dest'
    DestroyedMeshSkins(1)=Combiner'DH_VehiclesSOV_tex.Destroyed.T60_treads_dest'
}

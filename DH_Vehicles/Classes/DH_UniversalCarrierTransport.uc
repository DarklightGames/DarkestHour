//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_UniversalCarrierTransport extends DH_BrenCarrierTransport;

#exec OBJ LOAD FILE=..\Textures\DH_VehiclesSOV_tex.utx

defaultproperties
{
    VehicleNameString="Universal Carrier"
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_UniversalCarrierMGPawn')
    Skins(0)=texture'allies_vehicles_tex2.ext_vehicles.universal_carrier'
    DestroyedMeshSkins(0)=combiner'DH_VehiclesSOV_tex.Destroyed.universal_carrier_dest'
}

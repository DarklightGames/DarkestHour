//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_UniversalCarrierTransport_Snow extends DH_UniversalCarrierTransport;

defaultproperties
{
    Skins(0)=texture'allies_vehicles_tex2.ext_vehicles.universal_carrier_Snow'
    Skins(1)=texture'allies_vehicles_tex2.Treads.UCSnow_Tread'
    Skins(2)=texture'allies_vehicles_tex2.Treads.UCSnow_Tread'
    Skins(3)=texture'allies_vehicles_tex2.int_vehicles.Universal_Carrier_SnowInt'
    HighDetailOverlay=material'allies_vehicles_tex2.int_vehicles.Universal_Carrier_SnowInt_S'
    HUDOverlayClass=class'ROVehicles.UniCarrierDriverOverlaySnow'
    DestroyedMeshSkins(0)=combiner'DH_VehiclesSOV_tex.Destroyed.universal_carrier_Snow_dest'
}

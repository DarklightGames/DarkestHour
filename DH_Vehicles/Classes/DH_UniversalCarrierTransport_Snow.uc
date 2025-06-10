//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_UniversalCarrierTransport_Snow extends DH_UniversalCarrierTransport;

defaultproperties
{
    Skins(0)=Texture'allies_vehicles_tex2.ext_vehicles.universal_carrier_Snow'
    Skins(1)=Texture'allies_vehicles_tex2.Treads.UCSnow_Tread'
    Skins(2)=Texture'allies_vehicles_tex2.Treads.UCSnow_Tread'
    Skins(3)=Texture'allies_vehicles_tex2.int_vehicles.Universal_Carrier_SnowInt'
    HighDetailOverlay=Material'allies_vehicles_tex2.int_vehicles.Universal_Carrier_SnowInt_S'
    HUDOverlayClass=Class'UniCarrierDriverOverlaySnow'
    DestroyedMeshSkins(0)=Combiner'DH_VehiclesSOV_tex.Destroyed.universal_carrier_Snow_dest'
}

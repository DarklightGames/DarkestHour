//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_UniversalCarrierTransport_PolishSnow extends DH_UniversalCarrierTransport;

defaultproperties
{
    bIsWinterVariant=true
    Skins(0)=Texture'DH_VehiclesPOL_tex.ext_vehicles.universal_carrier_Snow_polish'
    Skins(1)=Texture'allies_vehicles_tex2.Treads.UCSnow_Tread'
    Skins(2)=Texture'allies_vehicles_tex2.Treads.UCSnow_Tread'
    Skins(3)=Texture'allies_vehicles_tex2.int_vehicles.Universal_Carrier_SnowInt'
    HighDetailOverlay=Material'allies_vehicles_tex2.int_vehicles.Universal_Carrier_SnowInt_S'
    HUDOverlayClass=class'ROVehicles.UniCarrierDriverOverlaySnow'
    bUsesCodedDestroyedSkins=true
}

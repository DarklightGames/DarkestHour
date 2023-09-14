//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_SU76Destroyer_PolishSnow extends DH_SU76Destroyer;

defaultproperties
{
    bIsWinterVariant=true
    Skins(0)=Texture'DH_VehiclesPOL_tex.ext_vehicles.SU76snow_ext_Polish'
    Skins(1)=Texture'allies_vehicles_tex.Treads.SU76_Treadsnow'
    Skins(2)=Texture'allies_vehicles_tex.Treads.SU76_Treadsnow'
    Skins(3)=Texture'allies_vehicles_tex.int_vehicles.SU76Snow_Int'

    CannonSkins(0)=Texture'DH_VehiclesPOL_tex.ext_vehicles.SU76snow_ext_Polish'
    CannonSkins(1)=Texture'allies_vehicles_tex.int_vehicles.SU76Snow_Int'

    bUsesCodedDestroyedSkins=true

    HighDetailOverlay=Material'allies_vehicles_tex.int_vehicles.SU76Snow_int_s'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=3

}

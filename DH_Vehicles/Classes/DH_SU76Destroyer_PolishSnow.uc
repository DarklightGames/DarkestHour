//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_SU76Destroyer_PolishSnow extends DH_SU76Destroyer;

defaultproperties
{
    Skins(0)=Texture'DH_VehiclesPOL_tex.SU76snow_ext_Polish'
    Skins(1)=Texture'allies_vehicles_tex.SU76_Treadsnow'
    Skins(2)=Texture'allies_vehicles_tex.SU76_Treadsnow'
    Skins(3)=Texture'allies_vehicles_tex.SU76Snow_Int'

    CannonSkins(0)=Texture'DH_VehiclesPOL_tex.SU76snow_ext_Polish'
    CannonSkins(1)=Texture'allies_vehicles_tex.SU76Snow_Int'

    bUsesCodedDestroyedSkins=true

    HighDetailOverlay=Material'allies_vehicles_tex.SU76Snow_int_s'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=3

}

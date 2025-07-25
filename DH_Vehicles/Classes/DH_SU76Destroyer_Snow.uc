//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_SU76Destroyer_snow extends DH_SU76Destroyer;

defaultproperties
{
    Skins(0)=Texture'allies_vehicles_tex.SU76Snow_ext'
    Skins(1)=Texture'allies_vehicles_tex.SU76_Treadsnow'
    Skins(2)=Texture'allies_vehicles_tex.SU76_Treadsnow'
    Skins(3)=Texture'allies_vehicles_tex.SU76Snow_Int'

    CannonSkins(0)=Texture'allies_vehicles_tex.SU76Snow_ext'
    CannonSkins(1)=Texture'allies_vehicles_tex.SU76Snow_Int'

    DestroyedMeshSkins(0)=Texture'allies_destroyed_vehicles_tex.SU76_Snow_Destroyed'

    HighDetailOverlay=Material'allies_vehicles_tex.SU76Snow_int_s'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=3

}

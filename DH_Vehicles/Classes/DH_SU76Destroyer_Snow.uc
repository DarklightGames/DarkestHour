//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_SU76Destroyer_snow extends DH_SU76Destroyer;

defaultproperties
{
    bIsWinterVariant=true
    Skins(0)=Texture'allies_vehicles_tex.ext_vehicles.SU76Snow_ext'
    Skins(1)=Texture'allies_vehicles_tex.Treads.SU76_Treadsnow'
    Skins(2)=Texture'allies_vehicles_tex.Treads.SU76_Treadsnow'
    Skins(3)=Texture'allies_vehicles_tex.int_vehicles.SU76Snow_Int'

    CannonSkins(0)=Texture'allies_vehicles_tex.ext_vehicles.SU76Snow_ext'
    CannonSkins(1)=Texture'allies_vehicles_tex.int_vehicles.SU76Snow_Int'

    DestroyedMeshSkins(0)=Texture'allies_destroyed_vehicles_tex.SU76.SU76_Snow_Destroyed'

    HighDetailOverlay=Material'allies_vehicles_tex.int_vehicles.SU76Snow_int_s'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=3

}

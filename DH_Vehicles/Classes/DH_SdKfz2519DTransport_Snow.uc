//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_SdKfz2519DTransport_Snow extends DH_SdKfz2519DTransport;

defaultproperties
{
    bIsWinterVariant=true

    Skins(0)=Texture'DH_VehiclesGE_tex.ext_vehicles.halftrack_body_snow'
    Skins(1)=Texture'axis_vehicles_tex.Treads.Halftrack_treadsnow'
    Skins(2)=Texture'axis_vehicles_tex.Treads.Halftrack_treadsnow'

    CannonSkins(0)=Texture'DH_VehiclesGE_tex8.ext_vehicles.stummel_snow_ext'

    DestroyedMeshSkins(0)=Combiner'DH_VehiclesGE_tex8.Destroyed.stummel_snow_ext_dest'
    DestroyedMeshSkins(1)=Combiner'DH_VehiclesGE_tex.Destroyed.halftrack_snow_dest'
}

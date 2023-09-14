//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_KV1ETank_Snow extends DH_KV1ETank;


defaultproperties
{
    bIsWinterVariant=true
    Skins(0)=Texture'DH_VehiclesSOV_tex.ext_vehicles.KV1_body_snow'
    Skins(1)=Texture'GUP_vehicles_tex.WELT_kv1_treads' // this is a snowy treads version (name is misleading)
    Skins(2)=Texture'GUP_vehicles_tex.WELT_kv1_treads'
    CannonSkins(0)=Texture'DH_VehiclesSOV_tex.ext_vehicles.KV1_body_snow'
    DestroyedMeshSkins(0)=Combiner'DH_VehiclesSOV_tex.destroyed.KV1_body_dest'
}

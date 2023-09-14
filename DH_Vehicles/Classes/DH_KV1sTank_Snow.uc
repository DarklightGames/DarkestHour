//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_KV1sTank_Snow extends DH_KV1sTank;

defaultproperties
{
    bIsWinterVariant=true
    Skins(0)=Texture'GUP_vehicles_tex.WELT_KV1_ext'    // note texture package is distributed with RO, as its vehicles are included in ROCustom.u code package
    Skins(1)=Texture'GUP_vehicles_tex.WELT_kv1_treads' // this is a snowy treads version (name is misleading)
    Skins(2)=Texture'GUP_vehicles_tex.WELT_kv1_treads'
    CannonSkins(0)=Texture'GUP_vehicles_tex.WELT_KV1_ext'
    DestroyedMeshSkins(0)=Combiner'DH_VehiclesSOV_tex.Destroyed.KV1s_ext_winter_dest'
}

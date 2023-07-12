//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_ShermanTank_M4A376W_Snow extends DH_ShermanTank_M4A376W;

defaultproperties
{
    bIsWinterVariant=true
    Skins(0)=Texture'DH_VehiclesUS_tex2.ext_vehicles.ShermanM4A3_ext_snow'
    Skins(1)=Texture'DH_VehiclesUS_tex2.ext_vehicles.ShermanM4A3E2_wheels_snow'
    Skins(4)=Texture'DH_VehiclesUS_tex2.Treads.Sherman_treadsnow'
    Skins(5)=Texture'DH_VehiclesUS_tex2.Treads.Sherman_treadsnow'
    // TODO: make whitewash texture for 76mm turret - this uses a snow-topped texture, which doesn't match when used on the M4A3 whitewashed hull (incl DestroyedMeshSkins 0)
    CannonSkins(0)=Texture'DH_VehiclesUS_tex2.ext_vehicles.Sherman76w_turret_Snow'
    CannonSkins(1)=Texture'DH_VehiclesUS_tex2.ext_vehicles.Sherman_body_snow'
    DestroyedMeshSkins(0)=Combiner'DH_VehiclesUS_tex2.Destroyed.ShermanM4A376_turret_snow_dest'
    DestroyedMeshSkins(1)=Combiner'DH_VehiclesUS_tex2.Destroyed.ShermanM4A3_ext_snow_dest'
    DestroyedMeshSkins(2)=Combiner'DH_VehiclesUS_tex2.Destroyed.ShermanM4A3E2_wheels_snowdest'
}

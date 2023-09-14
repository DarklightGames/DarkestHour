//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_JagdpantherTank_SnowTwo extends DH_JagdpantherTank;

defaultproperties
{
    bIsWinterVariant=true
    Skins(0)=Texture'DH_VehiclesGE_tex3.ext_vehicles.jagdpanther_body_snow2'
    Skins(1)=Texture'DH_VehiclesGE_tex3.Treads.Jagdpanther_treads_snow'
    Skins(2)=Texture'DH_VehiclesGE_tex3.Treads.Jagdpanther_treads_snow'
    CannonSkins(0)=Texture'DH_VehiclesGE_tex3.ext_vehicles.jagdpanther_body_snow2'
    RandomAttachment=(Skins=(Texture'DH_VehiclesGE_tex3.ext_vehicles.Jagdpanther_armor_snow'))
    DestroyedMeshSkins(0)=Combiner'DH_VehiclesGE_tex3.Destroyed.Jagdpanther_snow_dest'
}

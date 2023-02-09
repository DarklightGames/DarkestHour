//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_WolverineTank_Snow extends DH_WolverineTank;

defaultproperties
{
    bIsWinterVariant=true
    Skins(0)=Texture'DH_VehiclesUS_tex2.ext_vehicles.M10_body_snow'
    Skins(1)=Texture'DH_VehiclesUS_tex2.ext_vehicles.M10_turret_snow'
    Skins(2)=Texture'DH_VehiclesUS_tex2.Treads.M10_treadsnow'
    Skins(3)=Texture'DH_VehiclesUS_tex2.Treads.M10_treadsnow'
    CannonSkins(0)=Texture'DH_VehiclesUS_tex2.ext_vehicles.M10_turret_snow'
    CannonSkins(1)=Texture'DH_VehiclesUS_tex2.ext_vehicles.M10_turret_snow'
    DestroyedMeshSkins(0)=Combiner'DH_VehiclesUS_tex2.Destroyed.M10_body_snow_dest'
    DestroyedMeshSkins(1)=Combiner'DH_VehiclesUS_tex2.Destroyed.M10_turret_snow_dest'
}

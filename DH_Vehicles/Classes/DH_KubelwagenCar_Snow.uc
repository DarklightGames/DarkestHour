//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_KubelwagenCar_Snow extends DH_KubelwagenCar_WH;

#exec OBJ LOAD FILE=..\Textures\DH_VehiclesGE_tex3.utx

defaultproperties
{
    Skins(1)=texture'DH_VehiclesGE_tex3.ext_vehicles.kubelwagen_body_snow'
//  DestroyedMeshSkins(0)=combiner'DH_VehiclesGE_tex3.Destroyed.kubelwagen_body_snow_dest' // TODO: make this combiner
}

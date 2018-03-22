//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2018
//==============================================================================

class DH_StuartTank_Snow extends DH_StuartTank;

#exec OBJ LOAD FILE=..\Textures\DH_VehiclesUS_tex2.utx

defaultproperties
{
    Skins(0)=Texture'DH_VehiclesUS_tex2.ext_vehicles.M5_body_snow'
    Skins(2)=Texture'DH_VehiclesUS_tex2.Treads.M5_treadsnow'
    Skins(3)=Texture'DH_VehiclesUS_tex2.Treads.M5_treadsnow'
    CannonSkins(0)=Texture'DH_VehiclesUS_tex2.ext_vehicles.M5_body_snow'
    DestroyedMeshSkins(0)=combiner'DH_VehiclesUS_tex2.Destroyed.M5_body_dest_snow'
}

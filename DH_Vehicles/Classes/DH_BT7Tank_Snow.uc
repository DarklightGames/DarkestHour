//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_BT7Tank_Snow extends DH_BT7Tank;

#exec OBJ LOAD FILE=..\Textures\DH_VehiclesRU_tex.utx

defaultproperties
{
    Skins(0)=texture'DH_VehiclesRU_tex.ext_vehicles.BT7_Snow_ext' // TODO: make snow treads
    CannonSkins(0)=texture'DH_VehiclesRU_tex.ext_vehicles.BT7_Snow_ext'
//  DestroyedMeshSkins(0)=texture'DH_VehiclesRU_tex.Destroyed.BT7_Snow_ext_dest' // TODO: make destroyed snow combiner
}

//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_OpelBlitzTransport_Snow extends DH_OpelBlitzTransport;

#exec OBJ LOAD FILE=..\Textures\DH_VehiclesGE_tex3.utx

static function StaticPrecache(LevelInfo L)
{
    Super.StaticPrecache(L);

    L.AddPrecacheMaterial(Material'DH_VehiclesGE_tex3.ext_vehicles.OpelBlitz_body_snow');


}

simulated function UpdatePrecacheMaterials()
{
    Level.AddPrecacheMaterial(Material'DH_VehiclesGE_tex3.ext_vehicles.OpelBlitz_body_snow');
    Super.UpdatePrecacheMaterials();
}

defaultproperties
{
     Skins(0)=Texture'DH_VehiclesGE_tex3.ext_vehicles.OpelBlitz_body_snow'
}

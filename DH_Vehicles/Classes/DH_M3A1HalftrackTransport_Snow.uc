//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_M3A1HalftrackTransport_Snow extends DH_M3A1HalftrackTransport;

#exec OBJ LOAD FILE=..\Textures\DH_VehiclesUS_tex2.utx

static function StaticPrecache(LevelInfo L)
{
        super.StaticPrecache(L);

      L.AddPrecacheMaterial(Material'DH_VehiclesUS_tex2.ext_vehicles.M3A1Halftrack_body_snow');
      L.AddPrecacheMaterial(Material'DH_VehiclesUS_tex2.treads.M3A1Halftrack_treadsnow');

}

simulated function UpdatePrecacheMaterials()
{
        Level.AddPrecacheMaterial(Material'DH_VehiclesUS_tex2.ext_vehicles.M3A1Halftrack_body_snow');
        Level.AddPrecacheMaterial(Material'DH_VehiclesUS_tex2.treads.M3A1Halftrack_treadsnow');

    super.UpdatePrecacheMaterials();
}

defaultproperties
{
     Skins(0)=Texture'DH_VehiclesUS_tex2.ext_vehicles.M3A1Halftrack_body_snow'
     Skins(5)=Texture'DH_VehiclesUS_tex2.Treads.M3A1Halftrack_treadsnow'
     Skins(6)=Texture'DH_VehiclesUS_tex2.Treads.M3A1Halftrack_treadsnow'
}

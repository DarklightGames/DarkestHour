//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_M3A1HalftrackTransport_British extends DH_M3A1HalftrackTransport;

#exec OBJ LOAD FILE=..\Textures\DH_VehiclesUK_tex.utx

static function StaticPrecache(LevelInfo L)
{
    Super.StaticPrecache(L);

    L.AddPrecacheMaterial(Material'DH_VehiclesUK_tex.ext_vehicles.Brit_M3A1Halftrack_body_ext');
    L.AddPrecacheMaterial(Material'DH_VehiclesUS_tex.int_vehicles.M3A1Halftrack_details_int');
    L.AddPrecacheMaterial(Material'DH_VehiclesUS_tex.int_vehicles.M3A1Halftrack_seats_int');
    L.AddPrecacheMaterial(Material'DH_VehiclesUS_tex.treads.M3A1Halftrack_treads');
}

simulated function UpdatePrecacheMaterials()
{
    Level.AddPrecacheMaterial(Material'DH_VehiclesUK_tex.ext_vehicles.Brit_M3A1Halftrack_body_ext');
    Level.AddPrecacheMaterial(Material'DH_VehiclesUS_tex.int_vehicles.M3A1Halftrack_details_int');
    Level.AddPrecacheMaterial(Material'DH_VehiclesUS_tex.int_vehicles.M3A1Halftrack_seats_int');
    Level.AddPrecacheMaterial(Material'DH_VehiclesUS_tex.treads.M3A1Halftrack_treads');

    Super.UpdatePrecacheMaterials();
}

defaultproperties
{
     DestroyedVehicleMesh=StaticMesh'DH_allies_vehicles_stc.M3A1Halftrack.Brit_M3A1Halftrack_dest'
     Skins(0)=Texture'DH_VehiclesUK_tex.ext_vehicles.Brit_M3A1Halftrack_body_ext'
}

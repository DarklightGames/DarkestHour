//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DH_M3A1HalftrackTransport_British extends DH_M3A1HalftrackTransport;

#exec OBJ LOAD FILE=..\Textures\DH_VehiclesUK_tex.utx

defaultproperties
{
// TODO: we gotta get new skins for this!
//    Skins(0)=texture'DH_VehiclesUK_tex.ext_vehicles.Brit_M3A1Halftrack_body_ext'
    DestroyedVehicleMesh=StaticMesh'DH_allies_vehicles_stc.M3A1Halftrack.Brit_M3A1Halftrack_dest'
}

//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_ShermanTank_British extends DH_ShermanTank;

#exec OBJ LOAD FILE=..\Textures\DH_VehiclesUK_tex.utx

defaultproperties
{
    DestroyedVehicleMesh=StaticMesh'DH_allies_vehicles_stc.Sherman.Brit_Sherman_Dest'
    VehicleNameString="Sherman Mk.II"
    Skins(0)=texture'DH_VehiclesUK_tex.ext_vehicles.Brit_Sherman_body_ext'
    CannonSkins(0)=texture'DH_VehiclesUK_tex.ext_vehicles.Brit_Sherman_body_ext'
}

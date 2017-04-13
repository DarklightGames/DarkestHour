//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_ShermanTank_Camo extends DH_ShermanTank;

#exec OBJ LOAD FILE=..\Textures\DH_VehiclesUS_tex2.utx

defaultproperties
{
    Skins(0)=texture'DH_VehiclesUS_tex.ext_vehicles.Sherman_body_camo1'
    CannonSkins(0)=texture'DH_VehiclesUS_tex.ext_vehicles.Sherman_body_camo1'
    DestroyedVehicleMesh=StaticMesh'DH_allies_vehicles_stc.Sherman.Sherman_Dest2'
}

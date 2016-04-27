//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_ShermanTank_M4A3E2_Snow extends DH_ShermanTank_M4A3E2;

#exec OBJ LOAD FILE=..\Textures\DH_VehiclesUS_tex2.utx

defaultproperties
{
    DestroyedVehicleMesh=StaticMesh'DH_allies_vehicles_stc3.ShermanM4A3.M4A3E2_dest_snow'
    Skins(0)=texture'DH_VehiclesUS_tex2.ext_vehicles.ShermanM4A3E2_ext_snow'
    Skins(1)=texture'DH_VehiclesUS_tex2.ext_vehicles.ShermanM4A3E2_wheels_snow'
    CannonSkins(0)=texture'DH_VehiclesUS_tex2.ext_vehicles.ShermanM4A3E2_turret_snow'
}

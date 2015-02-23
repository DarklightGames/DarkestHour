//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_PanzerIVHFactory extends DH_GermanVehicles;

defaultproperties
{
    RespawnTime=1.0
    bFactoryActive=true
    VehicleClass=class'DH_Vehicles.DH_PanzerIVHTank'
    Mesh=SkeletalMesh'DH_PanzerIV_anm.Panzer4H_body_ext'
    Skins(0)=texture'DH_VehiclesGE_tex3.ext_vehicles.Panzer4J_body_camo1'
    Skins(1)=texture'axis_vehicles_tex.Treads.panzer4F2_treads'
    Skins(2)=texture'axis_vehicles_tex.Treads.panzer4F2_treads'
    Skins(3)=texture'DH_VehiclesGE_tex2.ext_vehicles.Alpha'
    Skins(4)=texture'axis_vehicles_tex.int_vehicles.Panzer4F2_int'
    Skins(5)=texture'DH_VehiclesGE_tex2.ext_vehicles.gear_Stug'
}

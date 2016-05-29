//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_PanzerIVHTank_SnowOne extends DH_PanzerIVHTank; // snow topped version of non-camo tank

defaultproperties
{
    bHasAddedSideArmor=true
    DestroyedVehicleMesh=StaticMesh'DH_German_vehicles_stc.Panzer4H.Panzer4H_Destroyed'
    Skins(0)=texture'DH_VehiclesGE_tex3.ext_vehicles.Panzer4J_body_snow1'
    Skins(1)=texture'axis_vehicles_tex.Treads.panzer4F2_treadsnow'
    Skins(2)=texture'axis_vehicles_tex.Treads.panzer4F2_treadsnow'
    Skins(3)=texture'DH_VehiclesGE_tex3.ext_vehicles.PanzerIV_armor_snow1'
    CannonSkins(0)=texture'DH_VehiclesGE_tex3.ext_vehicles.Panzer4J_body_snow1'
    CannonSkins(1)=texture'DH_VehiclesGE_tex3.ext_vehicles.PanzerIV_armor_snow1'
}

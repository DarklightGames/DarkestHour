//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_PanzerIVHTank_SnowOne extends DH_PanzerIVHTank; // snow topped version of non-camo tank

defaultproperties
{
    bHasAddedSideArmor=true
    DestroyedVehicleMesh=StaticMesh'DH_German_vehicles_stc.Panzer4H.Panzer4H_Destroyed'
    Skins(0)=texture'DH_VehiclesGE_tex3.ext_vehicles.Panzer4J_body_snow1'
    Skins(3)=texture'DH_VehiclesGE_tex3.ext_vehicles.PanzerIV_armor_snow1'
    CannonSkins(0)=texture'DH_VehiclesGE_tex3.ext_vehicles.Panzer4J_body_snow1'
    CannonSkins(1)=texture'DH_VehiclesGE_tex3.ext_vehicles.PanzerIV_armor_snow1'
}

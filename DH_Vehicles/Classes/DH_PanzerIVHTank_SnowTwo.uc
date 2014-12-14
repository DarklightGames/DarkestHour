//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_PanzerIVHTank_SnowTwo extends DH_PanzerIVHTank;

static function StaticPrecache(LevelInfo L)
{
    super.StaticPrecache(L);

    L.AddPrecacheMaterial(Material'DH_VehiclesGE_tex3.ext_vehicles.Panzer4J_body_snow1');
    L.AddPrecacheMaterial(Material'DH_VehiclesGE_tex3.ext_vehicles.PanzerIV_armor_snow2');
}

simulated function UpdatePrecacheMaterials()
{
    Level.AddPrecacheMaterial(Material'DH_VehiclesGE_tex3.ext_vehicles.Panzer4J_body_snow1');
    Level.AddPrecacheMaterial(Material'DH_VehiclesGE_tex3.ext_vehicles.PanzerIV_armor_snow2');

    super.UpdatePrecacheMaterials();
}

defaultproperties
{
    bHasAddedSideArmor=true
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_PanzerIVHCannonPawn_SnowTwo')
    DestroyedVehicleMesh=StaticMesh'DH_German_vehicles_stc.Panzer4H.Panzer4H_Destroyed2'
    VehicleHudImage=Texture'InterfaceArt2_tex.Tank_Hud.panzer4H_body'
    Skins(0)=Texture'DH_VehiclesGE_tex3.ext_vehicles.Panzer4J_body_snow1'
    Skins(3)=Texture'DH_VehiclesGE_tex3.ext_vehicles.PanzerIV_armor_snow2'
}

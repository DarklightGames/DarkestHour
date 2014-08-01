//==============================================================================
// DH_PanzerIVHTank_CamoTwo
//
// Darkest Hour Source - (c) Darkest Hour Team 2010
// Red Orchestra Source - (c) Tripwire Interactive 2006
//
// German Panzer IV Ausf. H tank
//==============================================================================
class DH_PanzerIVHTank_CamoTwo extends DH_PanzerIVHTank;


static function StaticPrecache(LevelInfo L)
{
    Super.StaticPrecache(L);

    L.AddPrecacheMaterial(Material'DH_VehiclesGE_tex3.ext_vehicles.Panzer4J_body_ext');
    L.AddPrecacheMaterial(Material'DH_VehiclesGE_tex.ext_vehicles.PanzerIV_armor_camo2');
}

simulated function UpdatePrecacheMaterials()
{
    Level.AddPrecacheMaterial(Material'DH_VehiclesGE_tex3.ext_vehicles.Panzer4J_body_ext');
    Level.AddPrecacheMaterial(Material'DH_VehiclesGE_tex.ext_vehicles.PanzerIV_armor_camo2');

	Super.UpdatePrecacheMaterials();
}

defaultproperties
{
     bHasAddedSideArmor=true
     PassengerWeapons(0)=(WeaponPawnClass=Class'DH_Vehicles.DH_PanzerIVHCannonPawn_CamoTwo')
     DestroyedVehicleMesh=StaticMesh'DH_German_vehicles_stc.Panzer4H.Panzer4H_Destroyed2'
     VehicleHudImage=Texture'InterfaceArt2_tex.Tank_Hud.panzer4H_body'
     Skins(0)=Texture'DH_VehiclesGE_tex3.ext_vehicles.panzer4J_body_ext'
     Skins(3)=Texture'DH_VehiclesGE_tex.ext_vehicles.PanzerIV_armor_camo2'
}

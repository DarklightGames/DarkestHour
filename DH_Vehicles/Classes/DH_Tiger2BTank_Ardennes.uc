//===================================================================
// Tiger2BTank_Ardennes (Tiger II #322 at Ardennes Offensive - Dec. 1944)
//
// Original Content - Tripwire Interactive Copyright (C) 2004-2008
// Models,Animations,Statics, and Textures: Paul Pepera (c) 2007-2008 (Capt.Obvious)
// Coding and Sound Editing: Eric Parris (c) 2008 (Shurek)
//
// Konigstiger,King Tiger,Tiger II - Pzkpfw VI Ausf B (SdKfz 182)
//===================================================================
class DH_Tiger2BTank_Ardennes extends DH_Tiger2BTank;


static function StaticPrecache(LevelInfo L)
{
    Super.StaticPrecache(L);

    L.AddPrecacheMaterial(Material'DH_VehiclesGE_tex3.ext_vehicles.Tiger2B_body_ardennes');
    L.AddPrecacheMaterial(Material'DH_VehiclesGE_tex2.treads.Tiger2B_treads');
    L.AddPrecacheMaterial(Material'DH_VehiclesGE_tex2.int_vehicles.Tiger2B_body_int');

}

simulated function UpdatePrecacheMaterials()
{
    Level.AddPrecacheMaterial(Material'DH_VehiclesGE_tex3.ext_vehicles.Tiger2B_body_ardennes');
    Level.AddPrecacheMaterial(Material'DH_VehiclesGE_tex2.treads.Tiger2B_treads');
    Level.AddPrecacheMaterial(Material'DH_VehiclesGE_tex2.int_vehicles.Tiger2B_body_int');

    Super.UpdatePrecacheMaterials();
}

defaultproperties
{
     PassengerWeapons(0)=(WeaponPawnClass=Class'DH_Vehicles.DH_Tiger2BCannonPawn_Ardennes')
     DestroyedVehicleMesh=StaticMesh'DH_German_vehicles_stc2.Tiger2B.Tiger2B_dest2'
     Skins(0)=Texture'DH_VehiclesGE_tex3.ext_vehicles.tiger2B_body_ardennes'
}

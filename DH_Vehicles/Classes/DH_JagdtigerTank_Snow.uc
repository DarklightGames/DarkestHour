//===================================================================
// JagdtigerTank
//
// Original Content - Tripwire Interactive Copyright (C) 2004-2008
// Models, Statics, and Textures: Paul Pepera (c) 2007-2008 (Capt. Obvious)
// Animation and rigging: TT33 (2010)
// Coding and Sound Editing: Eric Parris (c) 2010 (Shurek)
//
// Jagdtiger - Panzerjäger VI Ausf.B (SdKfz 186)
//===================================================================
class DH_JagdtigerTank_Snow extends DH_JagdtigerTank;

#exec OBJ LOAD FILE=..\textures\DH_VehiclesGE_tex3.utx

static function StaticPrecache(LevelInfo L)
{
    Super.StaticPrecache(L);

    L.AddPrecacheMaterial(Material'DH_VehiclesGE_tex3.ext_vehicles.jagdtiger_body_snow');
    L.AddPrecacheMaterial(Material'DH_VehiclesGE_tex3.ext_vehicles.jagdtiger_skirtwinter');

}

simulated function UpdatePrecacheMaterials()
{
    Level.AddPrecacheMaterial(Material'DH_VehiclesGE_tex3.ext_vehicles.jagdtiger_body_snow');
    Level.AddPrecacheMaterial(Material'DH_VehiclesGE_tex3.ext_vehicles.jagdtiger_skirtwinter');
    Super.UpdatePrecacheMaterials();
}

defaultproperties
{
     PassengerWeapons(0)=(WeaponPawnClass=Class'DH_Vehicles.DH_JagdtigerCannonPawn_Snow')
     DestroyedVehicleMesh=StaticMesh'DH_German_vehicles_stc2.Jagdtiger.Jagdtiger_destsnow'
     Skins(0)=Texture'DH_VehiclesGE_tex3.ext_vehicles.JagdTiger_body_snow'
     Skins(4)=Texture'DH_VehiclesGE_tex3.ext_vehicles.JagdTiger_skirtwinter'
}

//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_TigerTank_Snow extends DH_TigerTank;

static function StaticPrecache(LevelInfo L)
{
    super(ROTreadCraft).StaticPrecache(L);

    L.AddPrecacheMaterial(Material'axis_vehicles_tex.ext_vehicles.Titger1snow_ext');
    L.AddPrecacheMaterial(Material'axis_vehicles_tex.Treads.Tiger1_treadsnow');
    L.AddPrecacheMaterial(Material'axis_vehicles_tex.int_vehicles.tiger1_int');
    L.AddPrecacheMaterial(Material'axis_vehicles_tex.int_vehicles.tiger1_int_s');
}

simulated function UpdatePrecacheMaterials()
{
    Level.AddPrecacheMaterial(Material'axis_vehicles_tex.ext_vehicles.Titger1snow_ext');
    Level.AddPrecacheMaterial(Material'axis_vehicles_tex.Treads.Tiger1_treadsnow');
    Level.AddPrecacheMaterial(Material'axis_vehicles_tex.int_vehicles.tiger1_int');
    Level.AddPrecacheMaterial(Material'axis_vehicles_tex.int_vehicles.tiger1_int_s');

    super(ROTreadCraft).UpdatePrecacheMaterials();
}

defaultproperties
{
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_TigerCannonPawn_Snow')
    DestroyedVehicleMesh=StaticMesh'axis_vehicles_stc.Tiger1.Tiger1_Snow_Destroyed'
    Skins(0)=Texture'axis_vehicles_tex.ext_vehicles.Titger1snow_ext'
    Skins(1)=Texture'axis_vehicles_tex.Treads.Tiger1_treadsnow'
    Skins(2)=Texture'axis_vehicles_tex.Treads.Tiger1_treadsnow'
}

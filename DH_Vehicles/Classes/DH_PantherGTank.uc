//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_PantherGTank extends DH_PantherDTank;

static function StaticPrecache(LevelInfo L)
{
    super.StaticPrecache(L);

    L.AddPrecacheMaterial(Material'axis_vehicles_tex.ext_vehicles.pantherg_ext');
    L.AddPrecacheMaterial(Material'axis_vehicles_tex.Treads.PantherG_treads');
    L.AddPrecacheMaterial(Material'axis_vehicles_tex.int_vehicles.pantherg_int');
    L.AddPrecacheMaterial(Material'axis_vehicles_tex.int_vehicles.pantherg_int_s');
}

simulated function UpdatePrecacheMaterials()
{
    Level.AddPrecacheMaterial(Material'axis_vehicles_tex.ext_vehicles.pantherg_ext');
    Level.AddPrecacheMaterial(Material'axis_vehicles_tex.Treads.PantherG_treads');
    Level.AddPrecacheMaterial(Material'axis_vehicles_tex.int_vehicles.pantherg_int');
    Level.AddPrecacheMaterial(Material'axis_vehicles_tex.int_vehicles.pantherg_int_s');

    super.UpdatePrecacheMaterials();
}

defaultproperties
{
     UFrontArmorFactor=8.200000
     URightArmorFactor=5.000000
     ULeftArmorFactor=5.000000
     URightArmorSlope=30.000000
     ULeftArmorSlope=30.000000
     PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_PantherGCannonPawn')
     VehiclePositionString="in a Panzer V Ausf.G"
     VehicleNameString="Panzer V Ausf.G"
}

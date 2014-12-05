//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_JacksonTank_Snow extends DH_JacksonTank;

static function StaticPrecache(LevelInfo L)
{
    super.StaticPrecache(L);

    L.AddPrecacheMaterial(Material'DH_VehiclesUS_tex5.ext_vehicles.M36_Bodysnow_ext');
    L.AddPrecacheMaterial(Material'DH_VehiclesUS_tex5.ext_vehicles.M36_turretsnow_ext');
}

simulated function UpdatePrecacheMaterials()
{
    Level.AddPrecacheMaterial(Material'DH_VehiclesUS_tex5.ext_vehicles.M36_Bodysnow_ext');
    Level.AddPrecacheMaterial(Material'DH_VehiclesUS_tex5.ext_vehicles.M36_turretsnow_ext');

    super.UpdatePrecacheMaterials();
}

defaultproperties
{
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_JacksonCannonPawn_Snow',WeaponBone="Turret_placement")
    Skins(0)=texture'DH_VehiclesUS_tex5.ext_vehicles.M36_Bodysnow_ext'
    Skins(1)=texture'DH_VehiclesUS_tex5.ext_vehicles.M36_turretsnow_ext'
}

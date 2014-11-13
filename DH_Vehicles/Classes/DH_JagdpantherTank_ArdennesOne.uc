//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_JagdpantherTank_ArdennesOne extends DH_JagdpantherTank;


static function StaticPrecache(LevelInfo L)
{
    Super.StaticPrecache(L);

    L.AddPrecacheMaterial(Material'DH_VehiclesGE_tex3.ext_vehicles.Jagdpanther_body_ardennes');
    L.AddPrecacheMaterial(Material'DH_VehiclesGE_tex2.treads.jagdpanther_treads');
    L.AddPrecacheMaterial(Material'DH_VehiclesGE_tex2.int_vehicles.jagdpanther_walls_int');
    L.AddPrecacheMaterial(Material'DH_VehiclesGE_tex2.int_vehicles.jagdpanther_body_int');
}

simulated function UpdatePrecacheMaterials()
{
    Level.AddPrecacheMaterial(Material'DH_VehiclesGE_tex3.ext_vehicles.Jagdpanther_body_ardennes');
    Level.AddPrecacheMaterial(Material'DH_VehiclesGE_tex2.treads.jagdpanther_treads');
    Level.AddPrecacheMaterial(Material'DH_VehiclesGE_tex2.int_vehicles.jagdpanther_walls_int');
    Level.AddPrecacheMaterial(Material'DH_VehiclesGE_tex2.int_vehicles.jagdpanther_body_int');

    Super.UpdatePrecacheMaterials();
}

defaultproperties
{
     PassengerWeapons(0)=(WeaponPawnClass=Class'DH_Vehicles.DH_JagdpantherCannonPawn_ArdennesOne')
     Skins(0)=Texture'DH_VehiclesGE_tex3.ext_vehicles.jagdpanther_body_ardennes'
     SchurzenTexture=Texture'DH_VehiclesGE_tex3.ext_vehicles.Jagdpanther_armor_ardennes'
}

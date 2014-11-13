//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_StuartTank_Snow extends DH_StuartTank;

#exec OBJ LOAD FILE=..\textures\DH_VehiclesUS_tex2.utx

static function StaticPrecache(LevelInfo L)
{
        Super.StaticPrecache(L);

        L.AddPrecacheMaterial(Material'DH_VehiclesUS_Tex2.ext_vehicles.M5_body_snow');
        L.AddPrecacheMaterial(Material'DH_VehiclesUS_Tex2.treads.M5_treadsnow');
}

simulated function UpdatePrecacheMaterials()
{
        Level.AddPrecacheMaterial(Material'DH_VehiclesUS_Tex2.ext_vehicles.M5_body_snow');
        Level.AddPrecacheMaterial(Material'DH_VehiclesUS_Tex2.treads.M5_treadsnow');

    Super.UpdatePrecacheMaterials();
}

defaultproperties
{
     PassengerWeapons(0)=(WeaponPawnClass=Class'DH_Vehicles.DH_StuartCannonPawn_Snow')
     Skins(0)=Texture'DH_VehiclesUS_tex2.ext_vehicles.M5_body_snow'
     Skins(2)=Texture'DH_VehiclesUS_tex2.Treads.M5_treadsnow'
     Skins(3)=Texture'DH_VehiclesUS_tex2.Treads.M5_treadsnow'
}

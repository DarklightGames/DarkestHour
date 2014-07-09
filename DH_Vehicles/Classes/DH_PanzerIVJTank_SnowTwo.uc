//==============================================================================
// DH_PanzerIVJTank_SnowTwo
//
// Darkest Hour Source - (c) Darkest Hour Team 2010
// Red Orchestra Source - (c) Tripwire Interactive 2006
//
// German Panzer IV Ausf. J tank - snow two variant
//==============================================================================
class DH_PanzerIVJTank_SnowTwo extends DH_PanzerIVJTank;


#exec OBJ LOAD FILE=..\textures\DH_VehiclesGE_tex5.utx

static function StaticPrecache(LevelInfo L)
{
    Super.StaticPrecache(L);

    L.AddPrecacheMaterial(Material'DH_VehiclesGE_tex3.ext_vehicles.Panzer4J_body_snow2');
    L.AddPrecacheMaterial(Material'DH_VehiclesGE_tex3.ext_vehicles.Panzer4J_armor_camo1');

}

simulated function UpdatePrecacheMaterials()
{
    Level.AddPrecacheMaterial(Material'DH_VehiclesGE_tex3.ext_vehicles.Panzer4J_body_snow2');
    Level.AddPrecacheMaterial(Material'DH_VehiclesGE_tex3.ext_vehicles.Panzer4J_armor_camo1');

	Super.UpdatePrecacheMaterials();
}

defaultproperties
{
     PassengerWeapons(0)=(WeaponPawnClass=Class'DH_Vehicles.DH_PanzerIVJCannonPawn_SnowTwo')
     Skins(0)=Texture'DH_VehiclesGE_tex3.ext_vehicles.Panzer4J_body_snow2'
     Skins(7)=Texture'DH_VehiclesGE_tex3.ext_vehicles.Panzer4J_armor_camo1'
}
